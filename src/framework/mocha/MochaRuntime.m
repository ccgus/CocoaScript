//
//  MochaRuntime.m
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MochaRuntime.h"
#import "MochaRuntime_Private.h"

#import "MOBox.h"
#import "MOUndefined.h"
#import "MOMethod_Private.h"
#import "MOClosure_Private.h"
#import "MOJavaScriptObject.h"
#import "MOPointer.h"
#import "MOUtilities.h"
#import "MOFunctionArgument.h"
#import "MOAllocator.h"

#import "MOObjCRuntime.h"

#import "MOBridgeSupportController.h"
#import "MOBridgeSupportSymbol.h"

#import "NSObject+MochaAdditions.h"
#import "NSArray+MochaAdditions.h"
#import "NSDictionary+MochaAdditions.h"
#import "NSOrderedSet+MochaAdditions.h"

#import <objc/runtime.h>
#import <dlfcn.h>


// Class types
static JSClassRef MochaClass = NULL;
static JSClassRef MOObjectClass = NULL;
static JSClassRef MOBoxedObjectClass = NULL;
static JSClassRef MOConstructorClass = NULL;
static JSClassRef MOFunctionClass = NULL;


// Global object
static JSValueRef   Mocha_getProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef *exception);
//static void         Mocha_initialize(JSContextRef ctx, JSObjectRef object);
//static void         Mocha_finalize(JSObjectRef object);

// Private Cocoa object callbacks
static void         MOObject_initialize(JSContextRef ctx, JSObjectRef object);
static void         MOObject_finalize(JSObjectRef object);

static bool         MOBoxedObject_hasProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName);
static JSValueRef   MOBoxedObject_getProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef *exception);
static bool         MOBoxedObject_setProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef *exception);
static bool         MOBoxedObject_deleteProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef *exception);
static void         MOBoxedObject_getPropertyNames(JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames);
static JSValueRef   MOBoxedObject_convertToType(JSContextRef ctx, JSObjectRef object, JSType type, JSValueRef *exception);
static bool         MOBoxedObject_hasInstance(JSContextRef ctx, JSObjectRef constructor, JSValueRef possibleInstance, JSValueRef *exception);

static JSObjectRef  MOConstructor_callAsConstructor(JSContextRef ctx, JSObjectRef object, size_t argumentsCount, const JSValueRef arguments[], JSValueRef *exception);

static JSValueRef   MOFunction_callAsFunction(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception);

static JSValueRef MOJSPrototypeForOBJCInstance(JSContextRef ctx, id instance, NSString *name);

NSString * const MORuntimeException = @"MORuntimeException";
NSString * const MOJavaScriptException = @"MOJavaScriptException";

NSString * const MOAlreadyProtectedKey = @"moAlreadyProtectedKey";

#pragma mark -
#pragma mark Runtime

@implementation Mocha {
    JSGlobalContextRef _ctx;
    BOOL _ownsContext;
    NSMutableDictionary *_exportedObjects;
    NSMutableDictionary *_objectsToBoxes;
    NSMutableArray *_frameworkSearchPaths;
}

@synthesize delegate=_delegate;

+ (void)initialize {
    if (self == [Mocha class]) {
        // Mocha global object
        JSClassDefinition MochaClassDefinition      = kJSClassDefinitionEmpty;
        MochaClassDefinition.className              = "Mocha";
        MochaClassDefinition.getProperty            = Mocha_getProperty;
        //MochaClassDefinition.initialize             = Mocha_initialize;
        //MochaClassDefinition.finalize               = Mocha_finalize;
        MochaClass                                  = JSClassCreate(&MochaClassDefinition);
        
        // Mocha object
        JSClassDefinition MOObjectDefinition        = kJSClassDefinitionEmpty;
        MOObjectDefinition.className                = "MOObject";
        MOObjectDefinition.initialize               = MOObject_initialize;
        MOObjectDefinition.finalize                 = MOObject_finalize;
        MOObjectClass                               = JSClassCreate(&MOObjectDefinition);
        
        // Boxed Cocoa object
        JSClassDefinition MOBoxedObjectDefinition  = kJSClassDefinitionEmpty;
        MOBoxedObjectDefinition.className          = "MOBoxedObject";
        MOBoxedObjectDefinition.parentClass        = MOObjectClass;
        MOBoxedObjectDefinition.hasProperty        = MOBoxedObject_hasProperty;
        MOBoxedObjectDefinition.getProperty        = MOBoxedObject_getProperty;
        MOBoxedObjectDefinition.setProperty        = MOBoxedObject_setProperty;
        MOBoxedObjectDefinition.deleteProperty     = MOBoxedObject_deleteProperty;
        MOBoxedObjectDefinition.getPropertyNames   = MOBoxedObject_getPropertyNames;
        MOBoxedObjectDefinition.hasInstance        = MOBoxedObject_hasInstance;
        MOBoxedObjectDefinition.convertToType      = MOBoxedObject_convertToType;
        MOBoxedObjectClass                         = JSClassCreate(&MOBoxedObjectDefinition);
        
        // Constructor object
        JSClassDefinition MOConstructorDefinition  = kJSClassDefinitionEmpty;
        MOConstructorDefinition.className          = "MOConstructor";
        MOConstructorDefinition.parentClass        = MOObjectClass;
        MOConstructorDefinition.callAsConstructor  = MOConstructor_callAsConstructor;
        MOConstructorDefinition.convertToType      = MOBoxedObject_convertToType;
        MOConstructorClass                         = JSClassCreate(&MOConstructorDefinition);
        
        // Function object
        JSClassDefinition MOFunctionDefinition     = kJSClassDefinitionEmpty;
        MOFunctionDefinition.className             = "MOFunction";
        MOFunctionDefinition.parentClass           = MOObjectClass;
        MOFunctionDefinition.callAsFunction        = MOFunction_callAsFunction;
        MOFunctionDefinition.convertToType         = MOBoxedObject_convertToType;
        MOFunctionClass                            = JSClassCreate(&MOFunctionDefinition);
        
        
        // Swizzle indexed subscripting support for NSArray
        SEL indexedSubscriptSelector = @selector(objectForIndexedSubscript:);
        if (![NSArray instancesRespondToSelector:indexedSubscriptSelector]) {
            IMP imp = class_getMethodImplementation([NSArray class], @selector(mo_objectForIndexedSubscript:));
            class_addMethod([NSArray class], @selector(objectForIndexedSubscript:), imp, "@@:l");
            
            imp = class_getMethodImplementation([NSMutableArray class], @selector(mo_setObject:forIndexedSubscript:));
            class_addMethod([NSMutableArray class], @selector(setObject:forIndexedSubscript:), imp, "@@:@l");
        }
        
        // Swizzle indexed subscripting support for NSOrderedSet
        if (![NSOrderedSet instancesRespondToSelector:indexedSubscriptSelector]) {
            IMP imp = class_getMethodImplementation([NSOrderedSet class], @selector(mo_objectForIndexedSubscript:));
            class_addMethod([NSOrderedSet class], @selector(objectForIndexedSubscript:), imp, "@@:l");
            
            imp = class_getMethodImplementation([NSMutableOrderedSet class], @selector(mo_setObject:forIndexedSubscript:));
            class_addMethod([NSMutableOrderedSet class], @selector(setObject:forIndexedSubscript:), imp, "@@:@l");
        }
        
        // Swizzle keyed subscripting support for NSDictionary
        SEL keyedSubscriptSelector = @selector(objectForKeyedSubscript:);
        if (![NSDictionary instancesRespondToSelector:keyedSubscriptSelector]) {
            IMP imp = class_getMethodImplementation([NSDictionary class], @selector(mo_objectForKeyedSubscript:));
            class_addMethod([NSDictionary class], @selector(objectForKeyedSubscript:), imp, "@@:@");
            
            imp = class_getMethodImplementation([NSMutableDictionary class], @selector(mo_setObject:forKeyedSubscript:));
            class_addMethod([NSMutableDictionary class], @selector(setObject:forKeyedSubscript:), imp, "@@:@@");
        }
        
        // Swizzle in NSObject additions
        [NSObject mo_swizzleAdditions];
    }
}

