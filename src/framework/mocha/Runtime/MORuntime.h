//
//  MORuntime.h
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MochaDefines.h"


/*!
 * @enum MORuntimeOptions
 * @abstract Options to configure runtime behaviors
 * 
 * @constant MORuntimeOptionsNone   No options
 *
 * @constant MORuntimeOptionAutomaticReferenceCounting
 * @abstract Enable automatic management of Objective-C object retain semantics
 * @discussion
 * When ARC-mode is enable for a runtime, objects created through the bridge do not need
 * to be explicitly sent -release messages. This behavior requires that all methods conform
 * to the Objective-C naming conventions and/or have proper retain semantics declared in
 * loaded BridgeSupport metadata libraries. If this is not the case, objects may be leaked
 * and/or it might lead to unstable behavior.
 */
typedef NS_OPTIONS(NSUInteger, MORuntimeOptions) {
    MORuntimeOptionsNone = 0,
    MORuntimeOptionAutomaticReferenceCounting = (1 << 0),
};


/*!
 * @class MORuntime
 * @abstract The Mocha runtime interface
 */
@interface MORuntime : NSObject

/*!
 * @method initWithOptions:
 * @abstract Creates a new runtime
 * 
 * @param options
 * The runtime configuration options
 * 
 * @result An MORuntime object
 */
- (id)initWithOptions:(MORuntimeOptions)options;


/*!
 * @property options
 * @abstract The runtime's configuration options
 * 
 * @result An MORuntimeOptions value
 */
@property (readonly) MORuntimeOptions options;


/*!
 * @method isSyntaxValidForString:
 * @abstract Validates the syntax of a JavaScript expression
 * 
 * @param string
 * The JavaScript expression to validate
 * 
 * @result A BOOL value
 */
- (BOOL)isSyntaxValidForString:(NSString *)string;

/*!
 * @method evaluateString:
 * @abstract Evalutates the specified JavaScript expression, returning the result
 * 
 * @param string
 * The JavaScript expression to evaluate
 * 
 * @result An object, or nil
 */
- (id)evaluateString:(NSString *)string;


/*!
 * @group Objects
 */

/*!
 * @property globalObjectNames
 * @abstract Gets an array of all objects names in the global scope
 * 
 * @result An NSArray of NSString objects
 */
@property (copy, readonly) NSArray *globalObjectNames;

/*!
 * @method globalObjectWithName:
 * @abstract Gets an object in the global scope with a specified name
 * 
 * @param objectName
 * The name of the global object to get
 * 
 * @result An object, or MOUndefined if an object with the specified name does not exist
 */
- (id)globalObjectWithName:(NSString *)objectName;

/*!
 * @method setGlobalObject:withName:
 * @abstract Sets an object in the global scope with a specified name
 *
 * @param object
 * The object value to set
 *
 * @param objectName
 * The name of the global object to set
 */
- (void)setGlobalObject:(id)object withName:(NSString *)name;

/*!
 * @method removeGlobalObjectWithName:
 * @abstract Removes an object in the global scope with a specified name
 *
 * @param objectName
 * The name of the global object to remove
 */
- (void)removeGlobalObjectWithName:(NSString *)name;


/*!
 * @group Bridge Support
 */

/*!
 * @method loadBridgeSupportFilesAtPath:
 * @abstract Loads BridgeSupport info and symbols at a specified location
 *
 * @param path
 * The path to load
 *
 * @result A BOOL value
 */
- (BOOL)loadBridgeSupportFilesAtPath:(NSString *)path;

#if !TARGET_OS_IPHONE

/*!
 * @method loadFrameworkWithName:
 * @abstract Loads BridgeSupport info and symbols for a specified framework
 * 
 * @param frameworkName
 * The name of the framework to load
 * 
 * @discussion
 * This method will attempt to load BridgeSupport info and symbols for the
 * framework via dyld. If the framework cannot be found, or fails to load,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)loadFrameworkWithName:(NSString *)frameworkName;

/*!
 * @method loadFrameworkWithName:inDirectory:
 * @abstract Loads BridgeSupport info and symbols for a specified framework
 * 
 * @param frameworkName
 * The name of the framework to load
 * 
 * @param directory
 * The directory in which to look for the framework
 * 
 * @discussion
 * This method will attempt to load BridgeSupport info and symbols for the
 * framework via dyld. If the framework cannot be found, or fails to load,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)loadFrameworkWithName:(NSString *)frameworkName inDirectory:(NSString *)directory;

/*!
 * @property frameworkSearchPaths
 * @abstract Gets the array of search paths to check when loading a framework
 * 
 * @result An NSArray of NSString objects
 */
@property (copy) NSArray *frameworkSearchPaths;

#endif

@end


/*!
 * @category NSObject(MOObjectConstructing)
 * @abstract Methods for enabling calling an object as a constructor within the runtime
 *
 * @discussion
 * This category defines but does not implement these methods.
 */
@interface NSObject (MOObjectConstructing)

- (id)constructWithArguments:(NSArray *)arguments;

@end


/*!
 * @category NSObject(MOObjectCalling)
 * @abstract Methods for enabling calling an object as a function within the runtime
 *
 * @discussion
 * This category defines but does not implement these methods.
 */
@interface NSObject (MOObjectCalling)

- (id)callWithArguments:(NSArray *)arguments;

@end


/*!
 * @category NSObject(MOObjectIndexedSubscripting)
 * @abstract Methods for enabling indexed subscripting within the runtime
 * 
 * @discussion
 * This category defines but does not implement these methods.
 */
@interface NSObject (MOObjectIndexedSubscripting)

/*!
 * @method objectForIndexedSubscript:
 * @abstract Gets the object for a given index
 * 
 * @param idx
 * The index for which to get an object
 * 
 * @result An object
 */
- (id)objectForIndexedSubscript:(NSUInteger)idx;

/*!
 * @method setObject:forIndexedSubscript:
 * @abstract Sets the object for a given index
 * 
 * @param obj
 * The object value to set
 * 
 * @param idx
 * The index for which to get an object
 */
- (void)setObject:(id)obj forIndexedSubscript:(NSUInteger)idx;

@end


/*!
 * @category NSObject(MOObjectKeyedSubscripting)
 * @abstract Methods for enabling keyed subscripting within the runtime
 *
 * @discussion
 * This category defines but does not implement these methods.
 */
@interface NSObject (MOObjectKeyedSubscripting)

/*!
 * @method objectForKeyedSubscript:
 * @abstract Gets the object for a given key
 * 
 * @param key
 * The key for which to get an object
 * 
 * @result An object
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/*!
 * @method setObject:forKeyedSubscript:
 * @abstract Sets the object for a given key
 * 
 * @param obj
 * The object value to set
 * 
 * @param key
 * The key for which to get an object
 */
- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key;

@end


/*!
 * @constant MORuntimeException
 * @abstract The name of exceptions raised within the runtime's internal implementation
 */
MOCHA_EXTERN NSString * const MORuntimeException;

/*!
 * @constant MOJavaScriptException
 * @abstract The name of exceptions raised within JavaScript code
 */
MOCHA_EXTERN NSString * const MOJavaScriptException;

