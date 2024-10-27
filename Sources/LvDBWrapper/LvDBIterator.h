//
// Created by yechentide on 2024/06/01
//

#ifndef Header_h
#define Header_h

#import <Foundation/Foundation.h>

@interface LvDBIterator : NSObject

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

#endif /* Header_h */