+ (Mocha *)sharedRuntime {
    static Mocha *sharedRuntime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRuntime = [[self alloc] init];
    });
    return sharedRuntime;
}

+ (Mocha *)runtimeWithContext:(JSContextRef)ctx {
    JSStringRef jsName = JSStringCreateWithUTF8CString("__mocha__");
    JSValueRef jsValue = JSObjectGetProperty(ctx, JSContextGetGlobalObject(ctx), jsName, NULL);
    JSStringRelease(jsName);
    return [self objectForJSValue:jsValue inContext:ctx];
}

- (id)init {
    return [self initWithGlobalContext:NULL];
}

- (id)initWithGlobalContext:(JSGlobalContextRef)ctx {
    if (ctx == NULL) {
        ctx = JSGlobalContextCreate(MochaClass);
        _ownsContext = YES;
    }
    else {
        JSGlobalContextRetain(ctx);
        _ownsContext = NO;
        
        // Create the global "Mocha" object
        JSObjectRef o = JSObjectMake(ctx, MochaClass, NULL);
        JSStringRef jsName = JSStringCreateWithUTF8CString("Mocha");
        JSObjectSetProperty(ctx, JSContextGetGlobalObject(ctx), jsName, o, kJSPropertyAttributeDontDelete, NULL);
        JSStringRelease(jsName);
    }
    
    self = [super init];
    if (self) {
        _ctx = ctx;
        _exportedObjects = [[NSMutableDictionary alloc] init];
        _objectsToBoxes = [NSMutableDictionary new];
        _frameworkSearchPaths = [[NSMutableArray alloc] initWithObjects:
                                 @"/System/Library/Frameworks",
                                 @"/Library/Frameworks",
                                 nil];
        
        // Add the runtime as a property of the context
        [self setObject:self withName:@"__mocha__" attributes:(kJSPropertyAttributeReadOnly|kJSPropertyAttributeDontEnum|kJSPropertyAttributeDontDelete)];
        
        // Load builtins
        [self installBuiltins];
        
        // Load base frameworks
#if !TARGET_OS_IPHONE
        [self loadFrameworkWithName:@"Foundation"];
        if (![self loadFrameworkWithName:@"CoreGraphics"]) {
            [self loadFrameworkWithName:@"CoreGraphics" inDirectory:@"/System/Library/Frameworks/ApplicationServices.framework/Frameworks"];
        }
#endif
    }
    return self;
}

- (void)dealloc {
    debug(@"%s:%d", __FUNCTION__, __LINE__);
    //[self cleanUp];
    
    if (_ctx) {
        debug(@"releasing _ctx");
        JSGlobalContextRelease(_ctx);
    }
}

- (JSGlobalContextRef)context {
    return _ctx;
}


#pragma mark -
#pragma mark Key-Value Coding

- (id)valueForUndefinedKey:(NSString *)key {
    return [_exportedObjects objectForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [_exportedObjects setObject:value forKey:key];
}

- (void)setNilValueForKey:(NSString *)key {
    [_exportedObjects removeObjectForKey:key];
}


#pragma mark -
#pragma mark Object Conversion

+ (JSValueRef)JSValueForObject:(id)object inContext:(JSContextRef)ctx {
    return [[Mocha runtimeWithContext:ctx] JSValueForObject:object];
}

+ (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx {
    return [self objectForJSValue:value inContext:ctx unboxObjects:YES];
}

+ (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx unboxObjects:(BOOL)unboxObjects {
    
    if (value == NULL || JSValueIsUndefined(ctx, value)) {
        return [MOUndefined undefined];
    }
    
    if (JSValueIsNull(ctx, value)) {
        return nil;
    }
    
    if (JSValueIsString(ctx, value)) {
        JSStringRef resultStringJS = JSValueToStringCopy(ctx, value, NULL);
        NSString *resultString = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, resultStringJS));
        JSStringRelease(resultStringJS);
        return resultString;
    }
    
    if (JSValueIsNumber(ctx, value)) {
        double v = JSValueToNumber(ctx, value, NULL);
        return [NSNumber numberWithDouble:v];
    }
    
    if (JSValueIsBoolean(ctx, value)) {
        bool v = JSValueToBoolean(ctx, value);
        return [NSNumber numberWithBool:v];
    }
    
    if (!JSValueIsObject(ctx, value)) {
        return nil;
    }
    
    JSObjectRef jsObject = JSValueToObject(ctx, value, NULL);
    id private = (__bridge id)JSObjectGetPrivate(jsObject);
    
    if (private != nil) {
        if ([private isKindOfClass:[MOBox class]]) {
            if (unboxObjects == YES) {
                // Boxed ObjC object
                id object = [private representedObject];
                if ([object isKindOfClass:[MOClosure class]]) {
                    // Auto-unbox closures
                    return [object block];
                }
                else {
                    return object;
                }
            }
            else {
                return private;
            }
        }
        else {
            return private;
        }
    }
    else {
        BOOL isFunction = JSObjectIsFunction(ctx, jsObject);
        if (isFunction) {
            // Function
            return [MOJavaScriptObject objectWithJSObject:jsObject context:ctx];
        }
        
        // Normal JS object
        JSStringRef scriptJS = JSStringCreateWithUTF8CString("return arguments[0].constructor == Array.prototype.constructor");
        JSObjectRef fn = JSObjectMakeFunction(ctx, NULL, 0, NULL, scriptJS, NULL, 1, NULL);
        JSValueRef result = JSObjectCallAsFunction(ctx, fn, NULL, 1, (JSValueRef *)&jsObject, NULL);
        JSStringRelease(scriptJS);
        
        BOOL isArray = JSValueToBoolean(ctx, result);
        if (isArray) {
            // Array
            return [self arrayForJSArray:jsObject inContext:ctx];
        }
        else {
            // Object
            return [self dictionaryForJSHash:jsObject inContext:ctx];
        }
    }
    
    return nil;
}

+ (NSArray *)arrayForJSArray:(JSObjectRef)arrayValue inContext:(JSContextRef)ctx {
    JSValueRef exception = NULL;
    JSStringRef lengthJS = JSStringCreateWithUTF8CString("length");
    NSUInteger length = JSValueToNumber(ctx, JSObjectGetProperty(ctx, arrayValue, lengthJS, NULL), &exception);
    JSStringRelease(lengthJS);
    
    if (exception != NULL) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:length];

    for (NSUInteger i=0; i<length; i++) {
        id obj = nil;
        JSValueRef jsValue = JSObjectGetPropertyAtIndex(ctx, arrayValue, (unsigned int)i, &exception);
        if (exception != NULL) {
            return nil;
        }
        
        obj = [self objectForJSValue:jsValue inContext:ctx unboxObjects:YES];
        if (obj == nil) {
            obj = [NSNull null];
        }
        
        [array addObject:obj];
    }
    
    return [array copy];
}

