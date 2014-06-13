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
        debug(@"%s:%d Unprotecting %p %p", __FUNCTION__, __LINE__, _JSObject, _JSContext);
        JSValueUnprotect(_JSContext, _JSObject);
    }
    
    if (_JSContext != NULL) {
        JSGlobalContextRelease((JSGlobalContextRef)_JSContext);
    }
    
}

- (JSObjectRef)JSObject {
    return _JSObject;
}

- (void)setJSObject:(JSObjectRef)JSObject JSContext:(JSContextRef)JSContext {
    if (_JSObject != NULL) {
        debug(@"%s:%d Unprotecting %p (s)", __FUNCTION__, __LINE__, _JSObject);
        JSValueUnprotect(_JSContext, _JSObject);
    }
    
    _JSObject = JSObject;
    _JSContext = JSGlobalContextRetain((JSGlobalContextRef)JSContext);
    if (_JSObject != NULL) {
        debug(@"%s:%d Protecting %p %p (s)", __FUNCTION__, __LINE__, _JSObject, _JSContext);
        JSValueProtect(_JSContext, _JSObject);
    }
}

@end
