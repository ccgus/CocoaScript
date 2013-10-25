//
//  JSTRunnerApplication.m
//  jstalk
//
//  Created by August Mueller on 2/17/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import "JSTRunnerApplication.h"
#import "JSTalk.h"

@implementation JSTRunnerApplication


- (void) runScript {
    
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"jstalk"];
    
    if (!scriptPath) {
        NSBeep();
        NSLog(@"Could not find main.jstalk");
        return;
    }
    
    NSString *src = [NSString stringWithContentsOfFile:scriptPath
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
    
    
    if (!src) {
        NSBeep();
        NSLog(@"Could not load main.jstalk");
        return;
    }
    
    JSTalk *jstalk = [[JSTalk alloc] init];
    
    [jstalk executeString:src];
}

- (id) init {
	self = [super init];
	if (self != nil) {
        [self runScript];
        exit(0);
	}
	return self;
}


@end

