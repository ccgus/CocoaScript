//
//  MOPointer.m
//  Mocha
//
//  Created by Logan Collins on 7/31/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOPointer.h"
#import "MOPointer_Private.h"


@implementation MOPointer

@synthesize value=_value;

- (id)initWithValue:(id)value {
    self = [super init];
    if (self) {
        self.value = value;
    }
    return self;
}

@end
