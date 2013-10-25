//
//  TDRepetition.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDRepetition.h"
#import "TDAssembly.h"

@interface TDParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
@end

@interface TDRepetition ()
@property (nonatomic, readwrite, retain) TDParser *subparser;
@end

@implementation TDRepetition

+ (id)repetitionWithSubparser:(TDParser *)p {
    return [[[self alloc] initWithSubparser:p] autorelease];
}


- (id)init {
    return [self initWithSubparser:nil];
}


- (id)initWithSubparser:(TDParser *)p {
    //NSParameterAssert(p);
    self = [super init];
    if (self) {
        self.subparser = p;
    }
    return self;
}


- (void)dealloc {
    self.subparser = nil;
    self.preassembler = nil;
    self.preassemblerSelector = nil;
    [super dealloc];
}


- (void)setPreassembler:(id)a selector:(SEL)sel {
    self.preassembler = a;
    self.preassemblerSelector = sel;
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    if (preassembler) {
        NSAssert2([preassembler respondsToSelector:preassemblerSelector], @"provided preassembler %@ should respond to %@", preassembler, NSStringFromSelector(preassemblerSelector));
        for (TDAssembly *a in inAssemblies) {
            [preassembler performSelector:preassemblerSelector withObject:a];
        }
    }
    
    //NSMutableSet *outAssemblies = [[[NSSet alloc] initWithSet:inAssemblies copyItems:YES] autorelease];
    NSMutableSet *outAssemblies = [[inAssemblies mutableCopy] autorelease];
    
    NSSet *s = inAssemblies;
    while (s.count) {
        s = [subparser matchAndAssemble:s];
        [outAssemblies unionSet:s];
    }
    
    return outAssemblies;
}

@synthesize subparser;
@synthesize preassembler;
@synthesize preassemblerSelector;
@end