+ (NSDictionary *)dictionaryForJSHash:(JSObjectRef)hashValue inContext:(JSContextRef)ctx {
    JSPropertyNameArrayRef names = JSObjectCopyPropertyNames(ctx, hashValue);
    NSUInteger length = JSPropertyNameArrayGetCount(names);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:length];
    JSValueRef exception = NULL;
    
    for (NSUInteger i=0; i<length; i++) {
        id obj = nil;
        JSStringRef name = JSPropertyNameArrayGetNameAtIndex(names, i);
        JSValueRef jsValue = JSObjectGetProperty(ctx, hashValue, name, &exception);
        
        if (exception != NULL) {
            return NO;
        }
        
        obj = [self objectForJSValue:jsValue inContext:ctx unboxObjects:YES];
        if (obj == nil) {
            obj = [NSNull null];
        }
        
        NSString *key = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, name));
        [dictionary setObject:obj forKey:key];
    }
    
    JSPropertyNameArrayRelease(names);
    
    return [dictionary copy];
}

- (JSValueRef)JSValueForObject:(id)object {
    JSValueRef value = NULL;
    
    if ([object isKindOfClass:[MOBox class]]) {
        value = [object JSObject];
    }
    else if ([object isKindOfClass:[MOJavaScriptObject class]]) {
        return [object JSObject];
    }
    /*else if ([object isKindOfClass:[NSString class]]) {
        JSStringRef string = JSStringCreateWithCFString((CFStringRef)object);
        value = JSValueMakeString(_ctx, string);
        JSStringRelease(string);
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        double doubleValue = [object doubleValue];
        value = JSValueMakeNumber(_ctx, doubleValue);
    }*/
    else if ([object isKindOfClass:NSClassFromString(@"NSBlock")]) {
        // Auto-box blocks inside of a closure object
        MOClosure *closure = [MOClosure closureWithBlock:object];
        value = [self boxedJSObjectForObject:closure];
    }
    else if (object == nil/* || [object isKindOfClass:[NSNull class]]*/) {
        value = JSValueMakeNull(_ctx);
    }
    else if (object == [MOUndefined undefined]) {
        value = JSValueMakeUndefined(_ctx);
    }
    
    if (value == NULL) {
        value = [self boxedJSObjectForObject:object];
    }
    
    return value;
}

- (id)objectForJSValue:(JSValueRef)value {
    return [self objectForJSValue:value unboxObjects:YES];
}

- (id)objectForJSValue:(JSValueRef)value unboxObjects:(BOOL)unboxObjects {
    return [Mocha objectForJSValue:value inContext:_ctx unboxObjects:unboxObjects];
}

- (JSObjectRef)boxedJSObjectForObject:(id)object {
    if (object == nil) {
        return NULL;
    }
    
    JSObjectRef jsObject = NULL;
    NSValue *objectPointerValue = [NSValue valueWithPointer:(__bridge const void *)(object)];
    MOBox* box = [_objectsToBoxes objectForKey:objectPointerValue];
    if (box != nil) {
        jsObject = [box JSObject];
    } else {
        box = [[MOBox alloc] initWithRuntime:self];
        
        if ([object isKindOfClass:[MOMethod class]]
            || [object isKindOfClass:[MOClosure class]]
            || [object isKindOfClass:[MOBridgeSupportFunction class]]) {
            jsObject = JSObjectMake(_ctx, MOFunctionClass, (__bridge void *)(box));
        }
        else {
            jsObject = JSObjectMake(_ctx, MOBoxedObjectClass, (__bridge void *)(box));
        }
        
        [box associateObject:object jsObject:jsObject context:_ctx];
        [_objectsToBoxes setObject:box forKey: objectPointerValue];
    }
    
    return jsObject;
}

- (id)unboxedObjectForJSObject:(JSObjectRef)jsObject {
    id private = (__bridge id)(JSObjectGetPrivate(jsObject));
    if ([private isKindOfClass:[MOBox class]]) {
        return [private representedObject];
    }
    return nil;
}

- (void)removeBoxAssociationForObject:(id)object {
    if (object != nil) {
        [self removeBoxForObjectPointerValue:[NSValue valueWithPointer:(__bridge const void *)(object)]];
    }
}

- (void)removeBoxForObjectPointerValue:(NSValue *)objectPointerValue {
    MOBox* box = [_objectsToBoxes objectForKey:objectPointerValue];
    if (box) {
        [box disassociateObjectInContext:_ctx];
        [_objectsToBoxes removeObjectForKey:objectPointerValue];
    }
}

#pragma mark -
#pragma mark Object Storage

- (id)objectWithName:(NSString *)name {
    JSValueRef exception = NULL;
    
    JSStringRef jsName = JSStringCreateWithUTF8CString([name UTF8String]);
    JSValueRef jsValue = JSObjectGetProperty(_ctx, JSContextGetGlobalObject(_ctx), jsName, &exception);
    JSStringRelease(jsName);
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return [self objectForJSValue:jsValue];
}

- (JSValueRef)setObject:(id)object withName:(NSString *)name {
    return [self setObject:object withName:name attributes:(kJSPropertyAttributeNone)];
}

- (JSValueRef)setObject:(id)object withName:(NSString *)name attributes:(JSPropertyAttributes)attributes {
    JSValueRef jsValue = [self JSValueForObject:object];
    
    // Set
    JSValueRef exception = NULL;
    JSStringRef jsName = JSStringCreateWithUTF8CString([name UTF8String]);
    JSObjectSetProperty(_ctx, JSContextGetGlobalObject(_ctx), jsName, jsValue, attributes, &exception);
    JSStringRelease(jsName);
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return jsValue;
}

- (BOOL)removeObjectWithName:(NSString *)name {
    JSValueRef exception = NULL;
    
    // Delete
    JSStringRef jsName = JSStringCreateWithUTF8CString([name UTF8String]);
    JSObjectDeleteProperty(_ctx, JSContextGetGlobalObject(_ctx), jsName, &exception);
    JSStringRelease(jsName);
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NO;
    }
    
    return YES;
}


#pragma mark -
#pragma mark Evaluation

- (id)evalString:(NSString *)string {
    JSValueRef jsValue = [self evalJSString:string];
    return [self objectForJSValue:jsValue];
}

- (id)evalString:(NSString *)string atURL:(NSURL *)url {
#ifdef MAC_OS_X_VERSION_10_10
    if (JSGlobalContextSetName != NULL)
    {
        NSString* name = url ? [[url lastPathComponent] stringByDeletingPathExtension] : @"Untitled Script";
        JSStringRef jsName = JSStringCreateWithUTF8CString([name UTF8String]);
        JSGlobalContextSetName(_ctx, jsName);
        JSStringRelease(jsName);
    }
#endif
    JSValueRef jsValue = [self evalJSString:string scriptPath:[url path]];
    return [self objectForJSValue:jsValue];
}

