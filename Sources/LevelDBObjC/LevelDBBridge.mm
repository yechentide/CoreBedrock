//
// Created by yechentide on 2024/06/01
//

#import "LevelDBBridge.h"
#import "LevelDBBridgeIterator.h"
#import "LevelDBBridgeWriteBatch.h"
#import "LevelDBBridgeWriteBatch+Internal.h"
#import "DebugLog.h"

#import <iostream>
#import <memory>
#import "leveldb/db.h"
#import "leveldb/slice.h"
#import "leveldb/write_batch.h"
#import "leveldb/filter_policy.h"
#import "leveldb/cache.h"
#import "leveldb/decompress_allocator.h"

@implementation LevelDBBridge {
    std::unique_ptr<leveldb::DB> db;
    leveldb::Options options;
    leveldb::ReadOptions readOptions;
    leveldb::WriteOptions writeOptions;
    NSHashTable<LevelDBBridgeIterator *> *activeIterators;
}

- (id)initWithDBPath:(NSString *)path createIfMissing:(BOOL)createIfMissing error:(NSError **)error {
    if (self = [super init]) {
        activeIterators = [NSHashTable weakObjectsHashTable];

        options.create_if_missing = createIfMissing;
        options.write_buffer_size = 4 * 1024 * 1024;                            // Create a 4mb write buffer, to improve compression and touch the disk less
        // options.block_cache = leveldb::NewLRUCache(40 * 1024 * 1024);        // Create a 40 mb cache (we use this on ~1gb devices)
        // options.block_size = 163840;
        options.compression = leveldb::kZlibRawCompression;
        options.filter_policy = leveldb::NewBloomFilterPolicy(10);              // Create a bloom filter to quickly tell if a key is in the database or not

        readOptions.decompress_allocator = new leveldb::DecompressAllocator();
        writeOptions.sync = true;

        auto dbPath = [path UTF8String];
        leveldb::DB* lvdb;
        leveldb::Status status = leveldb::DB::Open(options, dbPath, &lvdb);
        if (status.ok()) {
            DebugLog(@"leveldb::DB opened: %s", dbPath);
            db.reset(lvdb);
            DebugLog(@"LevelDBBridge initialized: %s", dbPath);
        } else if (error) {
            NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
            *error = [NSError errorWithDomain:@"LevelDBObjC"
                                         code:-1
                                     userInfo:@{NSLocalizedDescriptionKey: msg}];
            return nil;
        }
    }
    return self;
}

- (id)initWithDBPath:(NSString *)path error:(NSError **)error {
    return [self initWithDBPath:path createIfMissing:NO error:error];
}

- (void)dealloc {
    [self close];
    DebugLog(@"LevelDBBridge deallocated.");
}

- (void)close {
    @synchronized (self) {
        if (db == nullptr) {
            return;
        }

        // Destroy all active iterators before releasing DB-owned read resources.
        NSArray<LevelDBBridgeIterator *> *iterators = [activeIterators allObjects];
        for (LevelDBBridgeIterator *iterator in iterators) {
            [iterator destroy];
        }
        [activeIterators removeAllObjects];
        DebugLog(@"Destroyed %lu active iterators.", (unsigned long)iterators.count);

        db.reset();
        delete options.filter_policy;
        options.filter_policy = nullptr;
        delete readOptions.decompress_allocator;
        readOptions.decompress_allocator = nullptr;
        DebugLog(@"leveldb::DB closed.");
    }
}

- (void)deregisterIterator:(LevelDBBridgeIterator *)iterator {
    @synchronized (self) {
        [activeIterators removeObject:iterator];
    }
}

- (BOOL)isClosed {
    @synchronized (self) {
        return db == nullptr ? YES : NO;
    }
}

- (BOOL)has:(NSData *)key {
    @synchronized (self) {
        if (db == nullptr || key == nil) {
            return NO;
        }

        try {
            leveldb::Slice dbKey((const char *)[key bytes], [key length]);
            std::unique_ptr<leveldb::Iterator> it(db->NewIterator(readOptions));
            it->Seek(dbKey);
            if (it->Valid() && it->key() == dbKey) {
                return YES;
            }
        } catch (...) {
            return NO;
        }
        return NO;
    }
}

/* ---------- Iterator Methods ---------- */

- (void)assignError:(NSError **)error message:(NSString *)message {
    if (error) {
        *error = [NSError errorWithDomain:@"LevelDBObjC"
                                     code:-1
                                 userInfo:@{ NSLocalizedDescriptionKey : message }];
    }
}

