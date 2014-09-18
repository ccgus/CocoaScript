//
//  MOBlock.m
//  Mocha
//
//  Created by Logan Collins on 12/11/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import "MOBlock.h"

#import "MORuntime_Private.h"
#import "MOJavaScriptObject_Private.h"
#import "MOFunctionArgument.h"

#import <objc/runtime.h>


@implementation MOBlock {
    // MOBlock's ivars are laid out like NSBlock so it can be invoked. Yes, this is a very bad idea.
    int _flags;
    int _reserved;
    IMP _invoke;
    struct BlockDescriptor *_descriptor;
    
    MOJavaScriptObject *_javaScriptObject;
    NSString *_typeEncoding;
}

SEL __proxySelector = NULL;

+ (void)initialize {
    if (self == [MOBlock class]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        __proxySelector = @selector(thisDoesNotExistOrAtLeastItReallyShouldNot);
#pragma clang diagnostic pop
    }
}

+ (id)constructWithArguments:(NSArray *)arguments {
    if ([arguments count] != 2
        || ![arguments[0] isKindOfClass:[NSString class]]
        || ![arguments[1] isKindOfClass:[MOJavaScriptObject class]]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Block objects require two arguments: a type encoding and a function object" userInfo:nil];
    }
    return [[self alloc] initWithJavaScriptObject:arguments[1] typeEncoding:arguments[0]];
}

- (id)initWithJavaScriptObject:(MOJavaScriptObject *)object typeEncoding:(NSString *)typeEncoding {
    self = [super init];
    if (self) {
        _javaScriptObject = object;
        _typeEncoding = typeEncoding;
        
        // Override the block's IMP pointer with a selector that doesn't exist.
        // This causes the runtime to invoke the forwarding machinery.
        _invoke = [self methodForSelector:__proxySelector];
    }
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (signature == nil) {
        // Convert the block's type encoding to a method encoding, padding it out to at least 2 arguments
        // (which is required for the forwarding machinery to function properly)
        
        const char * typeEncoding = [_typeEncoding UTF8String];
        signature = [NSMethodSignature signatureWithObjCTypes:typeEncoding];
        while ([signature numberOfArguments] < 2) {
            typeEncoding = [[NSString stringWithFormat:@"%s%s", typeEncoding, @encode(void *)] UTF8String];
            signature = [NSMethodSignature signatureWithObjCTypes:typeEncoding];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    // Calls to the block's IMP pointer will fail, as we've overridden it with a selector that doesn't exist
    // This will forward the invocation to here, where we can use the static NSInvocation to convert the block
    // arguments to JSValues and then call the JS function.
    JSObjectRef jsFunction = [_javaScriptObject JSObject];
    JSContextRef ctx = [_javaScriptObject JSContext];
    MORuntime *runtime = [MORuntime runtimeWithContext:ctx];
    
    NSArray *functionArguments = [MOFunctionArgument argumentsFromTypeSignature:_typeEncoding];
    NSUInteger argumentCount = [functionArguments count] - 2; // return value + block object
    
    JSValueRef *jsArguments = (JSValueRef *)malloc(sizeof(JSValueRef) * argumentCount);
    
    // Convert the NSInvocation's arguments into JSValues
    for (NSUInteger i=2; i<[functionArguments count]; i++) {
        MOFunctionArgument *argument = functionArguments[i];
        
        [anInvocation getArgument:argument.storage atIndex:(i - 1)];
        
        JSValueRef value = [argument getValueAsJSValueInContext:ctx];
        jsArguments[i - 2] = value;
        
        NSLog(@"%d", JSValueGetType(ctx, value));
    }
    
    JSValueRef exception = NULL;
    JSValueRef jsReturnValue = JSObjectCallAsFunction(ctx, jsFunction, NULL, argumentCount, jsArguments, &exception);
    
    MOFunctionArgument *returnArgument = functionArguments[0];
    if ([returnArgument baseTypeEncoding] != _C_VOID) {
        [returnArgument setValueAsJSValue:jsReturnValue context:ctx];
        
        void ** returnStorage = [returnArgument storage];
        [anInvocation setReturnValue:returnStorage];
    }
    
    free(jsArguments);
        
    if (exception != NULL) {
        [runtime throwJSException:exception inContext:ctx];
    }
}

- (MOJavaScriptObject *)javaScriptObject {
    return _javaScriptObject;
}

@end
