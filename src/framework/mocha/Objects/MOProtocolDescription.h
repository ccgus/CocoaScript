//
//  MOProtocolDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/18/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOMethodDescription, MOPropertyDescription;


/*!
 * @class MOProtocolDescription
 * @abstract A description of an Objective-C protocol
 */
@interface MOProtocolDescription : NSObject

/*!
 * @method descriptionForProtocol:
 * @abstract Gets the protocol description for a specified protocol
 * 
 * @param protocol
 * The protocol object
 * 
 * @result An MOProtocolDescription object
 */
+ (MOProtocolDescription *)descriptionForProtocol:(Protocol *)protocol;

/*!
 * @method descriptionForProtocolWithName:
 * @abstract Gets the protocol description for a specified protocol name
 * 
 * @param name
 * The name of the protocol
 * 
 * @result An MOProtocolDescription object
 */
+ (MOProtocolDescription *)descriptionForProtocolWithName:(NSString *)name;

/*!
 * @method allocateDescriptionForProtocolWithName:
 * @abstract Creates a protocol description for a new protocol
 * 
 * @param name
 * The name of the protocol
 * 
 * @discussion
 * If there is already a protocol registered with that name, this method returns nil.
 * 
 * Despite it's name's connotations, this method returns an autoreleased object.
 * It is the protocol object itself which is being allocated.
 * 
 * @result An MOProtocolDescription object, or nil
 */
+ (MOProtocolDescription *)allocateDescriptionForProtocolWithName:(NSString *)name;


/*!
 * @property name
 * @abstract The name of the class
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *name;


/*!
 * @property requiredClassMethods
 * @abstract The array of required class methods
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *requiredClassMethods;

/*!
 * @property optionalClassMethods
 * @abstract The array of optional class methods
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *optionalClassMethods;

/*!
 * @method addClassMethod:isRequired:
 * @abstract Adds a new class method to the protocol
 * 
 * @param method
 * The method to add
 * 
 * @param isRequired
 * Whether the method is required
 */
- (void)addClassMethod:(MOMethodDescription *)method required:(BOOL)isRequired;


/*!
 * @property requiredInstanceMethods
 * @abstract The array of required instance methods
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *requiredInstanceMethods;

/*!
 * @property optionalInstanceMethods
 * @abstract The array of optional instance methods
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *optionalInstanceMethods;

/*!
 * @method addInstanceMethod:required:
 * @abstract Adds a new instance method to the protocol
 * 
 * @param method
 * The method to add
 * 
 * @param isRequired
 * Whether the method is required
 */
- (void)addInstanceMethod:(MOMethodDescription *)method required:(BOOL)isRequired;


/*!
 * @property properties
 * @abstract The array of properties
 * 
 * @result An NSArray of MOPropertyDescription objects
 */
@property (copy, readonly) NSArray *properties;

/*!
 * @method addProperty:
 * @abstract Adds a new property to the protocol
 * 
 * @param property
 * The property to add
 * 
 * @param isRequired
 * Whether the property is required
 */
- (void)addProperty:(MOPropertyDescription *)property required:(BOOL)isRequired;


/*!
 * @property protocols
 * @abstract The array of adopted protocols
 * 
 * @result An NSArray of MOProtocolDescription objects
 */
@property (copy, readonly) NSArray *protocols;

/*!
 * @method addProtocol:
 * @abstract Adds a new conformed protocol to the protocol
 * 
 * @param protocol
 * The description of the protocol to add
 */
- (void)addProtocol:(MOProtocolDescription *)protocol;

@end