- (JSValueRef)evalJSString:(NSString *)string {
    return [self evalJSString:string scriptPath:nil];
}

- (JSValueRef)evalJSString:(NSString *)string scriptPath:(NSString *)scriptPath {
    if (string == nil) {
        return NULL;
    }
    
    JSStringRef jsString = JSStringCreateWithCFString((__bridge CFStringRef)string);
    JSStringRef jsScriptPath = (scriptPath != nil ? JSStringCreateWithUTF8CString([scriptPath UTF8String]) : NULL);
    JSValueRef exception = NULL;
    
    JSValueRef result = JSEvaluateScript(_ctx, jsString, NULL, jsScriptPath, 1, &exception);
    
    if (jsString != NULL) {
        JSStringRelease(jsString);
    }
    if (jsScriptPath != NULL) {
        JSStringRelease(jsScriptPath);
    }
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return result;
}


#pragma mark -
#pragma mark Functions

- (id)callFunctionWithName:(NSString *)functionName {
    return [self callFunctionWithName:functionName withArguments:nil];
}

- (id)callFunctionWithName:(NSString *)functionName withArguments:(id)firstArg, ... {
    NSMutableArray *arguments = [NSMutableArray array];
    
    va_list args;
    va_start(args, firstArg);
    for (id arg = firstArg; arg != nil; arg = va_arg(args, id)) {
        [arguments addObject:arg];
    }
    va_end(args);
    
    return [self callFunctionWithName:functionName withArgumentsInArray:arguments];
}

- (id)callFunctionWithName:(NSString *)functionName withArgumentsInArray:(NSArray *)arguments {
    JSValueRef value = [self callJSFunctionWithName:functionName withArgumentsInArray:arguments];
    return [self objectForJSValue:value];
}

- (JSObjectRef)JSFunctionWithName:(NSString *)functionName {
    JSValueRef exception = NULL;
    
    // Get function as property of global object
    JSStringRef jsFunctionName = JSStringCreateWithUTF8CString([functionName UTF8String]);
    JSValueRef jsFunctionValue = JSObjectGetProperty(_ctx, JSContextGetGlobalObject(_ctx), jsFunctionName, &exception);
    JSStringRelease(jsFunctionName);
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return JSValueToObject(_ctx, jsFunctionValue, NULL);
}

- (JSValueRef)callJSFunctionWithName:(NSString *)functionName withArgumentsInArray:(NSArray *)arguments {
    JSObjectRef jsFunction = [self JSFunctionWithName:functionName];
    if (jsFunction == NULL) {
        return NULL;
    }
    return [self callJSFunction:jsFunction withArgumentsInArray:arguments];
}

- (JSValueRef)callJSFunction:(JSObjectRef)jsFunction withArgumentsInArray:(NSArray *)arguments {
    JSValueRef *jsArguments = NULL;
    NSUInteger argumentsCount = [arguments count];
    if (argumentsCount > 0) {
        jsArguments = malloc(sizeof(JSValueRef) * argumentsCount);
        for (NSUInteger i=0; i<argumentsCount; i++) {
            id argument = [arguments objectAtIndex:i];
            JSValueRef value = [self JSValueForObject:argument];
            jsArguments[i] = value;
        }
    }
    
    assert((JSValueGetType(_ctx, jsFunction) == kJSTypeObject));
    JSValueRef exception = NULL;
    //debug(@"calling function");
    JSValueRef returnValue = JSObjectCallAsFunction(_ctx, jsFunction, NULL, argumentsCount, jsArguments, &exception);
    //debug(@"called");
    if (jsArguments != NULL) {
        free(jsArguments);
    }
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return returnValue;
}


#pragma mark -
#pragma mark Syntax Validation

- (BOOL)isSyntaxValidForString:(NSString *)string {
    JSStringRef jsScript = JSStringCreateWithUTF8CString([string UTF8String]);
    JSValueRef exception = NULL;
    bool success = JSCheckScriptSyntax(_ctx, jsScript, NULL, 1, &exception);
    
    if (jsScript != NULL) {
        JSStringRelease(jsScript);
    }
    
    if (exception != NULL) {
        [self throwJSException:exception];
    }
    
    return success;
}


#pragma mark -
#pragma mark Exceptions

+ (NSException *)exceptionWithJSException:(JSValueRef)exception context:(JSContextRef)ctx {
    NSString *error = nil;
    JSStringRef resultStringJS = JSValueToStringCopy(ctx, exception, NULL);
    if (resultStringJS != NULL) {
        error = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, resultStringJS));
        JSStringRelease(resultStringJS);
    }
    
    if (JSValueGetType(ctx, exception) != kJSTypeObject) {
        NSException *mochaException = [NSException exceptionWithName:MOJavaScriptException reason:error userInfo:nil];
        return mochaException;
    }
    else {
        // Iterate over all properties of the exception
        JSObjectRef jsObject = JSValueToObject(ctx, exception, NULL);
        JSPropertyNameArrayRef jsNames = JSObjectCopyPropertyNames(ctx, jsObject);
        size_t count = JSPropertyNameArrayGetCount(jsNames);
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:count];
        
        for (size_t i = 0; i < count; i++) {
            JSStringRef jsName = JSPropertyNameArrayGetNameAtIndex(jsNames, i);
            NSString *name = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, jsName));
            
            JSValueRef jsValueRef = JSObjectGetProperty(ctx, jsObject, jsName, NULL);
            JSStringRef valueJS = JSValueToStringCopy(ctx, jsValueRef, NULL);
            NSString *value = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, valueJS));
            JSStringRelease(valueJS);
            
            [userInfo setObject:value forKey:name];
        }
        
        JSPropertyNameArrayRelease(jsNames);
        
        NSException *mochaException = [NSException exceptionWithName:MOJavaScriptException reason:error userInfo:userInfo];
        return mochaException;
    }
}

- (NSException *)exceptionWithJSException:(JSValueRef)exception {
    return [Mocha exceptionWithJSException:exception context:_ctx];
}

- (void)throwJSException:(JSValueRef)exceptionJS {
    id object = [self objectForJSValue:exceptionJS];
    if ([object isKindOfClass:[NSException class]]) {
        // Rethrow ObjC exceptions that were boxed within the runtime
        @throw object;
    }
    else {
        // Throw all other types of exceptions as an NSException
        NSException *exception = [self exceptionWithJSException:exceptionJS];
        if (exception != nil) {
            @throw exception;
        }
    }
}


#pragma mark -
#pragma mark BridgeSupport Metadata

- (BOOL)loadFrameworkWithName:(NSString *)frameworkName {
    BOOL success = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    for (NSString *path in _frameworkSearchPaths) {
        NSString *frameworkPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.framework", frameworkName]];
        if ([fileManager fileExistsAtPath:frameworkPath]) {
            success = [self loadFrameworkWithName:frameworkName inDirectory:path];
            if (success) {
                break;
            }
        }
    }
    
    return success;
}

