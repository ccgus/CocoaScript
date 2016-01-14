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

- (id)initWithManager:(MOBoxManager *)manager object:(id)object {
    self = [super init];
    if (self) {
        _manager = manager;
        _representedObject = object;
        _representedObjectCanary = object;
        _representedObjectCanaryDesc = [object description];
    }
    
    return self;
}

- (void)associateObject:(JSObjectRef)jsObject {
    NSAssert(JSObjectGetPrivate(jsObject) == (__bridge void *)self, @"object should already be connected to this box");
    _JSObject = jsObject;
}

- (void)disassociateObject {
    JSObjectSetPrivate(_JSObject, nil);
    _JSObject = nil;
    _representedObject = nil;
}

- (void)dealloc {
    NSAssert((_JSObject == nil) && (_representedObject == nil), @"should have been disassociated");
}

@end
