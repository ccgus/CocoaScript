//
//  MOPointer.m
//  Mocha
//
//  Created by Logan Collins on 7/31/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOPointer.h"


@implementation MOPointer

+ (id)constructWithArguments:(NSArray *)arguments {
    if ([arguments count] > 0) {
        return [[self alloc] initWithValue:[arguments objectAtIndex:0]];
    }
    else {
        return [[self alloc] init];
    }
}

- (id)initWithValue:(id)value {
    self = [super init];
    if (self) {
        self.value = value;
    }
    return self;
}

- (id)callWithArguments:(NSArray *)arguments {
    if ([arguments count] == 0) {
        self.value = arguments[0];
    }
    return self.value;
}

@end
