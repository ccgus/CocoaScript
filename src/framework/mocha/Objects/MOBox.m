//
//  MOBox.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOBox.h"


@implementation MOBox

@synthesize JSObject=_JSObject;
@synthesize runtime=_runtime;
@synthesize representedObject=_representedObject;

- (void)dealloc {
    //debug(@"MOBox dealloc releasing: '%@'", _representedObjectCanaryDesc);
}

- (void)setRepresentedObject:(id)representedObject {
    
    
    //debug(@"%p set %p (%@)", self, representedObject, [representedObject isKindOfClass:[NSData class]] ? @"BIG BIT O' DATA" : representedObject);
    
    _representedObject = representedObject;
    _representedObjectCanary = representedObject;
    _representedObjectCanaryDesc = [representedObject description];
    
    if ([representedObject isKindOfClass:[NSData class]]) {
        //debug(@"DATAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        _representedObjectCanaryDesc = [NSString stringWithFormat:@"NSData object (%p)", representedObject];
    }
    
}

- (id)representedObject {
    return _representedObject;
}


@end
