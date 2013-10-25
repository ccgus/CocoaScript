//
//  MOMapTable.h
//  Mocha
//
//  Created by Logan Collins on 8/6/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOMapTable
 * @abstract A lightweight object map table
 * 
 * @discussion
 * MOMapTable is useful in situations where object-to-object hashes are desired.
 * NSDictionary is not always sufficient due to the fact that keys must be copyable.
 * NSMapTable is not available on iOS 5 and earlier.
 * 
 * Note: MOMapTable is *not* a zeroing-weak collection.
 */
@interface MOMapTable : NSObject <NSFastEnumeration> {
    CFMutableDictionaryRef _dictionary;
}

/*!
 * @method mapTableWithStrongToStrongObjects
 * @abstract Creates a new map table that strongly retains both its keys and values
 * 
 * @result A MOMapTable object
 */
+ (MOMapTable *)mapTableWithStrongToStrongObjects;

/*!
 * @method mapTableWithStrongToUnretainedObjects
 * @abstract Creates a new map table that strongly retains its keys
 * 
 * @result A MOMapTable object
 */
+ (MOMapTable *)mapTableWithStrongToUnretainedObjects;

/*!
 * @method mapTableWithUnretainedToStrongObjects
 * @abstract Creates a new map table that strongly retains its values
 * 
 * @result A MOMapTable object
 */
+ (MOMapTable *)mapTableWithUnretainedToStrongObjects;

/*!
 * @method mapTableWithUnretainedToUnretainedObjects
 * @abstract Creates a new map table that does not strongly retains its keys or values
 * 
 * @result A MOMapTable object
 */
+ (MOMapTable *)mapTableWithUnretainedToUnretainedObjects;


/*!
 * @method keyEnumerator
 * @abstract Gets an enumerator for the collection's key values
 * 
 * @result An NSEnumerator object
 */
- (NSEnumerator *)keyEnumerator;

/*!
 * @method objectEnumerator
 * @abstract Gets an enumerator for the collection's object values
 * 
 * @result An NSEnumerator object
 */
- (NSEnumerator *)objectEnumerator;


/*!
 * @method count
 * @abstract The number of objects in the map table
 * 
 * @result An NSUInteger value
 */
- (NSUInteger)count;

/*!
 * @method allKeys
 * @abstract Gets all key objects
 * 
 * @result An NSArray object
 */
- (NSArray *)allKeys;

/*!
 * @method allValues
 * @abstract Gets all value objects
 * 
 * @result An NSArray object
 */
- (NSArray *)allObjects;


/*!
 * @method objectForKey:
 * @abstract Gets the object for a particular key
 * 
 * @discussion
 * If an object with the specified key is not in the collection
 * this method returns nil.
 * 
 * @result An object, or nil
 */
- (id)objectForKey:(id)key;

/*!
 * @method setObject:forKey:
 * @abstract Sets an object for a particular key
 * 
 * @param value
 * The value to set
 * 
 * @param key
 * The key to set
 * 
 * @discussion
 * If an object already exists for the specified key it is replaced.
 * If value or key is nil this method raises an NSInvalidArgumentException.
 */
- (void)setObject:(id)value forKey:(id)key;

/*!
 * @method removeObjectForKey:
 * @abstract Removes the object for a particular key
 * 
 * @param key
 * The key to set
 * 
 * @discussion
 * If no object exists for the specified key this method has no effect.
 * If key is nil this method raises an NSInvalidArgumentException.
 */
- (void)removeObjectForKey:(id)key;

/*!
 * @method removeAllObjects
 * @abstract Removes all objects from the collection
 */
- (void)removeAllObjects;

@end
