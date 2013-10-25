//
//  NSArray+MochaAdditions.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "NSArray+MochaAdditions.h"


@implementation NSArray (MochaAdditions)

- (id)mo_objectForIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}

@end


@implementation NSMutableArray (MochaAdditions)

- (void)mo_setObject:(id)obj forIndexedSubscript:(NSUInteger)idx {
    if ([self count] > idx && obj != nil) {
        [self replaceObjectAtIndex:idx withObject:obj];
    }
    else if ([self count] == idx && obj != nil) {
        [self addObject:obj];
    }
    else if (obj == nil) {
        [self removeObjectAtIndex:idx];
    }
}

@end
