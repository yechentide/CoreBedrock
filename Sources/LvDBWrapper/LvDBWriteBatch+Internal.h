//
// Created by yechentide on 2025/08/22
//

#ifndef LvDBWriteBatch_Internal_h
#define LvDBWriteBatch_Internal_h

#import "LvDBWriteBatch.h"

@interface LvDBWriteBatch (Internal)

/**
 * Get the underlying leveldb WriteBatch
 * @return Pointer to the leveldb WriteBatch
 */
- (void*)getWriteBatch;

@end

#endif /* LvDBWriteBatch_Internal_h */
