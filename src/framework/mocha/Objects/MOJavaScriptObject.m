//
//  MOJavaScriptObject.m
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOJavaScriptObject.h"


@implementation MOJavaScriptObject {
    JSObjectRef _JSObject;
    JSContextRef _JSContext;
}

+ (MOJavaScriptObject *)objectWithJSObject:(JSObjectRef)jsObject context:(JSContextRef)ctx {
    MOJavaScriptObject *object = [[MOJavaScriptObject alloc] init];
    [object setJSObject:jsObject JSContext:ctx];
    return object;
}

- (void)dealloc {
    if (_JSObject != NULL) {
        JSValueUnprotect(_JSContext, _JSObject);
    }
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

@end
