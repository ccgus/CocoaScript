//
//  TDParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDParser.h"
#import "TDAssembly.h"

@interface TDParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (TDAssembly *)best:(NSSet *)inAssemblies;
@end

@implementation TDParser

+ (id)parser {
    return [[[self alloc] init] autorelease];
}


- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)dealloc {
    assembler = nil;
    self.selector = nil;
    self.name = nil;
    [super dealloc];
}


- (void)setAssembler:(id)a selector:(SEL)sel {
    self.assembler = a;
    self.selector = sel;
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSAssert1(0, @"-[TDParser %@] must be overriden", NSStringFromSelector(_cmd));
    return nil;
}


- (TDAssembly *)bestMatchFor:(TDAssembly *)a {
    NSParameterAssert(a);
    NSSet *initialState = [NSSet setWithObject:a];
    NSSet *finalState = [self matchAndAssemble:initialState];
    return [self best:finalState];
}


- (TDAssembly *)completeMatchFor:(TDAssembly *)a {
    NSParameterAssert(a);
    TDAssembly *best = [self bestMatchFor:a];
    if (best && ![best hasMore]) {
        return best;
    }
    return nil;
}


- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSSet *outAssemblies = [self allMatchesFor:inAssemblies];
    if (assembler) {
        NSAssert2([assembler respondsToSelector:selector], @"provided assembler %@ should respond to %@", assembler, NSStringFromSelector(selector));
        for (TDAssembly *a in outAssemblies) {
            [assembler performSelector:selector withObject:a];
        }
    }
    return outAssemblies;
}


- (TDAssembly *)best:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    TDAssembly *best = nil;
    
    for (TDAssembly *a in inAssemblies) {
        if (![a hasMore]) {
            best = a;
            break;
        }
        if (!best || a.objectsConsumed > best.objectsConsumed) {
            best = a;
        }
    }
    
    return best;
}


- (NSString *)description {
    NSString *className = [[self className] substringFromIndex:2];
    if (name.length) {
        return [NSString stringWithFormat:@"%@ (%@)", className, name];
    } else {
        return [NSString stringWithFormat:@"%@", className];
    }
}

@synthesize assembler;
@synthesize selector;
@synthesize name;
@end
