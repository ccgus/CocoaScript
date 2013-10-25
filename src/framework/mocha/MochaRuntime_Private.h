//
//  MochaRuntime_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MochaRuntime.h"



@interface Mocha ()

+ (Mocha *)runtimeWithContext:(JSContextRef)ctx;

- (id)initWithGlobalContext:(JSGlobalContextRef)ctx;

@property (readonly) JSGlobalContextRef context;

// JSValue <-> id
+ (JSValueRef)JSValueForObject:(id)object inContext:(JSContextRef)ctx;

+ (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx;
+ (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx unboxObjects:(BOOL)unboxObjects;

+ (NSArray *)arrayForJSArray:(JSObjectRef)arrayValue inContext:(JSContextRef)ctx;
+ (NSDictionary *)dictionaryForJSHash:(JSObjectRef)hashValue inContext:(JSContextRef)ctx;

- (JSValueRef)JSValueForObject:(id)object;

- (id)objectForJSValue:(JSValueRef)value;
- (id)objectForJSValue:(JSValueRef)value unboxObjects:(BOOL)unboxObjects;

// JSObject <-> id
- (JSObjectRef)boxedJSObjectForObject:(id)object;
- (id)unboxedObjectForJSObject:(JSObjectRef)jsObject;

// Object storage
- (id)objectWithName:(NSString *)name;
- (JSValueRef)setObject:(id)object withName:(NSString *)name;
- (JSValueRef)setObject:(id)object withName:(NSString *)name attributes:(JSPropertyAttributes)attributes;
- (BOOL)removeObjectWithName:(NSString *)name;

// Evaluation
- (JSValueRef)evalJSString:(NSString *)string;
- (JSValueRef)evalJSString:(NSString *)string scriptPath:(NSString *)scriptPath;

// Functions
- (JSObjectRef)JSFunctionWithName:(NSString *)functionName;
- (JSValueRef)callJSFunctionWithName:(NSString *)functionName withArgumentsInArray:(NSArray *)arguments;
- (JSValueRef)callJSFunction:(JSObjectRef)jsFunction withArgumentsInArray:(NSArray *)arguments;

// Exceptions
+ (NSException *)exceptionWithJSException:(JSValueRef)exception context:(JSContextRef)ctx;
- (NSException *)exceptionWithJSException:(JSValueRef)exception;
- (void)throwJSException:(JSValueRef)exception;

// Support
- (void)installBuiltins;
- (void)cleanUp;
//- (void)unlinkAllReferences;

@end
