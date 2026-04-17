//
// Created by yechentide on 2024/06/01
//

#ifndef LevelDBBridgeIterator_h
#define LevelDBBridgeIterator_h

#import <Foundation/Foundation.h>

@class LevelDBBridge;

@interface LevelDBBridgeIterator : NSObject

@property (nonatomic,readonly) BOOL isDestroyed;

- (id)initFromIterator:(void *)dbIterator parentDB:(LevelDBBridge *)parentDB;
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

#endif /* LevelDBBridgeIterator_h */
