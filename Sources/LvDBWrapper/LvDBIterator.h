//
// Created by yechentide on 2024/06/01
//

#ifndef LvDBIterator_h
#define LvDBIterator_h

#import <Foundation/Foundation.h>

@interface LvDBIterator : NSObject

@property (nonatomic,readonly) BOOL isDestroyed;

- (id)initFromIterator:(void *)dbIterator;
- (void)destroy;

- (void)seekToFirst;
- (void)seekToLast;
- (void)seek:(NSData *)key;
- (void)next;
- (void)prev;
- (BOOL)valid;
- (NSData *)key;
- (NSData *)value;

@end

#endif /* LvDBIterator_h */
