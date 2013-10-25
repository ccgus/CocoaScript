//
//  TDCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDCommentState.h"
#import "TDToken.h"
#import "TDReader.h"
#import "TDSymbolRootNode.h"
#import "TDSingleLineCommentState.h"
#import "TDMultiLineCommentState.h"

@interface TDCommentState ()
@property (nonatomic, retain) TDSymbolRootNode *rootNode;
@property (nonatomic, retain) TDSingleLineCommentState *singleLineState;
@property (nonatomic, retain) TDMultiLineCommentState *multiLineState;
@end

@interface TDSingleLineCommentState ()
- (void)addStartSymbol:(NSString *)start;
- (void)removeStartSymbol:(NSString *)start;
@property (nonatomic, retain) NSMutableArray *startSymbols;
@property (nonatomic, retain) NSString *currentStartSymbol;
@end

@interface TDMultiLineCommentState ()
- (void)addStartSymbol:(NSString *)start endSymbol:(NSString *)end;
- (void)removeStartSymbol:(NSString *)start;
@property (nonatomic, retain) NSMutableArray *startSymbols;
@property (nonatomic, retain) NSMutableArray *endSymbols;
@property (nonatomic, copy) NSString *currentStartSymbol;
@end

@implementation TDCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.rootNode = [[[TDSymbolRootNode alloc] init] autorelease];
        self.singleLineState = [[[TDSingleLineCommentState alloc] init] autorelease];
        self.multiLineState = [[[TDMultiLineCommentState alloc] init] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    self.singleLineState = nil;
    self.multiLineState = nil;
    [super dealloc];
}


- (void)addSingleLineStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode add:start];
    [singleLineState addStartSymbol:start];
}


- (void)removeSingleLineStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode remove:start];
    [singleLineState removeStartSymbol:start];
}


- (void)addMultiLineStartSymbol:(NSString *)start endSymbol:(NSString *)end {
    NSParameterAssert(start.length);
    NSParameterAssert(end.length);
    [rootNode add:start];
    [rootNode add:end];
    [multiLineState addStartSymbol:start endSymbol:end];
}


- (void)removeMultiLineStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode remove:start];
    [multiLineState removeStartSymbol:start];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);

    NSString *symbol = [rootNode nextSymbol:r startingWith:cin];

    if ([multiLineState.startSymbols containsObject:symbol]) {
        multiLineState.currentStartSymbol = symbol;
        return [multiLineState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else if ([singleLineState.startSymbols containsObject:symbol]) {
        singleLineState.currentStartSymbol = symbol;
        return [singleLineState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else {
        NSInteger i = 0;
        for ( ; i < symbol.length - 1; i++) {
            [r unread];
        }
        return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:[NSString stringWithFormat:@"%C", (unsigned short)cin] floatValue:0.0];
    }
}

@synthesize rootNode;
@synthesize singleLineState;
@synthesize multiLineState;
@synthesize reportsCommentTokens;
@synthesize balancesEOFTerminatedComments;
@end
