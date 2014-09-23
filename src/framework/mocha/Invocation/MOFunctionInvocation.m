//
//  MOFunctionInvocation.m
//  Mocha
//
//  Created by Logan Collins on 12/9/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import "MOFunctionInvocation.h"

#import "MORuntime_Private.h"

#import "MOMethod.h"
#import "MOAllocator.h"
#import "MOPointer.h"
#import "MOBlock.h"
#import "MOPointerValue.h"
#import "MOJavaScriptObject.h"

#import "MOBridgeSupportController.h"
#import "MOBridgeSupportSymbol.h"

#import "MOFunctionArgument.h"

#import <objc/runtime.h>
#import <objc/message.h>
#import <dlfcn.h>

#if TARGET_OS_IPHONE
#import "ffi.h"
#else
#import <ffi/ffi.h>
#endif


void * MOGetObjCCallAddressForArguments(NSArray *arguments);
const char * MOBlockGetTypeEncoding(id blockObj);
void * MOBlockGetCallAddress(id blockObj, const char ** typeEncoding);


JSValueRef MOFunctionInvoke(id function, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception) {
    MORuntime *runtime = [MORuntime runtimeWithContext:ctx];
    
    // Determine the metadata for the function call
    JSValueRef value = NULL;
    BOOL objCCall = NO;
    BOOL blockCall = NO;
    NSMutableArray *argumentEncodings = nil;
    MOFunctionArgument *returnValue = nil;
    void * callAddress = NULL;
    NSUInteger callAddressArgumentCount = 0;
    BOOL variadic = NO;
    
    id target = nil;
    SEL selector = NULL;
    
    id block = nil;
    
    if ([function isKindOfClass:[MOMethod class]]) {
        // Objective-C method
        objCCall = YES;
        
        target = [function target];
        selector = [function selector];
        Class klass = [target class];
        
#if !TARGET_OS_IPHONE
        // Override for Distributed Objects
        if ([klass isSubclassOfClass:[NSDistantObject class]]
            || [klass isSubclassOfClass:[NSProtocolChecker class]]) {
            return MOSelectorInvoke(target, selector, ctx, argumentCount, arguments, exception);
        }
#endif
        
        // Override for -alloc...
        if (selector == @selector(alloc)
            || selector == @selector(allocWithZone:)) {
            // Override for -alloc
            MOAllocator *allocator = [[MOAllocator alloc] init];
            allocator.objectClass = klass;
            return [runtime JSValueForObject:allocator inContext:ctx];
        }
        
        // Override for -release and -autorelease
        if ((selector == @selector(release) || selector == @selector(autorelease))
                 && runtime.options & MORuntimeOptionAutomaticReferenceCounting) {
            // ARC-mode disallows explicit release of objects
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Automatic reference counting disallows explicit calls to -%@.", NSStringFromSelector(selector)] userInfo:nil];
            *exception = [runtime JSValueForObject:e inContext:ctx];
            return NULL;
        }
        
        if ([target isKindOfClass:[MOAllocator class]]) {
            klass = [target objectClass];
            target = [[target objectClass] alloc];
        }
        
        Method method = NULL;
        BOOL classMethod = (target == klass);
        
        // Determine the method type
        if (classMethod) {
            method = class_getClassMethod(klass, selector);
        }
        else {
            method = class_getInstanceMethod(klass, selector);
        }
        
        variadic = [function isVariadic];
        
        if (method == NULL) {
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to locate method %@ of class %@", NSStringFromSelector(selector), klass] userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e inContext:ctx];
            }
            return NULL;
        }
        
        const char *encoding = method_getTypeEncoding(method);
        argumentEncodings = [[MOFunctionArgument argumentsFromTypeSignature:[NSString stringWithCString:encoding encoding:NSUTF8StringEncoding]] mutableCopy];
        
        if (argumentEncodings == nil) {
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to parse method encoding for method %@ of class %@", NSStringFromSelector(selector), klass] userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e inContext:ctx];
            }
            return NULL;
        }
        
        // Function arguments are all arguments minus return value and [instance, selector] params to objc_send
        callAddressArgumentCount = [argumentEncodings count] - 3;
        
        // Get call address
        callAddress = MOGetObjCCallAddressForArguments(argumentEncodings);
        
        if (variadic) {
            if (argumentCount > 0) {
                // Add an argument for NULL
                argumentCount++;
            }
        }
        
        if ((variadic && (callAddressArgumentCount > argumentCount))
            || (!variadic && (callAddressArgumentCount != argumentCount)))
        {
            NSString *reason = [NSString stringWithFormat:@"Objective-C method %@ requires %lu %@, but JavaScript passed %zd %@", NSStringFromSelector(selector), (unsigned long)callAddressArgumentCount, (callAddressArgumentCount == 1 ? @"argument" : @"arguments"), argumentCount, (argumentCount == 1 ? @"argument" : @"arguments")];
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:reason userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e inContext:ctx];
            }
            return NULL;
        }
    }
    else if ([function isKindOfClass:NSClassFromString(@"NSBlock")]
             || [function isKindOfClass:[MOBlock class]]) {
        // Block object
        blockCall = YES;
        
        block = function;
        
        const char * typeEncoding = NULL;
        callAddress = MOBlockGetCallAddress(block, &typeEncoding);
        
        argumentEncodings = [[MOFunctionArgument argumentsFromTypeSignature:[NSString stringWithCString:typeEncoding encoding:NSUTF8StringEncoding]] mutableCopy];
        
        if (argumentEncodings == nil) {
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to parse method encoding for method %@ of class %@", NSStringFromSelector(selector), [target class]] userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e inContext:ctx];
            }
            return NULL;
        }
        
        callAddressArgumentCount = [argumentEncodings count] - 2;
        
        if (callAddressArgumentCount != argumentCount) {
            NSString *reason = [NSString stringWithFormat:@"Block requires %lu %@, but JavaScript passed %zd %@", (unsigned long)callAddressArgumentCount, (callAddressArgumentCount == 1 ? @"argument" : @"arguments"), argumentCount, (argumentCount == 1 ? @"argument" : @"arguments")];
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:reason userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e inContext:ctx];
            }
            return NULL;
        }
    }
    else if ([function isKindOfClass:[MOBridgeSupportFunction class]]) {
        // BridgeSupport function
        
        NSString *functionName = [function name];
        
        callAddress = dlsym(RTLD_DEFAULT, [functionName UTF8String]);
        
        // If the function cannot be found, raise an exception (instead of crashing)
        if (callAddress == NULL) {
            if (exception != NULL) {
                NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to find function with name: %@", functionName] userInfo:nil];
                *exception = [runtime JSValueForObject:e inContext:ctx];
            }
            return NULL;
        }
        
        variadic = [function isVariadic];
        
        NSMutableArray *args = [NSMutableArray array];
        
        // Build return type
        MOBridgeSupportArgument *bridgeSupportReturnValue = [function returnValue];
        MOFunctionArgument *returnArg = nil;
        if (bridgeSupportReturnValue != nil) {
            NSString *returnTypeEncoding = nil;
#if __LP64__
            returnTypeEncoding = [bridgeSupportReturnValue type64];
            if (returnTypeEncoding == nil) {
                returnTypeEncoding = [bridgeSupportReturnValue type];
            }
#else
            returnTypeEncoding = [bridgeSupportReturnValue type];
#endif
            
            returnArg = [[MOFunctionArgument alloc] initWithTypeEncoding:returnTypeEncoding];
        }
        else {
            // void return
            returnArg = [[MOFunctionArgument alloc] initWithBaseTypeEncoding:_C_VOID];
        }
        [returnArg setReturnValue:YES];
        [args addObject:returnArg];
        
        // Build arguments
        for (MOBridgeSupportArgument *argument in [function arguments]) {
            NSString *typeEncoding = nil;
#if __LP64__
            typeEncoding = [argument type64];
            if (typeEncoding == nil) {
                typeEncoding = [argument type];
            }
#else
            typeEncoding = [argument type];
#endif
            
            MOFunctionArgument *arg = [[MOFunctionArgument alloc] initWithTypeEncoding:typeEncoding];
            [args addObject:arg];
        }
        
        argumentEncodings = [args mutableCopy];
        
        // Function arguments are all arguments minus return value
        callAddressArgumentCount = [args count] - 1;
        
        // Raise if the argument counts don't match
        if ((variadic && (callAddressArgumentCount > argumentCount))
            || (!variadic && (callAddressArgumentCount != argumentCount)))
        {
            NSString *reason = [NSString stringWithFormat:@"C function %@ requires %lu %@, but JavaScript passed %zd %@", functionName, (unsigned long)callAddressArgumentCount, (callAddressArgumentCount == 1 ? @"argument" : @"arguments"), argumentCount, (argumentCount == 1 ? @"argument" : @"arguments")];
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:reason userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e inContext:ctx];
            }
            return NULL;
        }
    }
    else {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Invalid object for function invocation: %@", function] userInfo:nil];
    }
    
    
    // Prepare ffi
    ffi_cif cif;
    ffi_type ** args = NULL;
    void ** values = NULL;
    
    // Build the arguments
    NSUInteger effectiveArgumentCount = argumentCount;
    if (objCCall) {
        effectiveArgumentCount += 2;
    }
    if (blockCall) {
        effectiveArgumentCount += 1;
    }
    
    if (effectiveArgumentCount > 0) {
        args = malloc(sizeof(ffi_type *) * effectiveArgumentCount);
        values = malloc(sizeof(void *) * effectiveArgumentCount);
        
        NSUInteger j = 0;
        
        if (objCCall) {
            // ObjC calls include the target and selector as the first two arguments
            args[0] = &ffi_type_pointer;
            args[1] = &ffi_type_pointer;
            values[0] = (void *)&target;
            values[1] = (void *)&selector;
            j = 2;
        }
        else if (blockCall) {
            // Block calls include the block as the first argument
            args[0] = &ffi_type_pointer;
            values[0] = (void *)&block;
            j = 1;
        }
        
        for (NSUInteger i=0; i<argumentCount; i++, j++) {
            JSValueRef jsValue = NULL;
            
            MOFunctionArgument *arg = nil;
            if (variadic && i >= callAddressArgumentCount) {
                arg = [[MOFunctionArgument alloc] initWithBaseTypeEncoding:_C_ID];
                [argumentEncodings addObject:arg];
            }
            else {
                arg = [argumentEncodings objectAtIndex:(j + 1)];
            }
            
            if (objCCall && variadic && i == argumentCount - 1) {
                // The last variadic argument in ObjC calls is nil (the sentinel value)
                jsValue = NULL;
            }
            else {
                jsValue = arguments[i];
            }
            
            if (jsValue != NULL) {
                id object = [runtime objectForJSValue:jsValue inContext:ctx];
                
                if ([object isKindOfClass:[MOPointer class]]) {
                    // Pointers
                    [arg setPointer:object];
                    
                    id objValue = [(MOPointer *)object value];
                    JSValueRef pointerJSValue = [runtime JSValueForObject:objValue inContext:ctx];
                    [arg setValueAsJSValue:pointerJSValue context:ctx dereference:YES];
                }
                else {
                    // Otherwise
                    [arg setValueAsJSValue:jsValue context:ctx];
                }
            }
            else {
                [arg setValueAsJSValue:NULL context:ctx];
            }
            
            args[j] = [arg ffiType];
            values[j] = [arg storage];
        }
    }
    
    // Get return value holder
    returnValue = [argumentEncodings objectAtIndex:0];
    
    // Prep
    ffi_status prep_status = ffi_prep_cif(&cif, FFI_DEFAULT_ABI, (unsigned int)effectiveArgumentCount, [returnValue ffiType], args);
    
    // Call
    if (prep_status == FFI_OK) {
        void *storage = [returnValue storage];
        
        @try {
            ffi_call(&cif, callAddress, storage, values);
        }
        @catch (NSException *e) {
            if (effectiveArgumentCount > 0) {
                free(args);
                free(values);
            }
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e inContext:ctx];
            }
            
            NSLog(@"Exception calling target '%@' function %@", target, function);
            
            
            return NULL;
        }
    }
    
    // Free the arguments
    if (effectiveArgumentCount > 0) {
        free(args);
        free(values);
    }
    
    // Throw an exception if the prep call failed
    if (prep_status != FFI_OK) {
        NSException *e = [NSException exceptionWithName:MORuntimeException reason:@"ffi_prep_cif failed" userInfo:nil];
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e inContext:ctx];
        }
        return NULL;
    }
    
    // Populate the value of pointers
    for (MOFunctionArgument *arg in argumentEncodings) {
        MOPointer *pointer = [arg pointer];
        if (pointer != nil) {
            JSValueRef pointerJSValue = [arg getValueAsJSValueInContext:ctx dereference:YES];
            id pointerValue = [runtime objectForJSValue:pointerJSValue inContext:ctx];
            pointer.value = pointerValue;
        }
    }
    
    // If the return type is void, the return value should be undefined
    if ([returnValue ffiType] == &ffi_type_void) {
        return JSValueMakeUndefined(ctx);
    }
    
    @try {
        value = [returnValue getValueAsJSValueInContext:ctx];
        
        if ([returnValue baseTypeEncoding] == _C_CLASS
            || [returnValue baseTypeEncoding] == _C_ID) {
            
            if (runtime.options & MORuntimeOptionAutomaticReferenceCounting) {
                // If the return value is an object, apply ARC-style retain semantics
                id object = [runtime objectForJSValue:value inContext:ctx];
                
                BOOL shouldRelease = NO;
                if ([function isKindOfClass:[MOMethod class]]) {
                    shouldRelease = [(MOMethod *)function returnsRetained];
                }
                else if ([function isKindOfClass:[MOBridgeSupportFunction class]]) {
                    shouldRelease = [[(MOBridgeSupportFunction *)function returnValue] isAlreadyRetained];
                }
                
                if (shouldRelease) {
                    [object release];
                }
            }
        }
    }
    @catch (NSException *e) {
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e inContext:ctx];
        }
        return NULL;
    }
    
    return value;
}

