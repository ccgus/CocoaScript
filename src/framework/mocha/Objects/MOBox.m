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

static NSUInteger initCount = 0;

- (id)initWithManager:(MOBoxManager *)manager object:(id)object jsObject:(JSObjectRef)jsObject {
    self = [super init];
    if (self) {
        NSAssert(manager != nil, @"valid manager");
        _manager = manager;
        _representedObject = object;
#if DEBUG_CRASHES
        _representedObjectCanaryDesc = [NSString stringWithFormat:@"box: %p\nobject: %p %@\njs object: %p\nboxed at: %@\n", self, object, object, jsObject, [NSDate date]];
        _count = initCount++;
#endif
        _JSObject = jsObject;
        JSObjectSetPrivate(jsObject, (__bridge void*)self);
        debug(@"set private for %p to %p (%@)", jsObject, self, [_representedObject className]);
    }
    
    return self;
}

- (void)disassociateObject {
#if DEBUG_CRASHES
    debug(@"dissassociated %p %ld", self, _count);
#else
    debug(@"dissassociated %p", self);
#endif
    if (_JSObject) {
        JSObjectSetPrivate(_JSObject, nil);
        debug(@"cleared private for %p", _JSObject);
        _JSObject = nil;
    }

    if (_manager) {
        _representedObject = nil;
        _manager = nil;
    } else {
#if DEBUG_CRASHES
        debug(@"shouldn't have been disassociated already %@", _representedObjectCanaryDesc);
#else
        debug(@"shouldn't have been disassociated already %@", _representedObject);
#endif
    }
}

- (void)dealloc {
#if DEBUG_CRASHES
    debug(@"dealloced %p %ld", self, _count);
#else
    debug(@"dealloced %p", self);
#endif
    if (_manager || _JSObject) {
#if DEBUG_CRASHES
        debug(@"box should have been disassociated for %@", _representedObjectCanaryDesc);
#else
        debug(@"box should have been disassociated for %@", _representedObject);
#endif
        [self disassociateObject];
    }
}

@end
