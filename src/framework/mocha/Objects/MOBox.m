//
//  MOBox.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOBox.h"
#import "MOMethod.h"
#import "MOBridgeSupportSymbol.h"
#import "MOFunctionArgument.h"
#import "MOClosure.h"

@implementation MOBox

- (id)initWithManager:(MOBoxManager *)manager object:(id)object jsObject:(JSObjectRef)jsObject {
    self = [super init];
    if (self) {
        _manager = manager;
        _representedObject = object;
#if DEBUG_CRASHES
        _representedObjectCanaryDesc = [NSString stringWithFormat:@"%@ %@", [NSDate date], object];
#endif
        _JSObject = jsObject;
        JSObjectSetPrivate(jsObject, (__bridge void*)self);
    }
    
    return self;
}

- (void)disassociateObject {
    NSAssert(_manager != nil, @"shouldn't have been disassociated already");
    JSObjectSetPrivate(_JSObject, nil);
    _representedObject = nil;
    _manager = nil;
}

- (void)dealloc {
    if (_manager) {
#if DEBUG_CRASHES
        debug(@"box should have been disassociated for %@", _representedObjectCanaryDesc);
#else
        debug(@"box should have been disassociated for %@", _representedObject);
#endif
        [self disassociateObject];
    }
}

@end
