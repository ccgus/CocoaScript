//
//  COSFiber.m
//  Cocoa Script Editor
//
//  Created by Mathieu Dutour on 04/12/2017.
//

#import "COSFiber.h"
#import "COScript+Fiber.h"

@implementation COSFiber
+ (id)createWithCocoaScript:(COScript *)cos {
    
    COSFiber *fiber = [[[self class] alloc] init];
    
    [fiber setCoscript:cos];
    
    return fiber;
    
}

- (void)onCleanup:(MOJavaScriptObject *)jsFunction {
    _cleanUpJSfunc = jsFunction;
}

- (void)cleanup {
    if (_cleanUpJSfunc != nil) {
        [_coscript callJSFunction:[_cleanUpJSfunc JSObject] withArgumentsInArray:@[]];
    }
    
    [_coscript removeFiber:self];
    
    _cleanUpJSfunc = nil;
    _coscript = nil;
}

@end
