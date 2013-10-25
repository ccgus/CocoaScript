//
//  MOUtilities.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

#if TARGET_OS_IPHONE
#import "ffi.h"
#else
#import <ffi/ffi.h>
#endif


@class MOBridgeSupportFunction, MOFunctionArgument, MOJavaScriptObject;


JSValueRef MOJSValueToType(JSContextRef ctx, JSObjectRef objectJS, JSType type, JSValueRef *exception);
NSString * MOJSValueToString(JSContextRef ctx, JSValueRef value, JSValueRef *exception);

JSValueRef MOSelectorInvoke(id target, SEL selector, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception);
JSValueRef MOFunctionInvoke(id function, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception);

BOOL MOSelectorIsVariadic(Class klass, SEL selector);
void * MOInvocationGetObjCCallAddressForArguments(NSArray *arguments);

MOFunctionArgument * MOFunctionArgumentForTypeEncoding(NSString *typeEncoding);
NSArray * MOParseObjCMethodEncoding(const char *typeEncoding);

SEL MOSelectorFromPropertyName(NSString *propertyName);
NSString * MOSelectorToPropertyName(SEL selector);

NSString * MOPropertyNameToSetterName(NSString *propertyName);

id MOGetBlockForJavaScriptFunction(MOJavaScriptObject *function, NSUInteger *argCount);
