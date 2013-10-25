//
//  TDTerminal.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTerminal.h"
#import "TDAssembly.h"
#import "TDToken.h"

@interface TDTerminal ()
- (TDAssembly *)matchOneAssembly:(TDAssembly *)inAssembly;
- (BOOL)qualifies:(id)obj;

@property (nonatomic, readwrite, copy) NSString *string;
@end

@implementation TDTerminal

- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    self = [super init];
    if (self) {
        self.string = s;
    }
    return self;
}


- (void)dealloc {
    self.string = nil;
    [super dealloc];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSMutableSet *outAssemblies = [NSMutableSet set];
    
    for (TDAssembly *a in inAssemblies) {
        TDAssembly *b = [self matchOneAssembly:a];
        if (b) {
            [outAssemblies addObject:b];
        }
    }
    
    return outAssemblies;
}


- (TDAssembly *)matchOneAssembly:(TDAssembly *)inAssembly {
    NSParameterAssert(inAssembly);
    if (![inAssembly hasMore]) {
        return nil;
    }
    
    TDAssembly *outAssembly = nil;
    
    if ([self qualifies:[inAssembly peek]]) {
        outAssembly = [[inAssembly copy] autorelease];
        id obj = [outAssembly next];
        if (!discardFlag) {
            [outAssembly push:obj];
        }
    }
    
    return outAssembly;
}


- (BOOL)qualifies:(id)obj {
    NSAssert1(0, @"-[TDTerminal %@] must be overriden", NSStringFromSelector(_cmd));
    return NO;
}


- (TDTerminal *)discard {
    discardFlag = YES;
    return self;
}

@synthesize string;
@end
