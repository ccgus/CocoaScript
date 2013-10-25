//
//  MOClassDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOInstanceVariableDescription, MOMethodDescription, MOPropertyDescription, MOProtocolDescription;
@class MOJavaScriptObject;


/*!
 * @class MOClassDescription
 * @abstract A description of an Objective-C class
 */
@interface MOClassDescription : NSObject

/*!
 * @method descriptionForClassWithName:
 * @abstract Gets the class description for a specified class name
 * 
 * @param name
 * The name of the class
 * 
 * @discussion
 * If there is no class registered with that name, this method returns nil.
 * 
 * @result An MOClassDescription object, or nil
 */
+ (MOClassDescription *)descriptionForClassWithName:(NSString *)name;

/*!
 * @method descriptionForClass:
 * @abstract Gets the class description for a specified class
 * 
 * @param aClass
 * The class object
 * 
 * @discussion
 * If there is no class registered with that name, this method returns nil.
 * 
 * @result An MOClassDescription object, or nil
 */
+ (MOClassDescription *)descriptionForClass:(Class)aClass;

/*!
 * @method allocateDescriptionForClassWithName:
 * @abstract Creates a class description for a new class
 * 
 * @param name
 * The name of the class
 * 
 * @param superclass
 * The superclass of the new class. Pass Nil to create a new root class.
 * 
 * @discussion
 * If there is already a class registered with that name, this method returns nil.
 * 
 * Once this method has been called, and returned a non-nil value, the class
 * must be registered with -registerClass to be used. Failing to do so will prevent
 * another class to be created with the same name.
 * 
 * Despite it's name's connotations, this method returns an autoreleased object.
 * It is the class object itself which is being allocated.
 * 
 * @result An MOClassDescription object, or nil
 */
+ (MOClassDescription *)allocateDescriptionForClassWithName:(NSString *)name superclass:(Class)superclass;


/*!
 * @method registerClass
 * @abstract Registers the class with the runtime
 * 
 * @discussion
 * Before the class can be instantiated, you must call -registerClass.
 * 
 * If the class cannot be registered (for example, if the desired name is in use)
 * this method returns Nil. The result of attempting to register a class that
 * is already registered is undefined.
 * 
 * @result A Class object, or Nil
 */
- (Class)registerClass;


/*!
 * @property name
 * @abstract The name of the class
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *name;

/*!
 * @property descriptedClass
 * @abstract The class backing the description
 * 
 * @result A Class object, or Nil
 */
@property (unsafe_unretained, readonly) Class descriptedClass;

/*!
 * @property superclass
 * @abstract The description of the superclass of the class backing the description
 * 
 * @result An MOClassDescription object, or nil
 */
@property (weak, readonly) MOClassDescription *superclass;

/*!
 * @property ancestors
 * @abstract The description of each superclass in the class's superclass chain
 * 
 * @result An NSArray of MOClassDescription objects
 */
@property (copy, readonly) NSArray *ancestors;


/*!
 * @property instanceVariables
 * @abstract The array of instance variable descriptions
 * 
 * @result An NSArray of MOInstanceVariableDescription objects
 */
@property (copy, readonly) NSArray *instanceVariables;

/*!
 * @property instanceVariablesWithAncestors
 * @abstract The array of instance variable descriptions, including those of ancestors
 * 
 * @result An NSArray of MOInstanceVariableDescription objects
 */
@property (copy, readonly) NSArray *instanceVariablesWithAncestors;

/*!
 * @method addInstanceVariableWithName:typeEncoding:
 * @abstract Adds a new instance variable to the class
 * 
 * @param name
 * The name of the instance variable
 * 
 * @param typeEncoding
 * The type encoding of the instance variable
 * 
 * @discussion
 * If the class already contains an instance variable with that
 * name, this method returns NO.
 * 
 * Adding instance variables to an existing class is not supported.
 * If the class has already been registered with the runtime, calling
 * this method will raise an MORuntimeException.
 * 
 * @result A BOOL value
 */
- (BOOL)addInstanceVariableWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding;


/*!
 * @property classMethods
 * @abstract The array of class method descriptions
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *classMethods;

/*!
 * @property classMethodsWithAncestors
 * @abstract The array of class method descriptions, including those of ancestors
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *classMethodsWithAncestors;

/*!
 * @method addClassMethodWithSelector:typeEncoding:block:
 * @abstract Adds a new class method to the class
 * 
 * @param selector
 * The method selector
 * 
 * @param typeEncoding
 * The type encoding of the method
 * 
 * @param block
 * The block defining the method's implementation
 * 
 * @discussion
 * If the class already contains a class method with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addClassMethodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding block:(id)block;

/*!
 * @method addClassMethodWithSelector:JSFunction:
 * @abstract Adds a new class method to the class
 * 
 * @param selector
 * The method selector
 * 
 * @param function
 * The function object
 * 
 * @discussion
 * If the class already contains a class method with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addClassMethodWithSelector:(SEL)selector function:(MOJavaScriptObject *)function;


/*!
 * @property instanceMethods
 * @abstract The array of instance method descriptions
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *instanceMethods;

/*!
 * @property instanceMethodsWithAncestors
 * @abstract The array of instance method descriptions, including those of ancestors
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *instanceMethodsWithAncestors;

/*!
 * @method addInstanceMethodWithSelector:typeEncoding:block:
 * @abstract Adds a new instance method to the class
 * 
 * @param selector
 * The method selector
 * 
 * @param typeEncoding
 * The type encoding of the method
 * 
 * @param block
 * The block defining the method's implementation
 * 
 * @discussion
 * If the class already contains an instance method with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addInstanceMethodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding block:(id)block;

/*!
 * @method addInstanceMethodWithSelector:JSFunction:
 * @abstract Adds a new instance method to the class
 * 
 * @param selector
 * The method selector
 * 
 * @param function
 * The function object
 * 
 * @discussion
 * If the class already contains an instance method with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addInstanceMethodWithSelector:(SEL)selector function:(MOJavaScriptObject *)function;


/*!
 * @property properties
 * @abstract The array of property descriptions
 * 
 * @result An NSArray of MOPropertyDescription objects
 */
@property (copy, readonly) NSArray *properties;

/*!
 * @property propertiesWithAncestors
 * @abstract The array of property descriptions, including those of ancestors
 * 
 * @result An NSArray of MOPropertyDescription objects
 */
@property (copy, readonly) NSArray *propertiesWithAncestors;

/*!
 * @method addProperty:
 * @abstract Adds a new property to the class
 * 
 * @param property
 * The property to add
 * 
 * @param block
 * The block defining the method's implementation
 * 
 * @discussion
 * If the class already contains a property with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addProperty:(MOPropertyDescription *)property;


/*!
 * @property protocols
 * @abstract The array of adopted protocols
 * 
 * @result An NSArray of MOProtocolDescription objects
 */
@property (copy, readonly) NSArray *protocols;

/*!
 * @property protocols
 * @abstract The array of adopted protocols, including those of ancestors
 * 
 * @result An NSArray of MOProtocolDescription objects
 */
@property (copy, readonly) NSArray *protocolsWithAncestors;

/*!
 * @method addProtocol:
 * @abstract Adds a new conformed protocol to the class
 * 
 * @param protocol
 * The description of the protocol to add
 */
- (void)addProtocol:(MOProtocolDescription *)protocol;

@end