JSValueRef MOSelectorInvoke(id target, SEL selector, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception) {
    MORuntime *runtime = [MORuntime runtimeWithContext:ctx];
    
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    
    NSUInteger methodArgumentCount = [methodSignature numberOfArguments] - 2;
    if (methodArgumentCount != argumentCount) {
        NSString *reason = [NSString stringWithFormat:@"ObjC method %@ requires %lu %@, but JavaScript passed %zd %@", NSStringFromSelector(selector), (unsigned long)methodArgumentCount, (methodArgumentCount == 1 ? @"argument" : @"arguments"), argumentCount, (argumentCount == 1 ? @"argument" : @"arguments")];
        NSException *e = [NSException exceptionWithName:MORuntimeException reason:reason userInfo:nil];
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e inContext:ctx];
        }
        return NULL;
    }
    
    // Build arguments
    for (size_t i=0; i<argumentCount; i++) {
        JSValueRef argument = arguments[i];
        __unsafe_unretained id object = [runtime objectForJSValue:argument inContext:ctx];
        
        NSUInteger argIndex = i + 2;
        const char * argType = [methodSignature getArgumentTypeAtIndex:argIndex];
        
        // NSNumber
        if ([object isKindOfClass:[NSNumber class]]) {
            // long
            if (strcmp(argType, @encode(long)) == 0
                || strcmp(argType, @encode(unsigned long)) == 0) {
                long val = [object longValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // short
            else if (strcmp(argType, @encode(short)) == 0
                     || strcmp(argType, @encode(unsigned short)) == 0) {
                short val = [object shortValue];
                [invocation setArgument:&val atIndex:argIndex];
                
            }
            // char
            else if (strcmp(argType, @encode(char)) == 0
                     || strcmp(argType, @encode(unsigned char)) == 0) {
                char val = [object charValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // long long
            else if (strcmp(argType, @encode(long long)) == 0
                     || strcmp(argType, @encode(unsigned long long)) == 0) {
                long long val = [object longLongValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // float
            else if (strcmp(argType, @encode(float)) == 0) {
                float val = [object floatValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // double
            else if (strcmp(argType, @encode(double)) == 0) {
                double val = [object doubleValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // BOOL
            else if (strcmp(argType, @encode(bool)) == 0
                     || strcmp(argType, @encode(_Bool)) == 0) {
                BOOL val = [object boolValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // int
            else {
                int val = [object intValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
        }
        // id
        else {
            [invocation setArgument:&object atIndex:argIndex];
        }
    }
    
    
    // Invoke
    [invocation invoke];
    
    
    // Build return value
    const char * returnType = [methodSignature methodReturnType];
    JSValueRef returnValue = NULL;
    
    if (strcmp(returnType, @encode(void)) == 0) {
        returnValue = JSValueMakeUndefined(ctx);
    }
    // id
    else if (strcmp(returnType, @encode(id)) == 0
             || strcmp(returnType, @encode(Class)) == 0) {
        __unsafe_unretained id object = nil;
        [invocation getReturnValue:&object];
        returnValue = [runtime JSValueForObject:object inContext:ctx];
    }
    // SEL
    /*else if (strcmp(returnType, @encode(SEL)) == 0) {
     SEL selector = NULL;
     [invocation getReturnValue:&selector];
     
     returnValue = object;
     }*/
    // void *
    else if (strcmp(returnType, @encode(void *)) == 0) {
        void *pointer = NULL;
        [invocation getReturnValue:&pointer];
        
        MOPointerValue * __autoreleasing object = [[MOPointerValue alloc] initWithPointerValue:pointer typeEncoding:nil];
        returnValue = (__bridge void *)object;
    }
    // bool
    else if (strcmp(returnType, @encode(bool)) == 0
             || strcmp(returnType, @encode(_Bool)) == 0) {
        BOOL value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithBool:value] inContext:ctx];
    }
    // int
    else if (strcmp(returnType, @encode(int)) == 0
             || strcmp(returnType, @encode(unsigned int)) == 0) {
        int value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithInt:value] inContext:ctx];
    }
    // long
    else if (strcmp(returnType, @encode(long)) == 0
             || strcmp(returnType, @encode(unsigned long)) == 0) {
        long value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithLong:value] inContext:ctx];
    }
    // long long
    else if (strcmp(returnType, @encode(long long)) == 0
             || strcmp(returnType, @encode(unsigned long long)) == 0) {
        long long value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithLongLong:value] inContext:ctx];
    }
    // short
    else if (strcmp(returnType, @encode(short)) == 0
             || strcmp(returnType, @encode(unsigned short)) == 0) {
        short value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithShort:value] inContext:ctx];
    }
    // char
    else if (strcmp(returnType, @encode(char)) == 0
             || strcmp(returnType, @encode(unsigned char)) == 0) {
        char value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithChar:value] inContext:ctx];
    }
    // float
    else if (strcmp(returnType, @encode(float)) == 0) {
        float value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithFloat:value] inContext:ctx];
    }
    // double
    else if (strcmp(returnType, @encode(double)) == 0) {
        double value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithDouble:value] inContext:ctx];
    }
    
    return returnValue;
}


