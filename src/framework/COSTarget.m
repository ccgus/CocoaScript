//
//  COSTarget.m
//  Cocoa Script
//
//  Created by Abhi Beckert on 13/11/2013.
//
//

#import "COSTarget.h"

@implementation COSTarget

+ (instancetype)targetWithJSFunction:(MOJavaScriptObject *)jsFunction {
    return [[[self class] alloc] initWithJSFunction:jsFunction];
}

- (instancetype)initWithJSFunction:(MOJavaScriptObject *)jsFunction {
	self = [super init];
	if (self != nil) {
		[self setJsFunction:jsFunction];
	}
    
    return self;
}

- (void)callAction:(id)sender {
    JSObjectRef actionRef = [[self jsFunction] JSObject];
    
    #pragma message "FIXME: we should stash a weak ref to the COScript at creation time, because who knows what other COScript might be around"
    
    COScript *script = [COScript currentCOScript];
    [script callJSFunction:actionRef withArgumentsInArray:@[sender]];
}

- (SEL)action {
    return @selector(callAction:);
}

@end


@implementation NSObject (COSTargetAdditions)

- (void)setCOSTarget:(COSTarget*)target {
    
    if (!([self respondsToSelector:@selector(setTarget:)] && [self respondsToSelector:@selector(setAction:)])) {
        NSLog(@"Could not set the target and action on %@", self);
        return;
    }
    
    [(id)self setTarget:target];
    [(id)self setAction:[target action]];
}

@end
