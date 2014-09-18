//
//  MOWeak.m
//  Mocha
//
//  Created by Logan Collins on 12/10/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import "MOWeak.h"


@implementation MOWeak {
    __weak id _value;
}

+ (id)constructWithArguments:(NSArray *)arguments {
    if ([arguments count] == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Weak references require one argument" userInfo:nil];
    }
    return [[self alloc] initWithValue:[arguments objectAtIndex:0]];
}

- (id)initWithValue:(id)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (id)callWithArguments:(NSArray *)arguments {
    return _value;
}

@end
