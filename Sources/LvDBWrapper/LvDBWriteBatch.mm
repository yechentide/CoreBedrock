//
// Created by yechentide on 2025/08/22
//

#import "LvDBWriteBatch.h"
#import "DebugLog.h"

#import <memory>
#import "leveldb/write_batch.h"
#import "leveldb/slice.h"
#import "leveldb/status.h"

@implementation LvDBWriteBatch {
    std::unique_ptr<leveldb::WriteBatch> writeBatch;
}

- (id)init {
    if (self = [super init]) {
        leveldb::WriteBatch* wb = new leveldb::WriteBatch();
        writeBatch.reset(wb);
        DebugLog(@"LvDBWriteBatch initialized.");
    }
    return self;
}

- (void)dealloc {
    DebugLog(@"LvDBWriteBatch deallocated.");
}

- (void)put:(NSData *)key value:(NSData *)value {
    if (!key || !value) {
        DebugLog(@"Error: Key or value is nil");
        return;
    }
    leveldb::Slice keySlice((const char *)[key bytes], [key length]);
    leveldb::Slice valueSlice((const char *)[value bytes], [value length]);
    writeBatch->Put(keySlice, valueSlice);
}

- (void)remove:(NSData *)key {
    if (!key) {
        return;
    }
    leveldb::Slice keySlice((const char *)[key bytes], [key length]);
    writeBatch->Delete(keySlice);
}

- (void)clear {
    writeBatch->Clear();
}

- (size_t)approximateSize {
    return writeBatch->ApproximateSize();
}

- (leveldb::WriteBatch*)getWriteBatch {
    return writeBatch.get();
}

@end