- (BOOL)loadFrameworkWithName:(NSString *)frameworkName inDirectory:(NSString *)directory {
    NSString *frameworkPath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.framework", frameworkName]];
    
    // Load the framework
    NSString *libPath = [frameworkPath stringByAppendingPathComponent:frameworkName];
    void *address = dlopen([libPath UTF8String], RTLD_LAZY);
    if (!address) {
        //NSLog(@"ERROR: Could not load framework dylib: %@, %@", frameworkName, libPath);
        return NO;
    }
    
    // Load the BridgeSupport data
    NSString *bridgeSupportPath = [frameworkPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Resources/BridgeSupport"]];
    [self loadBridgeSupportFilesAtPath:bridgeSupportPath];
    
    return YES;
}

- (BOOL)loadBridgeSupportFilesAtPath:(NSString *)path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        NSMutableArray *filesToLoad = [NSMutableArray array];
        if (isDirectory) {
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:nil];
            for (NSString *filePathComponent in contents) {
                NSString *filePath = [path stringByAppendingPathComponent:filePathComponent];
                if ([[filePath pathExtension] isEqualToString:@"bridgesupport"]
                    || [[filePathComponent pathExtension] isEqualToString:@"dylib"]) {
                    [filesToLoad addObject:filePath];
                }
            }
        }
        else {
            if ([[path pathExtension] isEqualToString:@"bridgesupport"]
                || [[path pathExtension] isEqualToString:@"dylib"]) {
                [filesToLoad addObject:path];
            }
            else {
                return NO;
            }
        }
        
        // Load files
        for (NSString *filePath in filesToLoad) {
            if ([[filePath pathExtension] isEqualToString:@"bridgesupport"]) {
                // BridgeSupport
                NSError *error = nil;
                if (![[MOBridgeSupportController sharedController] loadBridgeSupportAtURL:[NSURL fileURLWithPath:filePath] error:&error]) {
                    return NO;
                }
            }
#if !TARGET_OS_IPHONE
            else if ([[filePath pathExtension] isEqualToString:@"dylib"]) {
                // dylib
                dlopen([filePath UTF8String], RTLD_LAZY);
            }
#endif
        }
        
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray *)frameworkSearchPaths {
    return _frameworkSearchPaths;
}

- (void)setFrameworkSearchPaths:(NSArray *)frameworkSearchPaths {
    [_frameworkSearchPaths setArray:frameworkSearchPaths];
}

- (void)addFrameworkSearchPath:(NSString *)path {
    [self insertFrameworkSearchPath:path atIndex:[_frameworkSearchPaths count]];
}

- (void)insertFrameworkSearchPath:(NSString *)path atIndex:(NSUInteger)idx {
    [_frameworkSearchPaths insertObject:path atIndex:idx];
}

- (void)removeFrameworkSearchPathAtIndex:(NSUInteger)idx {
    [_frameworkSearchPaths removeObjectAtIndex:idx];
}


#pragma mark -
#pragma mark Garbage Collection

- (void)garbageCollect {
    JSGarbageCollect(_ctx);
}


#pragma mark -
#pragma mark Support

- (void)installBuiltins {
    MOMethod *loadFramework = [MOMethod methodWithTarget:self selector:@selector(loadFrameworkWithName:)];
    [self setValue:loadFramework forKey:@"framework"];
    
    MOMethod *addFrameworkSearchPath = [MOMethod methodWithTarget:self selector:@selector(addFrameworkSearchPath:)];
    [self setValue:addFrameworkSearchPath forKey:@"addFrameworkSearchPath"];
    
    MOMethod *print = [MOMethod methodWithTarget:self selector:@selector(print:)];
    [self setValue:print forKey:@"print"];
    
    [self setValue:[MOObjCRuntime sharedRuntime] forKey:@"objc"];
}

- (void)shutdown {
    
    [self setNilValueForKey:@"framework"];
    [self setNilValueForKey:@"addFrameworkSearchPath"];
    [self setNilValueForKey:@"objc"];
    [self setNilValueForKey:@"print"];
    
    [self removeObjectWithName:@"__mocha__"];
    
    JSGlobalContextRelease(_ctx);
    
    _ctx = nil;
    
    //[_mochaRuntime garbageCollect];
    
}

- (void)print:(id)o {
    if (!o) {
        printf("null\n");
        return;
    }
    printf("%s\n", [[o description] UTF8String]);
}

- (void)cleanUp {
    // Cleanup if we created the JavaScriptCore context
    if (_ownsContext) {
//        [self unlinkAllReferences];
        [self garbageCollect];
    }
}

//- (void)unlinkAllReferences {
//    // Null and delete every reference to every live object
//    [self evalJSString:@"for (var i in this) { this[i] = null; delete this[i]; }"];
//}


#pragma mark -
#pragma mark Symbols

- (NSArray *)globalSymbolNames {
    NSMutableArray *symbols = [NSMutableArray array];
    
    // Exported objects
    [symbols addObjectsFromArray:[_exportedObjects allKeys]];
    
    // ObjC runtime
    [symbols addObjectsFromArray:[[MOObjCRuntime sharedRuntime] classes]];
    [symbols addObjectsFromArray:[[MOObjCRuntime sharedRuntime] protocols]];
    
    // BridgeSupport
    NSDictionary *bridgeSupportSymbols = [[MOBridgeSupportController sharedController] performQueryForSymbolsOfType:[NSArray arrayWithObjects:
                                                                                                                     [MOBridgeSupportFunction class],
                                                                                                                     [MOBridgeSupportConstant class],
                                                                                                                     [MOBridgeSupportEnum class],
                                                                                                                     nil]];
    [symbols addObjectsFromArray:[bridgeSupportSymbols allKeys]];
    
    return symbols;
}

@end


#pragma mark -
#pragma mark Mocha Scripting

@implementation NSObject (MochaScripting)

+ (BOOL)isSelectorExcludedFromMochaScript:(SEL)selector {
    return NO;
}

+ (SEL)selectorForMochaPropertyName:(NSString *)propertyName {
    return MOSelectorFromPropertyName(propertyName);
}

- (void)finalizeForMochaScript {
    // no-op
}

@end


#pragma mark -
#pragma mark Global Object

//static void Mocha_initialize(JSContextRef ctx, JSObjectRef object) {
//    MOBox *private = (__bridge MOBox *)(JSObjectGetPrivate(object));
//    
//    if (private) {
//        
//        CFRetain((__bridge CFTypeRef)private);
//        
////        if (class_isMetaClass(object_getClass([private representedObject]))) {
////            debug(@"inited a global class object %@ - going to keep it protected", [private representedObject]);
////            JSValueProtect(ctx, [private JSObject]);
////        }
//    }
//    
//    
//}
//
//static void Mocha_finalize(JSObjectRef object) {
//    MOBox *private = (__bridge MOBox *)(JSObjectGetPrivate(object));
//    id o = [private representedObject];
//    
//    //debug(@"finalizing %@ o: %p", o, object);
//    
//    if (class_isMetaClass(object_getClass(o))) {
//        debug(@"Finalizing global class: %@ %p", o, object);
//    }
//}


