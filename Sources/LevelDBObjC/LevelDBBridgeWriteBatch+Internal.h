//
// Created by yechentide on 2025/08/22
//

#ifndef LevelDBBridgeWriteBatch_Internal_h
#define LevelDBBridgeWriteBatch_Internal_h

#import "LevelDBBridgeWriteBatch.h"

@interface LevelDBBridgeWriteBatch (Internal)

/**
 * Get the underlying leveldb WriteBatch
 * @return Pointer to the leveldb WriteBatch
 */
- (void*)getWriteBatch;

@end

#endif /* LevelDBBridgeWriteBatch_Internal_h */
