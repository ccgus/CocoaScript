//
//  MOObjectKey.h
//  Mocha
//
//  Created by Adam Fedor on 3/11/15.
//  Copyright (c) 2015 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @class MOObjectKey
 * @abstract An object that represents another object inside a MapTable
 *
 * Objects can be used as keys in map tables, but the problem is that a mutable object can change while it is the key of a table, and thereby change how
 * the value of the key is accessed based on how the Object's isEqual: method changes. The MOObjectKey represents just a pointer to the object, so isEqual: will
 * only return true if it is compared to the exact same object, e.g. ptr1 == ptr2, NOT [ptr1 isEqual: ptr2]
 */
@interface MOObjectKey : NSObject
/*!
 * @method initWithValue:
 * @abstract Creates a new key based on the object
 *
 * @param value
 * The object represented by the key
 *
 * @result An MOObjectKey object
 */
- (id)initWithObject:(id)object;


/*!
 * @property value
 * @abstract The object represented by the key
 *
 * @result An object, or nil
 */
@property (strong, readonly) id keyObject;
@end
