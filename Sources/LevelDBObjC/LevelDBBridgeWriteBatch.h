//
// Created by yechentide on 2025/08/22
//

#ifndef LevelDBBridgeWriteBatch_h
#define LevelDBBridgeWriteBatch_h

#import <Foundation/Foundation.h>

@interface LevelDBBridgeWriteBatch : NSObject

/**
 * Add a key-value pair to the batch
 * @param key Key data to store
 * @param value Value data to store
 */
- (void)put:(NSData *)key value:(NSData *)value;

/**
 * Delete a key from the batch
 * @param key Key data to delete
 */
- (void)remove:(NSData *)key;

/**
 * Clear all operations in the batch
 */
- (void)clear;

/**
 * Get the approximate size of the batch
 * @return Approximate size of the batch in bytes
 */
- (size_t)approximateSize;

@end

#endif /* LevelDBBridgeWriteBatch_h */
