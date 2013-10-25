//
//  MOPropertyDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOObjCRuntime.h"


/*!
 * @class MOPropertyDescription
 * @abstract Description for an Objective-C class property
 */
@interface MOPropertyDescription : NSObject

/*!
 * @property name
 * @abstract The name of the property
 * 
 * @result An NSString object
 */
@property (copy) NSString *name;

/*!
 * @property typeEncoding
 * @abstract The type encoding of the property
 * 
 * @result An NSString object
 */
@property (copy) NSString *typeEncoding;


/*!
 * @property ivarName
 * @abstract The name of the backing instance variable
 * 
 * @result An NSString object
 */
@property (copy) NSString *ivarName;


/*!
 * @property getterSelector
 * @abstract The selector for the getter method
 * 
 * @result A SEL value
 */
@property SEL getterSelector;

/*!
 * @property setterSelector
 * @abstract The selector for the setter method
 * 
 * @result A SEL value
 */
@property SEL setterSelector;


/*!
 * @property ownershipRule
 * @abstract The ownership rule for the property
 * 
 * @result An MOObjCOwnershipRule value
 */
@property MOObjCOwnershipRule ownershipRule;


/*!
 * @property dynamic
 * @abstract Whether getter and setter methods are created at runtime
 * 
 * @result A BOOL value
 */
@property (getter=isDynamic) BOOL dynamic;

/*!
 * @property nonAtomic
 * @abstract Whether the property should work non-atomically (without synchronization code)
 * 
 * @result A BOOL value
 */
@property (getter=isNonAtomic) BOOL nonAtomic;

/*!
 * @property readOnly
 * @abstract Whether the property is read-only
 * 
 * @result A BOOL value
 */
@property (getter=isReadOnly) BOOL readOnly;

/*!
 * @property weak
 * @abstract Whether the property's value is weakly assigned
 * 
 * @result A BOOL value
 */
@property (getter=isWeak) BOOL weak;

@end
