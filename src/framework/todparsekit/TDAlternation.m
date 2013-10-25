//
//  TDAlternation.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDAlternation.h"
#import "TDAssembly.h"

@interface TDParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
@end

@implementation TDAlternation

+ (id)alternation {
    return [[[self alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSMutableSet *outAssemblies = [NSMutableSet set];
    
    for (TDParser *p in subparsers) {
        [outAssemblies unionSet:[p matchAndAssemble:inAssemblies]];
    }
    
    return outAssemblies;
}

@end
