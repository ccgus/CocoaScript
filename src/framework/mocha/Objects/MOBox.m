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

@end
