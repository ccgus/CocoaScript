//
//  TDEmpty.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDEmpty.h"

@implementation TDEmpty

+ (id)empty {
    return [[[self alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    //return [[[NSSet alloc] initWithSet:inAssemblies copyItems:YES] autorelease];
    return inAssemblies;
}

@end
