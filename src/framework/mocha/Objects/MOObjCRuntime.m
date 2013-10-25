//
//  MOObjCRuntime.m
//  Mocha
//
//  Created by Logan Collins on 5/16/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOObjCRuntime.h"

#import <objc/runtime.h>


@implementation MOObjCRuntime

+ (MOObjCRuntime *)sharedRuntime {
    static MOObjCRuntime * sharedRuntime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRuntime = [[self alloc] init];
    });
    return sharedRuntime;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark Accessors

- (NSArray *)classes {
    unsigned int count;
    Class *classList = objc_copyClassList(&count);
    NSMutableArray *classes = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i=0; i<count; i++) {
        Class klass = classList[i];
        const char *name = class_getName(klass);
        NSString *string = [NSString stringWithUTF8String:name];
        if (![string hasPrefix:@"_"]) {
            [classes addObject:string];
        }
    }
    free(classList);
    [classes sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return classes;
}

- (NSArray *)protocols {
    unsigned int count;
    Protocol *__unsafe_unretained *protocolList = objc_copyProtocolList(&count);
    NSMutableArray *protocols = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i=0; i<count; i++) {
        Protocol *protocol = protocolList[i];
        const char *name = protocol_getName(protocol);
        NSString *string = [NSString stringWithUTF8String:name];
        if (![string hasPrefix:@"_"]) {
            [protocols addObject:string];
        }
    }
    free(protocolList);
    [protocols sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return protocols;
}

@end
