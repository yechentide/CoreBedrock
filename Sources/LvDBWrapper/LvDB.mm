//
// Created by yechentide on 2024/06/01
//

#import "LvDB.h"
#import "LvDBIterator.h"

#import <iostream>
#import <memory>
#import "leveldb/db.h"
#import "leveldb/slice.h"
#import "leveldb/write_batch.h"
#import "leveldb/filter_policy.h"
#import "leveldb/cache.h"
#import "leveldb/zlib_compressor.h"
#import "leveldb/decompress_allocator.h"

@implementation LvDB {
    std::unique_ptr<leveldb::DB> db;
    leveldb::Options options;
    leveldb::ReadOptions readOptions;
    leveldb::WriteOptions writeOptions;
}

- (id)initWithDBPath:(NSString *)path {
    if (self = [super init]) {
        options.create_if_missing = false;
        options.filter_policy = leveldb::NewBloomFilterPolicy(10);              //create a bloom filter to quickly tell if a key is in the database or not
        options.block_cache = leveldb::NewLRUCache(40 * 1024 * 1024);           //create a 40 mb cache (we use this on ~1gb devices)
        options.write_buffer_size = 4 * 1024 * 1024;                            //create a 4mb write buffer, to improve compression and touch the disk less
        options.compressors[0] = new leveldb::ZlibCompressorRaw(-1);            //use the new raw-zip compressor to write (and read)
        options.compressors[1] = new leveldb::ZlibCompressor();                 //also setup the old, slower compressor for backwards compatibility. This will only be used to read old compressed blocks.
        // options.block_size = 163840;

        readOptions.decompress_allocator = new leveldb::DecompressAllocator();
        // writeOptions = leveldb::WriteOptions();

        auto dbPath = [path UTF8String];
        leveldb::DB* tmp;
        leveldb::Status status = leveldb::DB::Open(options, dbPath, &tmp);
        if (!status.ok()) {
            std::cout << "[LvDBWrapper] Failed to open the db: " << dbPath << std::endl;
            return nil;
        }
        db.reset(tmp);
        std::cout << "[LvDBWrapper] LevelDB opened: " << dbPath << std::endl;
    }
    return self;
}

- (void)dealloc {
    std::cout << "[LvDBWrapper] LevelDB deallocated." << std::endl;
}

- (void)close {
    db.reset();
    delete options.filter_policy;
    delete options.block_cache;
    delete options.compressors[0];
    delete options.compressors[1];
    delete readOptions.decompress_allocator;
    std::cout << "[LvDBWrapper] LevelDB closed." << std::endl;
}

/* ---------- ---------- ---------- ---------- ---------- ---------- */

- (LvDBIterator *)makeIterator {
    auto dbIterator = db->NewIterator(readOptions);
    return [[LvDBIterator alloc] initFromIterator:dbIterator];
}

/// Iterate through all keys and data that exist between the given keys.
/// @param start The key to start at. Leave as nil to start at the first.
/// @param end The key to end at. Leave as nil to end at the last.
/// @return a array that odd indexes for keys, even indexes for values
- (NSArray *)iterate:(NSData *)start :(NSData *)end {
    leveldb::Iterator *it = db->NewIterator(readOptions);
    NSMutableArray *array = [[NSMutableArray alloc] init];

    if (start) {
        leveldb::Slice pos = leveldb::Slice((const char *)[start bytes], [start length]);
        it->Seek(pos);
    } else {
        it->SeekToFirst();
    }

    while (it->Valid()) {
        auto k = it->key();
        NSData *key = [[NSData alloc] initWithBytes:k.data() length:k.size()];
        if (end != nil && key > end) { break; }
        [array addObject:key];

        auto v = it->value();
        NSData *value = [[NSData alloc] initWithBytes:v.data() length:v.size()];
        [array addObject:value];

        it->Next();
    }
    delete it;
    return (NSArray *)array;
}

/* ---------- ---------- ---------- ---------- ---------- ---------- */

/// Get value with a specified key.
/// @param key a leveldb key
/// @return NSData, empty if the key does not exist
- (NSData *)get:(NSData *)key {
    leveldb::Slice dbKey = leveldb::Slice((const char *)[key bytes], [key length]);
    std::string value;

    leveldb::Status status = db->Get(readOptions, dbKey, &value);
    if (status.ok()) {
        return [NSData dataWithBytes:value.data() length:value.length()];
    }
    return [[NSData alloc] init];
}

/// Add or Update value with a specified key.
/// @param key a leveldb key
/// @param data new data
/// @return BOOL
- (BOOL)put:(NSData *)key :(NSData *)data {
    leveldb::Slice dbKey = leveldb::Slice((const char *)[key bytes], [key length]);
    leveldb::Slice newData = leveldb::Slice((const char *)[data bytes], [data length]);

    leveldb::Status status = db->Put(writeOptions, dbKey, newData);
    return status.ok();
}

/// Add or Update value with specified keys using batch.
/// @param dict a dictionary that contains keys and values
/// @return BOOL
- (BOOL)putBatch:(NSDictionary *)dict {
    leveldb::WriteBatch batch;
    for (id key in dict) {
        leveldb::Slice dbKey = leveldb::Slice((const char *)[key bytes], [key length]);
        NSData *data = [dict objectForKey:key];
        leveldb::Slice newData = leveldb::Slice((const char *)[data bytes], [data length]);
        batch.Put(dbKey, newData);
    }
    leveldb::Status status = db->Write(writeOptions, &batch);
    return status.ok();
}

/// Delete a specified key.
/// @param key a leveldb key
/// @return BOOL
- (BOOL)remove:(NSData *)key {
    leveldb::Slice dbKey = leveldb::Slice((const char *)[key bytes], [key length]);
    leveldb::Status status = db->Delete(writeOptions, dbKey);
    return status.ok();
}

/// Delete specified keys using batch.
/// @param keys a leveldb key's array
/// @return BOOL
- (BOOL)removeBatch:(NSArray *)keys {
    leveldb::WriteBatch batch;
    for (id key in keys) {
        leveldb::Slice dbKey = leveldb::Slice((const char *)[key bytes], [key length]);
        batch.Delete(dbKey);
    }
    leveldb::Status status = db->Write(writeOptions, &batch);
    return status.ok();
}

- (BOOL)contains:(NSData *)key {
    leveldb::Slice dbKey = leveldb::Slice((const char *)[key bytes], [key length]);
    std::string value;
    leveldb::Status status = db->Get(readOptions, dbKey, &value);
    return status.ok();
}

@end
