//
//  MOJavaScriptObject.h
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOJavaScriptObject
 * @abstract A thin wrapper around a pure JavaScript object
 */
@interface MOJavaScriptObject : NSObject

/*!
 * @property prototype
 * @abstract Gets the object's prototype
 *
 * @result An MOJavaScriptObject object
 */
@property (readonly) MOJavaScriptObject *prototype;

/*!
 * @property propertyNames
 * @abstract The list of enumerable properties defined for the object
 * 
 * @result An NSArray of NSString objects
 */
@property (copy, readonly) NSArray *propertyNames;

/*!
 * @method containsPropertyWithName:
 * @abstract Tests whether the object has a given property
 *
 * @param propertyName
 * The name of the property to test
 * 
 * @discussion
 * Testing for property existence through this method can be less
 * expensive than iterating the object's list of defined properties.
 *
 * @result An BOOL value
 */
- (BOOL)containsPropertyWithName:(NSString *)propertyName;

/*!
 * @method objectForPropertyName:
 * @abstract Gets the value for a given property
 * 
 * @param propertyName
 * The name of the property to fetch
 * 
 * @result An object, or nil
 */
- (id)objectForPropertyName:(NSString *)propertyName;

/*!
 * @method setObject:forPropertyName:
 * @abstract Sets the value for a given property
 * 
 * @param object
 * The value to set
 *
 * @param propertyName
 * The name of the property to set
 */
- (void)setObject:(id)object forPropertyName:(NSString *)propertyName;

/*!
 * @method removeObjectForPropertyName:
 * @abstract Removes the value for a given property
 *
 * @param propertyName
 * The name of the property to remove
 */
- (void)removeObjectForPropertyName:(NSString *)propertyName;

/*!
 * @method objectAtPropertyIndex:
 * @abstract Gets the value for the given property index
 * 
 * @param propertyIdx
 * The property index to get
 * 
 * @result An object, or nil
 */
- (id)objectAtPropertyIndex:(NSUInteger)propertyIdx;

/*!
 * @method setObject:atPropertyIndex:
 * @abstract Sets the value for the given property index
 *
 * @param object
 * The value to set
 *
 * @param propertyIdx
 * The property index to set
 */
- (void)setObject:(id)object atPropertyIndex:(NSUInteger)propertyIdx;


/*!
 * @method constructWithArguments:
 * @abstract Calls the object as a constructor
 * 
 * @param arguments
 * The objects to pass as arguments to the constructor
 * 
 * @result An object, or nil
 */
- (id)constructWithArguments:(NSArray *)arguments;

/*!
 * @method callWithArguments:
 * @abstract Calls the object as a function
 * 
 * @param arguments
 * The objects to pass as arguments to the function
 * 
 * @result An object, or nil
 */
- (id)callWithArguments:(NSArray *)arguments;

@end

