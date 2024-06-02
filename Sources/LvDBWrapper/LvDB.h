//
// Created by yechentide on 2024/06/01
//

#ifndef LvDB_h
#define LvDB_h

#import <Foundation/Foundation.h>
@class LvDBIterator;

@interface LvDB : NSObject

- (id)initWithDBPath:(NSString *)path;
- (void)close;

- (LvDBIterator *)makeIterator;
- (NSArray *)iterate:(NSData *)start :(NSData *)end;

- (NSData *)get:(NSData *)key;
- (BOOL)put:(NSData *)key :(NSData *)data;
- (BOOL)putBatch:(NSDictionary *) dict;
- (BOOL)remove:(NSData *)key;
- (BOOL)removeBatch:(NSArray *)keys;

- (BOOL)contains:(NSData *)key;

@end

#endif /* LvDB_h */
