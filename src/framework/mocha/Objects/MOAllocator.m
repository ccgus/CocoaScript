//
//  MOAllocator.m
//  Mocha
//
//  Created by Logan Collins on 7/25/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOAllocator.h"


@implementation MOAllocator

@synthesize objectClass=_objectClass;

+ (MOAllocator *)allocator {
    return [[self alloc] init];
}

@end
