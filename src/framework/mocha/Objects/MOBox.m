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

@synthesize representedObject=_representedObject;
@synthesize JSObject=_JSObject;
@synthesize runtime=_runtime;

- (id)initWithRuntime:(Mocha *)runtime {
    self = [super init];
    if (self) {
        _runtime = runtime;
    }
    
    return self;
}

- (void)associateObject:(id)object jsObject:(JSObjectRef)jsObject context:(JSContextRef)context {
    _representedObject = object;
    _JSObject = jsObject;
    JSValueProtect(context, jsObject); // TODO: this is a temporary hack. It will fix the script crash, but only at the expense of leaking all JS objects during a script run. Which is not good...
}

- (void)disassociateObjectInContext:(JSContextRef)context {
//    NSLog(@"disassociated box %p for %p js:%p", self, self.representedObject, self.JSObject);
//    JSValueUnprotect(context, self.JSObject); // TODO: also a hack
    _JSObject = nil;
}

- (void)dealloc {
    NSAssert(_JSObject == nil, @"should have been disassociated");
}

@end
