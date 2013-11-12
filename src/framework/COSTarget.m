//
//  COSTarget.m
//  Cocoa Script
//
//  Created by Abhi Beckert on 13/11/2013.
//
//

#import "COSTarget.h"

@implementation COSTarget

+ (instancetype)targetWithAction:(MOJavaScriptObject *)action
{
    return [[[self class] alloc] initWithAction:action];
}

- (instancetype)initWithAction:(MOJavaScriptObject *)action
{
    if (!(self = [super init]))
        return nil;
    
    self.action = action;
    
    return self;
}

- (void)callAction:(id)sender
{
    JSObjectRef actionRef = [self.action JSObject];
    
    COScript *script = [COScript currentCOScript];
    [script callJSFunction:actionRef withArgumentsInArray:@[sender]];
}

@end
