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
 */
- (void)close;

/**
 * Check if a key exists in the database
 * @param key Key to check for existence
 * @return YES if key exists, NO otherwise
 */
- (BOOL)contains:(NSData *)key;

/**
 * Create an iterator for traversing the database
 * @return LvDBIterator instance for database iteration
 */
- (LvDBIterator *)makeIterator:(NSError **)error;

/**
 * Get value for a specified key
 * @param key Key to retrieve value for
 * @return NSData containing the value, or empty data if key doesn't exist
 */
- (NSData *)get:(NSData *)key error:(NSError **)error;

/**
 * Put or update a key-value pair
 * @param key Key for the data
 * @param data Value data to store
 */
- (BOOL)put:(NSData *)key :(NSData *)data error:(NSError **)error;

/**
 * Delete a key-value pair from the database
 * @param key Key to remove
 */
- (BOOL)remove:(NSData *)key error:(NSError **)error;

/**
 * Apply a write batch to the database
 * @param writeBatch Batch of operations to apply
 */
- (BOOL)writeBatch:(LvDBWriteBatch *)writeBatch error:(NSError **)error;

/**
 * Compact the database in the specified range
 * @param begin Beginning of the range (can be nil for start of database)
 * @param end End of the range (can be nil for end of database)
 */
- (BOOL)compactRangeWithBegin:(NSData *)begin end:(NSData *)end error:(NSError **)error;

@end

#endif /* LvDB_h */
