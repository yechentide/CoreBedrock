//
// Created by yechentide on 2024/06/01
//

#import "LvDBIterator.h"
#import "DebugLog.h"

#import <iostream>
#import <memory>
#import "leveldb/db.h"

@implementation LvDBIterator {
    std::unique_ptr<leveldb::Iterator> iterator;
}

- (id)initFromIterator:(void *)dbIterator {
    if (self = [super init]) {
        leveldb::Iterator* it = static_cast<leveldb::Iterator*>(dbIterator);
        iterator.reset(it);
        DebugLog(@"LvDBIterator initialized.");
    }
    return self;
}

- (void)dealloc {
    [self destroy];
    DebugLog(@"LvDBIterator deallocated.");
}

- (void)destroy {
    if (iterator == nullptr) {
        return;
    }
    iterator.reset();
    DebugLog(@"leveldb::Iterator destroyed.");
}

- (BOOL)isDestroyed {
    return iterator == nullptr ? YES : NO;
}

- (void)seekToFirst {
    if (iterator == nullptr) {
        return;
    }
    iterator->SeekToFirst();
}

- (void)seekToLast {
    if (iterator == nullptr) {
        return;
    }
    iterator->SeekToLast();
}

- (void)seek:(NSData *)key {
    if (iterator == nullptr) {
        return;
    }
    leveldb::Slice dbKey = leveldb::Slice((const char *)[key bytes], [key length]);
    iterator->Seek(dbKey);
}

- (void)next {
    if (iterator == nullptr) {
        return;
    }
    iterator->Next();
}

- (void)prev {
    if (iterator == nullptr) {
        return;
    }
    iterator->Prev();
}

- (BOOL)valid {
    if (iterator == nullptr) {
        return NO;
    }
    return iterator->Valid();
}

- (NSData *)key {
    if (iterator == nullptr) {
        return nil;
    }
    leveldb::Slice key = iterator->key();
    return [[NSData alloc] initWithBytes:key.data() length:key.size()];
}

- (NSData *)value {
    if (iterator == nullptr) {
        return nil;
    }
    leveldb::Slice value = iterator->value();
    return [[NSData alloc] initWithBytes:value.data() length:value.size()];
}

@end
