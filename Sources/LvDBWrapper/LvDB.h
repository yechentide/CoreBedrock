//
// Created by yechentide on 2024/06/01
//

#ifndef LvDB_h
#define LvDB_h

#import <Foundation/Foundation.h>

@class LvDBIterator;
@class LvDBWriteBatch;

@interface LvDB : NSObject

@property (nonatomic,readonly) BOOL isClosed;

/**
 * Initialize database with specified path
 * @param path Database file path
 * @param createIfMissing Whether to create database if it doesn't exist
 */
- (id)initWithDBPath:(NSString *)path createIfMissing:(BOOL)createIfMissing error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/**
 * Initialize database with specified path (doesn't create if missing)
 * @param path Database file path
 */
- (id)initWithDBPath:(NSString *)path error:(NSError **)error;

/**
 * Default initializer is not available
 * Use other initializers instead
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Close the database and release resources
 * Also destroys all active iterators created by this database
 */
- (void)close;

/**
 * Internal method to deregister an iterator when it's manually destroyed
 * @param iterator Iterator to deregister
 */
- (void)deregisterIterator:(LvDBIterator *)iterator;

/**
 * Check if a key exists in the database
 * @param key Key to check for existence
 * @return YES if key exists, NO otherwise
 */
- (BOOL)has:(NSData *)key NS_SWIFT_NAME(has(_:));

/**
 * Create an iterator for traversing the database
 * @return LvDBIterator instance for database iteration
 */
- (LvDBIterator *)newIterator:(NSError **)error NS_SWIFT_NAME(newIterator());

/**
 * Get value for a specified key
 * @param key Key to retrieve value for
 * @return NSData containing the value, or empty data if key doesn't exist
 */
- (NSData *)get:(NSData *)key error:(NSError **)error NS_SWIFT_NAME(get(_:));

/**
 * Put or update a key-value pair
 * @param key Key for the data
 * @param data Value data to store
 */
- (BOOL)put:(NSData *)key :(NSData *)data error:(NSError **)error NS_SWIFT_NAME(put(_:_:));

/**
 * Delete a key-value pair from the database
 * @param key Key to remove
 */
- (BOOL)remove:(NSData *)key error:(NSError **)error NS_SWIFT_NAME(remove(_:));

/**
 * Apply a write batch to the database
 * @param writeBatch Batch of operations to apply
 */
- (BOOL)write:(LvDBWriteBatch *)writeBatch error:(NSError **)error NS_SWIFT_NAME(write(_:));

/**
 * Compact the database in the specified range
 * @param begin Beginning of the range (can be nil for start of database)
 * @param end End of the range (can be nil for end of database)
 */
- (BOOL)compactRange:(NSData *)begin end:(NSData *)end error:(NSError **)error NS_SWIFT_NAME(compactRange(_:_:));

@end

#endif /* LvDB_h */
