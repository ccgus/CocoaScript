//
//  MOJavaScriptObject.m
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOJavaScriptObject.h"
#import "MOJavaScriptObject_Private.h"

#import "MORuntime_Private.h"


@implementation MOJavaScriptObject {
    JSObjectRef _JSObject;
    JSContextRef _JSContext;
}

+ (instancetype)objectWithJSObject:(JSObjectRef)jsObject context:(JSContextRef)ctx {
    MOJavaScriptObject *object = [[self alloc] init];
    [object setJSObject:jsObject JSContext:ctx];
    return object;
}

- (void)dealloc {
    if (_JSObject != NULL) {
        JSValueUnprotect(_JSContext, _JSObject);
    }
}

- (NSString *)description {
    JSStringRef string = JSValueToStringCopy(_JSContext, _JSObject, NULL);
    NSString *description = (NSString *)CFBridgingRelease(JSStringCopyCFString(NULL, string));
    JSStringRelease(string);
    return description;
}

- (JSObjectRef)JSObject {
    return _JSObject;
}

- (void)setJSObject:(JSObjectRef)JSObject JSContext:(JSContextRef)JSContext {
    if (_JSObject != NULL) {
        JSValueUnprotect(_JSContext, _JSObject);
    }
    _JSObject = JSObject;
    _JSContext = JSContext;
    if (_JSObject != NULL) {
        JSValueProtect(_JSContext, _JSObject);
    }
}

- (MOJavaScriptObject *)prototype {
    MORuntime *runtime = [MORuntime runtimeWithContext:_JSContext];
    JSValueRef value = JSObjectGetPrototype(_JSContext, _JSObject);
    id object = [runtime objectForJSValue:value inContext:_JSContext];
    return object;
}

- (NSArray *)propertyNames {
    JSPropertyNameArrayRef propertyNamesRef = JSObjectCopyPropertyNames(_JSContext, _JSObject);
    size_t count = JSPropertyNameArrayGetCount(propertyNamesRef);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (size_t i=0; i<count; i++) {
        JSStringRef nameRef = JSPropertyNameArrayGetNameAtIndex(propertyNamesRef, i);
        NSString *name = CFBridgingRelease(JSStringCopyCFString(NULL, nameRef));
        [array addObject:name];
    }
    
    JSPropertyNameArrayRelease(propertyNamesRef);
    
    return array;
}

- (BOOL)containsPropertyWithName:(NSString *)propertyName {
    JSStringRef nameRef = JSStringCreateWithCFString((__bridge CFStringRef)propertyName);
    bool value = JSObjectHasProperty(_JSContext, _JSObject, nameRef);
    JSStringRelease(nameRef);
    return (BOOL)value;
}

- (id)objectForPropertyName:(NSString *)propertyName {
    MORuntime *runtime = [MORuntime runtimeWithContext:_JSContext];
    
    JSStringRef nameRef = JSStringCreateWithCFString((__bridge CFStringRef)propertyName);
    JSValueRef exceptionRef = NULL;
    JSValueRef value = JSObjectGetProperty(_JSContext, _JSObject, nameRef, &exceptionRef);
    JSStringRelease(nameRef);
    
    if (exceptionRef == NULL) {
        id object = [runtime objectForJSValue:value inContext:_JSContext];
        return object;
    }
    else {
        [runtime throwJSException:exceptionRef inContext:_JSContext];
    }
    
    return nil;
}

- (void)setObject:(id)object forPropertyName:(NSString *)propertyName {
    MORuntime *runtime = [MORuntime runtimeWithContext:_JSContext];
    
    JSStringRef nameRef = JSStringCreateWithCFString((__bridge CFStringRef)propertyName);
    JSValueRef exceptionRef = NULL;
    JSValueRef valueRef = [runtime JSValueForObject:object inContext:_JSContext];
    JSObjectSetProperty(_JSContext, _JSObject, nameRef, valueRef, kJSPropertyAttributeNone, &exceptionRef);
    JSStringRelease(nameRef);
    
    if (exceptionRef != NULL) {
        [runtime throwJSException:exceptionRef inContext:_JSContext];
    }
}