JSValueRef Mocha_getProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyNameJS, JSValueRef *exception) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, propertyNameJS));
    
    if ([propertyName isEqualToString:@"__mocha__"]) {
        return NULL;
    }
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    assert([runtime isKindOfClass:[Mocha class]]);
    
    
    //
    // Exported objects
    //
    id exportedObj = [runtime valueForKey:propertyName];
    if (exportedObj != nil) {
        JSValueRef ret = [runtime JSValueForObject:exportedObj];
        
        if (!objc_getAssociatedObject(exportedObj, &MOAlreadyProtectedKey)) {
            debug(@"protecting an exported object: %@ %p", propertyName, ret);
            objc_setAssociatedObject(exportedObj, &MOAlreadyProtectedKey, @(1), OBJC_ASSOCIATION_RETAIN);
            JSValueProtect(ctx, ret);
        }
        
        return ret;
    }
    
    //
    // ObjC class
    //
    Class objCClass = NSClassFromString(propertyName);
    if (objCClass && ![propertyName isEqualToString:@"Object"]) {
        JSValueRef ret = [runtime JSValueForObject:objCClass];
        
        if (!objc_getAssociatedObject(objCClass, &MOAlreadyProtectedKey)) {
            debug(@"inited a global class object %@ - going to keep it protected %p", propertyName, ret);
            objc_setAssociatedObject(objCClass, &MOAlreadyProtectedKey, @(1), OBJC_ASSOCIATION_RETAIN);
            JSValueProtect(ctx, ret);
        }
        
        return ret;
    }
    
    //
    // Query BridgeSupport for property
    //
    MOBridgeSupportSymbol *symbol = [[MOBridgeSupportController sharedController] performQueryForSymbolName:propertyName];
    if (symbol != nil) {
        // Functions
        if ([symbol isKindOfClass:[MOBridgeSupportFunction class]]) {
            return [runtime JSValueForObject:symbol];
        }
        
        // Constants
        else if ([symbol isKindOfClass:[MOBridgeSupportConstant class]]) {
            NSString *type = nil;
#if __LP64__
            type = [(MOBridgeSupportConstant *)symbol type64];
            if (type == nil) {
                type = [(MOBridgeSupportConstant *)symbol type];
            }
#else
            type = [(MOBridgeSupportConstant *)symbol type];
#endif
            
            // Raise if there is no type
            if (type == nil) {
                NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"No type defined for symbol: %@", symbol] userInfo:nil];
                if (exception != NULL) {
                    *exception = [runtime JSValueForObject:e];
                }
                return NULL;
            }
            
            // Grab symbol
            void *dlsymbol = dlsym(RTLD_DEFAULT, [propertyName UTF8String]);
            if (!dlsymbol) {
                NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Symbol not found: %@", dlsymbol] userInfo:nil];
                if (exception != NULL) {
                    *exception = [runtime JSValueForObject:e];
                }
                return NULL;
            }
            
            char typeEncodingChar = [type UTF8String][0];
            MOFunctionArgument *argument = [[MOFunctionArgument alloc] init];
            
            if (typeEncodingChar == _C_STRUCT_B) {
                [argument setStructureTypeEncoding:type withCustomStorage:dlsymbol];
            }
            else if (typeEncodingChar == _C_PTR) {
                if ([type isEqualToString:@"^{__CFString=}"]) {
                    [argument setTypeEncoding:_C_ID withCustomStorage:dlsymbol];
                }
                else {
                    [argument setPointerTypeEncoding:type withCustomStorage:dlsymbol];
                }
            }
            else {
                [argument setTypeEncoding:typeEncodingChar withCustomStorage:dlsymbol];
            }
            
            JSValueRef valueJS = [argument getValueAsJSValueInContext:ctx];
            
            return valueJS;
        }
        
        // Enums
        else if ([symbol isKindOfClass:[MOBridgeSupportEnum class]]) {
            double doubleValue = 0;
            NSNumber *value = [(MOBridgeSupportEnum *)symbol value];
#if __LP64__
            NSNumber *value64 = [(MOBridgeSupportEnum *)symbol value64];
            if (value64 != nil) {
                doubleValue = [value doubleValue];
            }
            else {
#endif
                if (value != nil) {
                    doubleValue = [value doubleValue];
                }
                else {
                    NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"No value for enum: %@", symbol] userInfo:nil];
                    if (exception != NULL) {
                        *exception = [runtime JSValueForObject:e];
                    }
                    return NULL;
                }
#if __LP64__
            }
#endif
            return JSValueMakeNumber(ctx, doubleValue);
        }
    }
    
    return NULL;
}


#pragma mark -
#pragma mark Mocha Objects

static void MOObject_initialize(JSContextRef ctx, JSObjectRef object) {
    MOBox *private = (__bridge MOBox *)(JSObjectGetPrivate(object));
    CFRetain((__bridge CFTypeRef)private);
    
    if (class_isMetaClass(object_getClass([private representedObject]))) {
        //debug(@"inited a local class object %@ - going to keep it protected %p", [private representedObject], object);
//        JSValueProtect(ctx, [private JSObject]);
    }
    
}

static void MOObject_finalize(JSObjectRef object) {
    MOBox *private = (__bridge MOBox *)(JSObjectGetPrivate(object));
    id o = [private representedObject];
    
//    if (class_isMetaClass(object_getClass(o))) {
//        debug(@"Finalizing local class: %@ %p", o, object);
//    }
    
    // Give the object a chance to finalize itself
    if ([o respondsToSelector:@selector(finalizeForMochaScript)]) {
        [o finalizeForMochaScript];
    }
    
    // Remove the object association
    Mocha *runtime = [private runtime];
    [runtime removeBoxAssociationForObject:o];
    
    JSObjectSetPrivate(object, NULL);
    
    CFRelease((__bridge CFTypeRef)private);
}


#pragma mark -
#pragma mark Mocha Boxed Objects

static bool MOBoxedObject_hasProperty(JSContextRef ctx, JSObjectRef objectJS, JSStringRef propertyNameJS) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(NULL, propertyNameJS));
    
//    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    id private = (__bridge id)(JSObjectGetPrivate(objectJS));
    id object = [private representedObject];
    Class objectClass = [object class];
    
    // String conversion
    if ([propertyName isEqualToString:@"toString"]) {
        return YES;
    }
    
    
    if ([object isKindOfClass:[Mocha class]] && [propertyName isEqualToString:@"protect"]) {
        return YES;
    }
    
    // Allocators
    if ([object isKindOfClass:[MOAllocator class]]) {
        objectClass = [object objectClass];
        
        // Method
        SEL selector = MOSelectorFromPropertyName(propertyName);
        NSMethodSignature *methodSignature = [objectClass instanceMethodSignatureForSelector:selector];
        if (!methodSignature) {
            // Allow the trailing underscore to be left off (issue #7)
            selector = MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"]);
            methodSignature = [objectClass instanceMethodSignatureForSelector:selector];
        }
        if (methodSignature != nil) {
            if ([objectClass respondsToSelector:@selector(isSelectorExcludedFromMochaScript:)]) {
                if (![objectClass isSelectorExcludedFromMochaScript:selector]) {
                    return YES;
                }
            }
            else {
                return YES;
            }
        }
    }
    
    // Property
    objc_property_t property = class_getProperty(objectClass, [propertyName UTF8String]);
    if (property != NULL) {
        SEL selector = NULL;
        char * getterValue = property_copyAttributeValue(property, "G");
        if (getterValue != NULL) {
            selector = NSSelectorFromString([NSString stringWithUTF8String:getterValue]);
            free(getterValue);
        }
        else {
            selector = NSSelectorFromString(propertyName);
        }
        
        if ([object respondsToSelector:selector] && ![objectClass isSelectorExcludedFromMochaScript:selector]) {
            return YES;
        }
    }
    
    // Association object
    id value = objc_getAssociatedObject(object, (__bridge const void *)(propertyName));
    if (value != nil) {
        return YES;
    }
    
    
    
    
    
    // Method
    SEL selector = MOSelectorFromPropertyName(propertyName);
    
    // calling methodSignatureForSelector: on a proxy when it doesn't respond to the selector will throw an exception and we'll crash.
    // so we'll just look ahead and see if maybe it is because of a missing _
    if (([object class] == [NSDistantObject class]) && ![object respondsToSelector:selector] && [object respondsToSelector:MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"])]) {
        return YES;
    }
    
    NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
    if (!methodSignature) {
        // Allow the trailing underscore to be left off (issue #7)
        selector = MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"]);
        methodSignature = [object methodSignatureForSelector:selector];
    }
    if (methodSignature != nil) {
        if ([objectClass respondsToSelector:@selector(isSelectorExcludedFromMochaScript:)]) {
            if (![objectClass isSelectorExcludedFromMochaScript:selector]) {
                return YES;
            }
        }
        else {
            return YES;
        }
    }
    
    // Indexed subscript
    if ([object respondsToSelector:@selector(objectForIndexedSubscript:)]) {
        NSScanner *scanner = [NSScanner scannerWithString:propertyName];
        NSInteger integerValue;
        if ([scanner scanInteger:&integerValue]) {
            return YES;
        }
    }
    
    // Keyed subscript
    if ([object respondsToSelector:@selector(objectForKeyedSubscript:)]) {
        return YES;
    }
    
    
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSArray class]]) {
        // special case bridging of NSString & NSArray w/ JS functions
        
        if (MOJSPrototypeForOBJCInstance(ctx, object, propertyName)) {
            return YES;
        }
        
        if ([object isKindOfClass:[NSArray class]]) {
            if ([propertyName isEqualToString:@"length"]) {
                return YES;
            }
        }
    }
    
    
    return NO;
}

