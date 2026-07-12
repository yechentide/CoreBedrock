//
// Created by yechentide on 2024/06/01
//

#import "LevelDBBridgeIterator.h"
#import "LevelDBBridge.h"
#import "DebugLog.h"

#import <iostream>
#import <memory>
#import "leveldb/db.h"

@implementation LevelDBBridgeIterator {
    std::unique_ptr<leveldb::Iterator> iterator;
    __weak LevelDBBridge *parentDB;
}

- (id)lockedTarget {
    LevelDBBridge *parent = parentDB;
    return parent ?: self;
}

- (id)initFromIterator:(void *)dbIterator parentDB:(LevelDBBridge *)parent {
    if (self = [super init]) {
        leveldb::Iterator* it = static_cast<leveldb::Iterator*>(dbIterator);
        iterator.reset(it);
        parentDB = parent;
        DebugLog(@"LevelDBBridgeIterator initialized.");
    }
    return self;
}

- (void)dealloc {
    [self destroy];
    DebugLog(@"LevelDBBridgeIterator deallocated.");
}

- (void)destroy {
    @synchronized ([self lockedTarget]) {
        if (iterator == nullptr) {
            return;
        }
        iterator.reset();

        // Deregister from parent DB if it still exists
        if (parentDB != nil) {
            [parentDB deregisterIterator:self];
            parentDB = nil;
        }

        DebugLog(@"leveldb::Iterator destroyed.");
    }
}

- (BOOL)isDestroyed {
    @synchronized ([self lockedTarget]) {
        return iterator == nullptr ? YES : NO;
    }
}

- (void)seekToFirst {
    @synchronized ([self lockedTarget]) {
        if (iterator == nullptr) {
            return;
        }
        try {
            iterator->SeekToFirst();
        } catch (...) {
            iterator.reset();
        }
    }
}

- (void)seekToLast {
    @synchronized ([self lockedTarget]) {
        if (iterator == nullptr) {
            return;
        }
        try {
            iterator->SeekToLast();
        } catch (...) {
            iterator.reset();
        }
    }
}

- (void)seek:(NSData *)key {
    @synchronized ([self lockedTarget]) {
        if (iterator == nullptr) {
            return;
        }
        try {
            leveldb::Slice dbKey = leveldb::Slice((const char *)[key bytes], [key length]);
            iterator->Seek(dbKey);
        } catch (...) {
            iterator.reset();
        }
    }
}

- (void)next {
    @synchronized ([self lockedTarget]) {
        if (iterator == nullptr) {
            return;
        }
        try {
            iterator->Next();
        } catch (...) {
            iterator.reset();
        }
    }
}

- (void)prev {
    @synchronized ([self lockedTarget]) {
        if (iterator == nullptr) {
            return;
        }
        try {
            iterator->Prev();
        } catch (...) {
            iterator.reset();
        }
    }
}

- (BOOL)valid {
    @synchronized ([self lockedTarget]) {
        if (iterator == nullptr) {
            return NO;
        }
        try {
            return iterator->Valid();
        } catch (...) {
            iterator.reset();
            return NO;
        }
    }
}

- (NSData *)key {
    @synchronized ([self lockedTarget]) {
        if (iterator == nullptr || !iterator->Valid()) {
            return nil;
        }
        try {
            leveldb::Slice key = iterator->key();
            return [[NSData alloc] initWithBytes:key.data() length:key.size()];
        } catch (...) {
            iterator.reset();
            return nil;
        }
    }
}

- (NSData *)value {
    @synchronized ([self lockedTarget]) {
        if (iterator == nullptr || !iterator->Valid()) {
            return nil;
        }
        try {
            leveldb::Slice value = iterator->value();
            return [[NSData alloc] initWithBytes:value.data() length:value.size()];
        } catch (...) {
            iterator.reset();
            return nil;
        }
    }
}

@end
