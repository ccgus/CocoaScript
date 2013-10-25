//
//  TDTrack.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTrack.h"
#import "TDAssembly.h"
#import "TDTrackException.h"

@interface TDParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (TDAssembly *)best:(NSSet *)inAssemblies;
@end

@interface TDTrack ()
- (void)throwTrackExceptionWithPreviousState:(NSSet *)inAssemblies parser:(TDParser *)p;
@end

@implementation TDTrack

+ (id)track {
    return [[[self alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    BOOL inTrack = NO;
    NSSet *lastAssemblies = inAssemblies;
    NSSet *outAssemblies = inAssemblies;
    
    for (TDParser *p in subparsers) {
        outAssemblies = [p matchAndAssemble:outAssemblies];
        if (!outAssemblies.count) {
            if (inTrack) {
                [self throwTrackExceptionWithPreviousState:lastAssemblies parser:p];
            }
            break;
        }
        inTrack = YES;
        lastAssemblies = outAssemblies;
    }
    
    return outAssemblies;
}


- (void)throwTrackExceptionWithPreviousState:(NSSet *)inAssemblies parser:(TDParser *)p {
    TDAssembly *best = [self best:inAssemblies];

    NSString *after = [best consumedObjectsJoinedByString:@" "];
    if (!after.length) {
        after = @"-nothing-";
    }
    
    NSString *expected = [p description];

    id next = [best peek];
    NSString *found = next ? [next description] : @"-nothing-";
    
    NSString *reason = [NSString stringWithFormat:@"\n\nAfter : %@\nExpected : %@\nFound : %@\n\n", after, expected, found];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              after, @"after",
                              expected, @"expected",
                              found, @"found",
                              nil];
    [[TDTrackException exceptionWithName:TDTrackExceptionName reason:reason userInfo:userInfo] raise];
}

@end
