//
//  NSDictionary+MochaAdditions.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "NSDictionary+MochaAdditions.h"


@implementation NSDictionary (MochaAdditions)

- (id)mo_objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

@end


@implementation NSMutableDictionary (MochaAdditions)

- (void)mo_setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    if (obj != nil) {
        [self setObject:obj forKey:key];
    }
    else {
        [self removeObjectForKey:key];
    }
}

@end
