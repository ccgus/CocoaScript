//
//  MORuntime_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MORuntime.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface MORuntime ()

+ (MORuntime *)runtimeWithContext:(JSContextRef)ctx;

@property (readonly) JSGlobalContextRef context;
@property (readwrite) MORuntimeOptions options;

// JSValue <-> id
+ (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx;
+ (NSArray *)arrayForJSArray:(JSObjectRef)arrayValue inContext:(JSContextRef)ctx;

- (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx;
- (JSValueRef)JSValueForObject:(id)object inContext:(JSContextRef)ctx;

// Object storage
- (void)setGlobalObject:(id)object withName:(NSString *)name attributes:(JSPropertyAttributes)attributes;

// Evaluation
- (JSValueRef)evaluateJSString:(NSString *)string scriptPath:(NSString *)scriptPath;

// Exceptions
+ (NSException *)exceptionWithJSException:(JSValueRef)exception context:(JSContextRef)ctx;
- (void)throwJSException:(JSValueRef)exceptionJS inContext:(JSContextRef)ctx;

// Support
- (void)installBuiltins;

@end
