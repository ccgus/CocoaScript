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

- (id)initWithManager:(MOBoxManager *)manager {
    self = [super init];
    if (self) {
        _manager = manager;
    }
    
    return self;
}

- (void)associateObject:(id)object jsObject:(JSObjectRef)jsObject {
    _representedObject = object;
    _JSObject = jsObject;
}

- (void)disassociateObjectInContext:(JSContextRef)context {
    _JSObject = nil;
    _representedObject = nil;
}

- (void)dealloc {
    NSAssert(_JSObject == nil, @"should have been disassociated");
}

@end
