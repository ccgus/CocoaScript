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
        _representedObjectCanaryDesc = [NSString stringWithFormat:@"%@ %@", [NSDate date], object];
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
        debug(@"box should have been disassociated for %@", _representedObjectCanaryDesc);
        [self disassociateObject];
    }
}

@end
