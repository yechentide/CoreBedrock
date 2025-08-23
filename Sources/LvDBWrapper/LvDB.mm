//
// Created by yechentide on 2024/06/01
//

#import "LvDB.h"
#import "LvDBIterator.h"
#import "LvDBWriteBatch.h"
#import "LvDBWriteBatch+Internal.h"
#import "DebugLog.h"

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

- (id)initWithDBPath:(NSString *)path createIfMissing:(BOOL)createIfMissing error:(NSError **)error {
    if (self = [super init]) {
        options.create_if_missing = createIfMissing;
        options.write_buffer_size = 4 * 1024 * 1024;                            // Create a 4mb write buffer, to improve compression and touch the disk less
        // options.block_cache = leveldb::NewLRUCache(40 * 1024 * 1024);        // Create a 40 mb cache (we use this on ~1gb devices)
        // options.block_size = 163840;
        options.compressors[0] = new leveldb::ZlibCompressorRaw(-1);            // Use the new raw-zip compressor to write (and read)
        options.compressors[1] = new leveldb::ZlibCompressor();                 // Also setup the old, slower compressor for backwards compatibility. This will only be used to read old compressed blocks.
        options.filter_policy = leveldb::NewBloomFilterPolicy(10);              // Create a bloom filter to quickly tell if a key is in the database or not

        readOptions.decompress_allocator = new leveldb::DecompressAllocator();
        writeOptions.sync = false;

        auto dbPath = [path UTF8String];
        leveldb::DB* lvdb;
        leveldb::Status status = leveldb::DB::Open(options, dbPath, &lvdb);
        if (status.ok()) {
            DebugLog(@"leveldb::DB opened: %s", dbPath);
            db.reset(lvdb);
            DebugLog(@"LvDB initialized: %s", dbPath);
        } else if (error) {
            NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
            *error = [NSError errorWithDomain:@"LvDBWrapper"
                                         code:(NSInteger)status.code()
                                     userInfo:@{NSLocalizedDescriptionKey: msg}];
        }
    }
    return self;
}

- (id)initWithDBPath:(NSString *)path error:(NSError **)error {
    return [self initWithDBPath:path createIfMissing:NO error:error];
}

- (void)dealloc {
    [self close];
    DebugLog(@"LvDB deallocated.");
}

- (void)close {
    if (db == nullptr) {
        return;
    }
    db.reset();
    delete options.compressors[0];
    delete options.compressors[1];
    delete options.filter_policy;
    delete readOptions.decompress_allocator;
    DebugLog(@"leveldb::DB closed.");
}

- (BOOL)isClosed {
    return db == nullptr ? YES : NO;
}

- (BOOL)contains:(NSData *)key {
    if (db == nullptr || key == nil) {
        return NO;
    }

    leveldb::Slice dbKey((const char *)[key bytes], [key length]);
    std::unique_ptr<leveldb::Iterator> it(db->NewIterator(readOptions));
    it->Seek(dbKey);
    if (it->Valid() && it->key() == dbKey) {
        return YES;
    } else {
        return NO;
    }
}

/* ---------- Iterator Methods ---------- */

- (void)assignError:(NSError **)error code:(NSInteger)code message:(NSString *)message {
    if (error) {
        *error = [NSError errorWithDomain:@"LvDBWrapper"
                                     code:code
                                 userInfo:@{ NSLocalizedDescriptionKey : message }];
    }
}

- (LvDBIterator *)makeIterator:(NSError **)error {
    if (db == nullptr) {
        [self assignError:error code:-1 message:@"DB Closed"];
        return nil;
    }
    auto dbIterator = db->NewIterator(readOptions);
    DebugLog(@"leveldb::Iterator generated.");
    return [[LvDBIterator alloc] initFromIterator:dbIterator];
}

/* ---------- Key-Value Operations ---------- */

- (NSData *)get:(NSData *)key error:(NSError **)error {
    if (db == nullptr) {
        [self assignError:error code:-1 message:@"DB Closed"];
        return nil;
    }
    leveldb::Slice dbKey((const char *)[key bytes], [key length]);
    std::string value;
    leveldb::Status status = db->Get(readOptions, dbKey, &value);
    if (status.ok()) {
        return [NSData dataWithBytes:value.data() length:value.size()];
    }
    NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
    [self assignError:error code:(NSInteger)status.code() message:msg];
    return nil;
}

- (BOOL)put:(NSData *)key :(NSData *)data error:(NSError **)error {
    if (db == nullptr) {
        [self assignError:error code:-1 message:@"DB Closed"];
        return NO;
    }
    leveldb::Slice dbKey((const char *)[key bytes], [key length]);
    leveldb::Slice newData((const char *)[data bytes], [data length]);

    leveldb::Status status = db->Put(writeOptions, dbKey, newData);
    if (status.ok()) {
        return YES;
    }
    NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
    [self assignError:error code:(NSInteger)status.code() message:msg];
    return NO;
}

- (BOOL)remove:(NSData *)key error:(NSError **)error {
    if (db == nullptr) {
        [self assignError:error code:-1 message:@"DB Closed"];
        return NO;
    }
    leveldb::Slice dbKey((const char *)[key bytes], [key length]);
    leveldb::Status status = db->Delete(writeOptions, dbKey);
    if (status.ok()) {
        return YES;
    }
    NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
    [self assignError:error code:(NSInteger)status.code() message:msg];
    return NO;
}

/* ---------- Batch Operations ---------- */

- (BOOL)writeBatch:(LvDBWriteBatch *)writeBatch error:(NSError **)error {
    if (db == nullptr) {
        [self assignError:error code:-1 message:@"DB Closed"];
        return NO;
    }
    if (writeBatch == nil) {
        return YES;
    }

    leveldb::WriteBatch* leveldbBatch = static_cast<leveldb::WriteBatch *>([writeBatch getWriteBatch]);
    if (!leveldbBatch) {
        return YES;
    }

    leveldb::Status status = db->Write(writeOptions, leveldbBatch);
    if (status.ok()) {
        return YES;
    }

    NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
    [self assignError:error code:(NSInteger)status.code() message:msg];
    return NO;
}

/* ---------- Database Maintenance ---------- */

- (BOOL)compactRangeWithBegin:(NSData *)begin end:(NSData *)end error:(NSError **)error {
    if (db == nullptr) {
        [self assignError:error code:-1 message:@"DB Closed"];
        return NO;
    }
    leveldb::Slice* beginSlice = nullptr;
    leveldb::Slice* endSlice = nullptr;
    if (begin) {
        beginSlice = new leveldb::Slice((const char *)[begin bytes], [begin length]);
    }
    if (end) {
        endSlice = new leveldb::Slice((const char *)[end bytes], [end length]);
    }

    DebugLog(@"Compacting range in database...");
    db->CompactRange(beginSlice, endSlice);
    DebugLog(@"Range compaction completed.");

    delete beginSlice;
    delete endSlice;
    return YES;
}

@end