//
// From PyObjC : when to call objc_msgSend_stret, for structure return
// Depending on structure size & architecture, structures are returned as function first argument (done transparently by ffi) or via registers
//

#if defined(__ppc__)
#   define SMALL_STRUCT_LIMIT    4
#elif defined(__ppc64__)
#   define SMALL_STRUCT_LIMIT    8
#elif defined(__i386__)
#   define SMALL_STRUCT_LIMIT     8
#elif defined(__x86_64__)
#   define SMALL_STRUCT_LIMIT    16
#elif TARGET_OS_IPHONE
// TOCHECK
#   define SMALL_STRUCT_LIMIT    4
#else
#   error "Unsupported MACOSX platform"
#endif

void * MOGetObjCCallAddressForArguments(NSArray *arguments) {
    BOOL usingStret = NO;
    
    size_t resultSize = 0;
    MOFunctionArgument *firstArgument = (MOFunctionArgument *)[arguments objectAtIndex:0];
    char returnEncoding = [firstArgument baseTypeEncoding];
    if (returnEncoding == _C_STRUCT_B) {
        resultSize = [firstArgument size];
    }
    
    if (returnEncoding == _C_STRUCT_B &&
        //#ifdef  __ppc64__
        //            ffi64_stret_needs_ptr(signature_to_ffi_return_type(rettype), NULL, NULL)
        //
        //#else /* !__ppc64__ */
        (resultSize > SMALL_STRUCT_LIMIT
#ifdef __i386__
         /* darwin/x86 ABI is slightly odd ;-) */
         || (resultSize != 1
             && resultSize != 2
             && resultSize != 4
             && resultSize != 8)
#endif
#ifdef __x86_64__
         /* darwin/x86-64 ABI is slightly odd ;-) */
         || (resultSize != 1
             && resultSize != 2
             && resultSize != 4
             && resultSize != 8
             && resultSize != 16
             )
#endif
         )
        //#endif /* !__ppc64__ */
        ) {
        //                    callAddress = objc_msgSend_stret;
        //                    usingStret = YES;
        usingStret = YES;
    }
    
    void *callAddress = NULL;
    if (usingStret)    {
        callAddress = objc_msgSend_stret;
    }
    else {
        callAddress = objc_msgSend;
    }
    
#if __i386__
    // If i386 and the return type is float/double, use objc_msgSend_fpret
    // ARM and x86_64 use the standard objc_msgSend
    char returnEncoding = [[arguments objectAtIndex:0] typeEncoding];
    if (returnEncoding == 'f' || returnEncoding == 'd') {
        callAddress = objc_msgSend_fpret;
    }
#endif
    
    return callAddress;
}


//
// The following two structs are taken from clang's source.
//

struct Block_descriptor {
    unsigned long reserved;
    unsigned long size;
    void *rest[1];
};

struct Block_literal {
    void *isa;
    int flags;
    int reserved;
    void *invoke;
    struct Block_descriptor *descriptor;
};

const char * MOBlockGetTypeEncoding(id blockObj) {
    if ([blockObj isKindOfClass:[MOBlock class]]) {
        return [[(MOBlock *)blockObj typeEncoding] UTF8String];
    }
    else {
        struct Block_literal *block = (__bridge struct Block_literal *)blockObj;
        struct Block_descriptor *descriptor = block->descriptor;
        
        int copyDisposeFlag = 1 << 25;
        int signatureFlag = 1 << 30;
        
        assert(block->flags & signatureFlag);
        
        int index = 0;
        if (block->flags & copyDisposeFlag) {
            index += 2;
        }
        
        return descriptor->rest[index];
    }
}

void * MOBlockGetCallAddress(id blockObj, const char ** typeEncoding) {
    struct Block_literal *block = (__bridge struct Block_literal *)blockObj;
    if (typeEncoding != nil) {
        *typeEncoding = MOBlockGetTypeEncoding(blockObj);
    }
    return block->invoke;
}