- (LevelDBBridgeIterator *)newIterator:(NSError **)error {
    @synchronized (self) {
        if (db == nullptr) {
            [self assignError:error message:@"DB Closed"];
            return nil;
        }
        try {
            auto dbIterator = db->NewIterator(readOptions);
            DebugLog(@"leveldb::Iterator generated.");
            LevelDBBridgeIterator *iterator = [[LevelDBBridgeIterator alloc] initFromIterator:dbIterator parentDB:self];
            [activeIterators addObject:iterator];
            return iterator;
        } catch (...) {
            [self assignError:error message:@"Failed to create DB iterator"];
            return nil;
        }
    }
}

/* ---------- Key-Value Operations ---------- */

- (NSData *)get:(NSData *)key error:(NSError **)error {
    @synchronized (self) {
        if (db == nullptr) {
            [self assignError:error message:@"DB Closed"];
            return nil;
        }
        try {
            leveldb::Slice dbKey((const char *)[key bytes], [key length]);
            std::string value;
            leveldb::Status status = db->Get(readOptions, dbKey, &value);
            if (status.ok()) {
                return [NSData dataWithBytes:value.data() length:value.size()];
            }
            NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
            [self assignError:error message:msg];
        } catch (...) {
            [self assignError:error message:@"Failed to read DB value"];
        }
        return nil;
    }
}

- (BOOL)put:(NSData *)key :(NSData *)data error:(NSError **)error {
    @synchronized (self) {
        if (db == nullptr) {
            [self assignError:error message:@"DB Closed"];
            return NO;
        }
        try {
            leveldb::Slice dbKey((const char *)[key bytes], [key length]);
            leveldb::Slice newData((const char *)[data bytes], [data length]);

            leveldb::Status status = db->Put(writeOptions, dbKey, newData);
            if (status.ok()) {
                return YES;
            }
            NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
            [self assignError:error message:msg];
        } catch (...) {
            [self assignError:error message:@"Failed to write DB value"];
        }
        return NO;
    }
}

- (BOOL)remove:(NSData *)key error:(NSError **)error {
    @synchronized (self) {
        if (db == nullptr) {
            [self assignError:error message:@"DB Closed"];
            return NO;
        }
        try {
            leveldb::Slice dbKey((const char *)[key bytes], [key length]);
            leveldb::Status status = db->Delete(writeOptions, dbKey);
            if (status.ok()) {
                return YES;
            }
            NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
            [self assignError:error message:msg];
        } catch (...) {
            [self assignError:error message:@"Failed to remove DB value"];
        }
        return NO;
    }
}

/* ---------- Batch Operations ---------- */

- (BOOL)write:(LevelDBBridgeWriteBatch *)writeBatch error:(NSError **)error {
    @synchronized (self) {
        if (db == nullptr) {
            [self assignError:error message:@"DB Closed"];
            return NO;
        }
        if (writeBatch == nil) {
            return YES;
        }

        leveldb::WriteBatch* leveldbBatch = static_cast<leveldb::WriteBatch *>([writeBatch getWriteBatch]);
        if (!leveldbBatch) {
            return YES;
        }

        try {
            leveldb::Status status = db->Write(writeOptions, leveldbBatch);
            if (status.ok()) {
                return YES;
            }

            NSString *msg = [NSString stringWithUTF8String:status.ToString().c_str()];
            [self assignError:error message:msg];
        } catch (...) {
            [self assignError:error message:@"Failed to write DB batch"];
        }
        return NO;
    }
}

/* ---------- Database Maintenance ---------- */

- (BOOL)compactRange:(NSData *)begin end:(NSData *)end error:(NSError **)error {
    @synchronized (self) {
        if (db == nullptr) {
            [self assignError:error message:@"DB Closed"];
            return NO;
        }

        try {
            leveldb::Slice beginSlice;
            leveldb::Slice endSlice;
            leveldb::Slice* beginSlicePtr = nullptr;
            leveldb::Slice* endSlicePtr = nullptr;
            if (begin) {
                beginSlice = leveldb::Slice((const char *)[begin bytes], [begin length]);
                beginSlicePtr = &beginSlice;
            }
            if (end) {
                endSlice = leveldb::Slice((const char *)[end bytes], [end length]);
                endSlicePtr = &endSlice;
            }

            DebugLog(@"Compacting range in database...");
            db->CompactRange(beginSlicePtr, endSlicePtr);
            DebugLog(@"Range compaction completed.");
            return YES;
        } catch (...) {
            [self assignError:error message:@"Failed to compact DB range"];
            return NO;
        }
    }
}

@end
