//
//  COSTarget.m
//  Cocoa Script
//
//  Created by Abhi Beckert on 13/11/2013.
//
//

#import "COSTarget.h"
#import <objc/runtime.h>

@interface COSTarget ()

@property (weak) COScript *cosContext;
@end

@implementation COSTarget

+ (instancetype)targetWithJSFunction:(MOJavaScriptObject *)jsFunction {
    return [[[self class] alloc] initWithJSFunction:jsFunction];
}

- (instancetype)initWithJSFunction:(MOJavaScriptObject *)jsFunction {
	self = [super init];
	if (self != nil) {
		[self setJsFunction:jsFunction];
        
        [self setCosContext:[COScript currentCOScript]];
        
	}
    
    return self;
}

- (void)callAction:(id)sender {
    
    if (!_cosContext) {
        NSLog(@"%s:%d", __FUNCTION__, __LINE__);
        NSLog(@"_cosContext is nil when calling.  Did it dealloc or was it never set?");
    }
    
    #pragma message "FIXME: fixme"
    /*
    JSObjectRef actionRef = [[self jsFunction] JSObject];
    
    [_cosContext callJSFunction:actionRef withArgumentsInArray:@[sender]];
    */
}

- (SEL)action {
    return @selector(callAction:);
}

@end


@implementation NSObject (COSTargetAdditions)

- (void)setCOSJSTargetFunction:(MOJavaScriptObject *)jsFunction {
    
    if (!([self respondsToSelector:@selector(setTarget:)] && [self respondsToSelector:@selector(setAction:)])) {
        NSLog(@"Could not set the target and action on %@", self);
        return;
    }
    
    COSTarget *t = [COSTarget targetWithJSFunction:jsFunction];
    
    [(id)self setTarget:t];
    
    [(id)self setAction:[t action]];
    
    objc_setAssociatedObject(self, _cmd, t, OBJC_ASSOCIATION_RETAIN);
}

@end