static JSValueRef MOBoxedObject_getProperty(JSContextRef ctx, JSObjectRef objectJS, JSStringRef propertyNameJS, JSValueRef *exception) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(NULL, propertyNameJS));
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    id private = (__bridge id)(JSObjectGetPrivate(objectJS));
    id object = [private representedObject];
    Class objectClass = [object class];
    
    // Perform the lookup
    @try {
        // String conversion
        if ([propertyName isEqualToString:@"toString"]) {
            MOMethod *function = [MOMethod methodWithTarget:object selector:@selector(description)];
            return [runtime JSValueForObject:function];
        }
        
        // Allocators
        if ([object isKindOfClass:[MOAllocator class]]) {
            objectClass = [object objectClass];
            
            // Method
            SEL selector = MOSelectorFromPropertyName(propertyName);
            NSMethodSignature *methodSignature = [objectClass instanceMethodSignatureForSelector:selector];
            if (!methodSignature) {
                // Allow the trailing underscore to be left off (issue #7)
                selector = MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"]);
                methodSignature = [objectClass instanceMethodSignatureForSelector:selector];
            }
            if (methodSignature != nil) {
                BOOL implements = NO;
                if ([objectClass respondsToSelector:@selector(isSelectorExcludedFromMochaScript:)]) {
                    if (![objectClass isSelectorExcludedFromMochaScript:selector]) {
                        implements = YES;
                    }
                }
                else {
                    implements = YES;
                }
                if (implements) {
                    MOMethod *function = [MOMethod methodWithTarget:object selector:selector];
                    return [runtime JSValueForObject:function];
                }
            }
        }
        
        
        // Association object
        id value = objc_getAssociatedObject(object, (__bridge const void *)(propertyName));
        if (value != nil) {
            return [runtime JSValueForObject:value];
        }
        
        // Method
        SEL selector = MOSelectorFromPropertyName(propertyName);
        if (([object class] == [NSDistantObject class]) && ![object respondsToSelector:selector] && [object respondsToSelector:MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"])]) {
            propertyName = [propertyName stringByAppendingString:@"_"];
            selector = MOSelectorFromPropertyName(propertyName);
        }
        
        NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
        if (!methodSignature) {
            // Allow the trailing underscore to be left off (issue #7)
            selector = MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"]);
            methodSignature = [object methodSignatureForSelector:selector];
        }
        if (methodSignature != nil) {
            BOOL implements = NO;
            if ([objectClass respondsToSelector:@selector(isSelectorExcludedFromMochaScript:)]) {
                if (![objectClass isSelectorExcludedFromMochaScript:selector]) {
                    implements = YES;
                }
            }
            else {
                implements = YES;
            }
            if (implements) {
                MOMethod *function = [MOMethod methodWithTarget:object selector:selector];
                return [runtime JSValueForObject:function];
            }
        }
        
        // Property
        objc_property_t property = class_getProperty(objectClass, [propertyName UTF8String]);
        if (property != NULL) {
            SEL getterSelector = NULL;
            char * getterValue = property_copyAttributeValue(property, "G");
            if (getterValue != NULL) {
                getterSelector = NSSelectorFromString([NSString stringWithUTF8String:getterValue]);
                free(getterValue);
            }
            else {
                getterSelector = NSSelectorFromString(propertyName);
            }
            
            if ([object respondsToSelector:getterSelector] && ![objectClass isSelectorExcludedFromMochaScript:getterSelector]) {
                MOMethod *method = [MOMethod methodWithTarget:object selector:selector];
                JSValueRef invocationValue = MOFunctionInvoke(method, ctx, 0, NULL, exception);
                return invocationValue;
            }
        }
        
        // Indexed subscript
        if ([object respondsToSelector:@selector(objectForIndexedSubscript:)]) {
            NSScanner *scanner = [NSScanner scannerWithString:propertyName];
            NSInteger integerValue;
            if ([scanner scanInteger:&integerValue]) {
                id indexedValue = [object objectForIndexedSubscript:integerValue];
                if (indexedValue != nil) {
                    return [runtime JSValueForObject:indexedValue];
                }
            }
        }
        
        // Keyed subscript
        if ([object respondsToSelector:@selector(objectForKeyedSubscript:)]) {
            id subscriptValue = [object objectForKeyedSubscript:propertyName];
            if (subscriptValue != nil) {
                return [runtime JSValueForObject:subscriptValue];
            }
            else {
                return JSValueMakeNull(ctx);
            }
        }
        
        if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSArray class]]) {
            // special case bridging of NSString & NSArray w/ JS functions
            
            JSValueRef jsPropertyValue = MOJSPrototypeForOBJCInstance(ctx, object, propertyName);
            if (jsPropertyValue) {
                return jsPropertyValue;
            }
            
            
            if ([object isKindOfClass:[NSArray class]]) {
                
                // special case this property.
                if ([propertyName isEqualToString:@"length"]) {
                    MOMethod *method = [MOMethod methodWithTarget:object selector:@selector(count)];
                    return MOFunctionInvoke(method, ctx, 0, NULL, exception);
                }
            }
        }
        
        
        
//        if (exception != NULL) {
//            NSString *reason = nil;
//            if (object == objectClass) {
//                // Class method
//                reason = [NSString stringWithFormat:@"Unrecognized selector sent to class: +[%@ %@]", objectClass, NSStringFromSelector(selector)];
//            }
//            else {
//                // Instance method
//                reason = [NSString stringWithFormat:@"Unrecognized selector sent to instance -[%@ %@]", objectClass, NSStringFromSelector(selector)];
//            }
//            NSException *e = [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
//            *exception = [runtime JSValueForObject:e];
//        }
//        
//        return NULL;
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return NULL;
}

