//
// Created by yechentide on 2024/06/01
//

#import "LvDBIterator.h"

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
        NSLog(@"[LvDBWrapper] LvDBIterator generated.");
    }
    return self;
}

- (void)dealloc {
    NSLog(@"[LvDBWrapper] LvDBIterator deallocated.");
}

- (void)destroy {
    NSLog(@"[LvDBWrapper] leveldb::Iterator destroyed.");
    iterator.reset();
}

- (void)seekToFirst {
    iterator->SeekToFirst();
}

- (void)seekToLast {
    iterator->SeekToLast();
}

- (void)seek:(NSData *)key {
    leveldb::Slice dbKey = leveldb::Slice((const char *)[key bytes], [key length]);
    iterator->Seek(dbKey);
}

- (void)next {
    iterator->Next();
}

- (void)prev {
    iterator->Prev();
}

- (BOOL)valid {
    return iterator->Valid();
}

- (NSData *)key {
    leveldb::Slice key = iterator->key();
    return [[NSData alloc] initWithBytes:key.data() length:key.size()];
}

- (NSData *)value {
    leveldb::Slice value = iterator->value();
    return [[NSData alloc] initWithBytes:value.data() length:value.size()];
}

@end