- (void)removeObjectForPropertyName:(NSString *)propertyName {
    MORuntime *runtime = [MORuntime runtimeWithContext:_JSContext];
    
    JSStringRef nameRef = JSStringCreateWithCFString((__bridge CFStringRef)propertyName);
    JSValueRef exceptionRef = NULL;
    JSObjectDeleteProperty(_JSContext, _JSObject, nameRef, &exceptionRef);
    JSStringRelease(nameRef);
    
    if (exceptionRef != NULL) {
        [runtime throwJSException:exceptionRef inContext:_JSContext];
    }
}

- (id)objectAtPropertyIndex:(NSUInteger)propertyIdx {
    MORuntime *runtime = [MORuntime runtimeWithContext:_JSContext];
    
    JSValueRef exceptionRef = NULL;
    JSValueRef valueRef = JSObjectGetPropertyAtIndex(_JSContext, _JSObject, (unsigned int)propertyIdx, &exceptionRef);
    
    if (exceptionRef == NULL) {
        id object = [runtime objectForJSValue:valueRef inContext:_JSContext];
        return object;
    }
    else {
        [runtime throwJSException:exceptionRef inContext:_JSContext];
        return nil;
    }
}

- (void)setObject:(id)object atPropertyIndex:(NSUInteger)propertyIdx {
    MORuntime *runtime = [MORuntime runtimeWithContext:_JSContext];
    
    JSValueRef exceptionRef = NULL;
    JSValueRef valueRef = [runtime JSValueForObject:object inContext:_JSContext];
    JSObjectSetPropertyAtIndex(_JSContext, _JSObject, (unsigned int)propertyIdx, valueRef, &exceptionRef);
    
    if (exceptionRef != NULL) {
        [runtime throwJSException:exceptionRef inContext:_JSContext];
    }
}

- (id)constructWithArguments:(NSArray *)arguments {
    MORuntime *runtime = [MORuntime runtimeWithContext:_JSContext];
    size_t argumentCount = (size_t)[arguments count];
    
    JSValueRef * argumentRefs = NULL;
    if (argumentCount > 0) {
        argumentRefs = malloc(sizeof(JSValueRef));
    }
    
    for (size_t i=0; i<argumentCount; i++) {
        id object = arguments[i];
        JSValueRef value = [runtime JSValueForObject:object inContext:_JSContext];
        argumentRefs[i] = value;
    }
    
    JSValueRef exceptionRef = NULL;
    JSValueRef returnValue = JSObjectCallAsConstructor(_JSContext, _JSObject, argumentCount, (const JSValueRef *)argumentRefs, &exceptionRef);
    
    if (argumentRefs != NULL) {
        free(argumentRefs);
    }
    
    if (exceptionRef != NULL) {
        [runtime throwJSException:exceptionRef inContext:_JSContext];
    }
    
    return [runtime objectForJSValue:returnValue inContext:_JSContext];
}

- (id)callWithArguments:(NSArray *)arguments {
    MORuntime *runtime = [MORuntime runtimeWithContext:_JSContext];
    size_t argumentCount = (size_t)[arguments count];
    
    JSValueRef * argumentRefs = NULL;
    if (argumentCount > 0) {
        argumentRefs = malloc(sizeof(JSValueRef));
    }
    
    for (size_t i=0; i<argumentCount; i++) {
        id object = arguments[i];
        JSValueRef value = [runtime JSValueForObject:object inContext:_JSContext];
        argumentRefs[i] = value;
    }
    
    JSValueRef exceptionRef = NULL;
    JSValueRef returnValue = JSObjectCallAsFunction(_JSContext, _JSObject, NULL, argumentCount, (const JSValueRef *)argumentRefs, &exceptionRef);
    
    if (argumentRefs != NULL) {
        free(argumentRefs);
    }
    
    if (exceptionRef != NULL) {
        [runtime throwJSException:exceptionRef inContext:_JSContext];
    }
    
    return [runtime objectForJSValue:returnValue inContext:_JSContext];
}

@end