static bool MOBoxedObject_setProperty(JSContextRef ctx, JSObjectRef objectJS, JSStringRef propertyNameJS, JSValueRef valueJS, JSValueRef *exception) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(NULL, propertyNameJS));
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    id private = (__bridge id)(JSObjectGetPrivate(objectJS));
    id object = [private representedObject];
    Class objectClass = [object class];
    id value = [runtime objectForJSValue:valueJS];
    
    // Perform the lookup
    @try {
        // Property
        objc_property_t property = class_getProperty(objectClass, [propertyName UTF8String]);
        if (property != NULL) {
            SEL selector = NULL;
            char * setterValue = property_copyAttributeValue(property, "S");
            if (setterValue != NULL) {
                selector = NSSelectorFromString([NSString stringWithUTF8String:setterValue]);
                free(setterValue);
            }
            else {
                NSString *setterName = MOPropertyNameToSetterName(propertyName);
                selector = MOSelectorFromPropertyName(setterName);
            }
            
            if ([object respondsToSelector:selector] && ![objectClass isSelectorExcludedFromMochaScript:selector]) {
                MOMethod *method = [MOMethod methodWithTarget:object selector:selector];
                MOFunctionInvoke(method, ctx, 1, &valueJS, exception);
                return YES;
            }
        }
        
        // Indexed subscript
        if ([object respondsToSelector:@selector(setObject:forIndexedSubscript:)]) {
            NSScanner *scanner = [NSScanner scannerWithString:propertyName];
            NSInteger integerValue;
            if ([scanner scanInteger:&integerValue]) {
                [object setObject:value forIndexedSubscript:integerValue];
                return YES;
            }
        }
        
        // Keyed subscript
        if ([object respondsToSelector:@selector(objectForKeyedSubscript:)]) {
            [object setObject:value forKeyedSubscript:propertyName];
            return YES;
        }
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return NO;
}

static bool MOBoxedObject_deleteProperty(JSContextRef ctx, JSObjectRef objectJS, JSStringRef propertyNameJS, JSValueRef *exception) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(NULL, propertyNameJS));
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    id private = (__bridge id)(JSObjectGetPrivate(objectJS));
    id object = [private representedObject];
    
    // Perform the lookup
    @try {
        // Indexed subscript
        if ([object respondsToSelector:@selector(setObject:forIndexedSubscript:)]) {
            NSScanner *scanner = [NSScanner scannerWithString:propertyName];
            NSInteger integerValue;
            if ([scanner scanInteger:&integerValue]) {
                [object setObject:nil forIndexedSubscript:integerValue];
                return YES;
            }
        }
        
        // Keyed subscript
        if ([object respondsToSelector:@selector(objectForKeyedSubscript:)]) {
            [object setObject:nil forKeyedSubscript:propertyName];
            return YES;
        }
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return NO;
}

static void MOBoxedObject_getPropertyNames(JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames) {
    MOBox *privateObject = (__bridge MOBox *)(JSObjectGetPrivate(object));
    
    // If we have a dictionary, add keys from allKeys
    id o = [privateObject representedObject];
    
    if ([o isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = o;
        NSArray *keys = [dictionary allKeys];
        
        for (NSString *key in keys) {
            JSStringRef jsString = JSStringCreateWithUTF8CString([key UTF8String]);
            JSPropertyNameAccumulatorAddName(propertyNames, jsString);
            JSStringRelease(jsString);
        }
    }
}

static JSValueRef MOBoxedObject_convertToType(JSContextRef ctx, JSObjectRef object, JSType type, JSValueRef *exception) {
    return MOJSValueToType(ctx, object, type, exception);
}

static bool MOBoxedObject_hasInstance(JSContextRef ctx, JSObjectRef constructor, JSValueRef possibleInstance, JSValueRef *exception) {
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    MOBox *privateObject = (__bridge MOBox *)(JSObjectGetPrivate(constructor));
    id representedObject = [privateObject representedObject];
    
    if (!JSValueIsObject(ctx, possibleInstance)) {
        return false;
    }
    
    JSObjectRef instanceObj = JSValueToObject(ctx, possibleInstance, exception);
    if (instanceObj == nil) {
        return NO;
    }
    MOBox *instancePrivateObj = (__bridge MOBox *)(JSObjectGetPrivate(instanceObj));
    id instanceRepresentedObj = [instancePrivateObj representedObject];
    
    // Check to see if the object's class matches the passed-in class
    @try {
        if (representedObject == [instanceRepresentedObj class]) {
            return true;
        }
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != nil) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return false;
}


#pragma mark -
#pragma mark Mocha Constructors

static JSObjectRef MOConstructor_callAsConstructor(JSContextRef ctx, JSObjectRef object, size_t argumentsCount, const JSValueRef arguments[], JSValueRef *exception) {
    return NULL;
}


#pragma mark -
#pragma mark Mocha Functions

static JSValueRef MOFunction_callAsFunction(JSContextRef ctx, JSObjectRef functionJS, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception) {
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    MOBox *private = (__bridge MOBox *)(JSObjectGetPrivate(functionJS));
    id function = [private representedObject];
    JSValueRef value = NULL;
    
//    if ([function isKindOfClass:[MOMethod class]]) {
//    
//        MOMethod *method = function;
//        
//        if ([method target] == runtime && [function selector] == @selector(protect:)) {
//            
//        }
//    
//        target = [function target];
//        selector = [function selector];
//        Class klass = [target class];
//    }
    
    // Perform the invocation
    @try {
        value = MOFunctionInvoke(function, ctx, argumentCount, arguments, exception);
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != nil) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return value;
}


static JSValueRef MOJSPrototypeForOBJCInstance(JSContextRef ctx, id instance, NSString *name) {
    
    char *propName = nil;
    if ([instance isKindOfClass:[NSString class]]) {
        propName = "String";
    }
    else if ([instance isKindOfClass:[NSArray class]]) {
        propName = "Array";
    }
    
    if (!propName) {
        return NO;
    }
    
    JSValueRef exception = nil;
    JSStringRef jsPropertyName = JSStringCreateWithUTF8CString(propName);
    JSValueRef jsPropertyValue = JSObjectGetProperty(ctx, JSContextGetGlobalObject(ctx), jsPropertyName, &exception);
    JSStringRelease(jsPropertyName);
    
    jsPropertyName = JSStringCreateWithUTF8CString("prototype");
    jsPropertyValue = JSObjectGetProperty(ctx, JSValueToObject(ctx, jsPropertyValue, nil), jsPropertyName, &exception);
    JSStringRelease(jsPropertyName);
    
    jsPropertyName = JSStringCreateWithUTF8CString([name UTF8String]);
    jsPropertyValue = JSObjectGetProperty(ctx, JSValueToObject(ctx, jsPropertyValue, nil), jsPropertyName, &exception);
    JSStringRelease(jsPropertyName);
    
    if (jsPropertyValue && JSValueGetType(ctx, jsPropertyValue) == kJSTypeObject) {
        // OK, there's a JS String method with the same name as propertyName.  Let's use that.
        return jsPropertyValue;
    }
    
    return nil;
}
