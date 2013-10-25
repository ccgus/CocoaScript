//
//  TDMultiLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDMultiLineCommentState.h"
#import "TDCommentState.h"
#import "TDReader.h"
#import "TDTokenizer.h"
#import "TDToken.h"
#import "TDSymbolRootNode.h"

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(NSInteger)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;
@end

@interface TDCommentState ()
@property (nonatomic, retain) TDSymbolRootNode *rootNode;
@end

@interface TDMultiLineCommentState ()
- (void)addStartSymbol:(NSString *)start endSymbol:(NSString *)end;
- (void)removeStartSymbol:(NSString *)start;
@property (nonatomic, retain) NSMutableArray *startSymbols;
@property (nonatomic, retain) NSMutableArray *endSymbols;
@property (nonatomic, copy) NSString *currentStartSymbol;
@end

@implementation TDMultiLineCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.startSymbols = [NSMutableArray array];
        self.endSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startSymbols = nil;
    self.endSymbols = nil;
    self.currentStartSymbol = nil;
    [super dealloc];
}


- (void)addStartSymbol:(NSString *)start endSymbol:(NSString *)end {
    NSParameterAssert(start.length);
    NSParameterAssert(end.length);
    [startSymbols addObject:start];
    [endSymbols addObject:end];
}


- (void)removeStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    NSInteger i = [startSymbols indexOfObject:start];
    if (NSNotFound != i) {
        [startSymbols removeObject:start];
        [endSymbols removeObjectAtIndex:i]; // this should always be in range.
    }
}


- (void)unreadSymbol:(NSString *)s fromReader:(TDReader *)r {
    NSInteger len = s.length;
    NSInteger i = 0;
    for ( ; i < len - 1; i++) {
        [r unread];
    }
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    BOOL balanceEOF = t.commentState.balancesEOFTerminatedComments;
    BOOL reportTokens = t.commentState.reportsCommentTokens;
    if (reportTokens) {
        [self reset];
        [self appendString:currentStartSymbol];
    }
    
    NSInteger i = [startSymbols indexOfObject:currentStartSymbol];
    NSString *currentEndSymbol = [endSymbols objectAtIndex:i];
    NSInteger e = [currentEndSymbol characterAtIndex:0];
    
    // get the definitions of all multi-char comment start and end symbols from the commentState
    TDSymbolRootNode *rootNode = t.commentState.rootNode;
        
    NSInteger c;
    while (1) {
        c = [r read];
        if (-1 == c) {
            if (balanceEOF) {
                [self appendString:currentEndSymbol];
            }
            break;
        }
        
        if (e == c) {
            NSString *peek = [rootNode nextSymbol:r startingWith:e];
            if ([currentEndSymbol isEqualToString:peek]) {
                if (reportTokens) {
                    [self appendString:currentEndSymbol];
                }
                c = [r read];
                break;
            } else {
                [self unreadSymbol:peek fromReader:r];
                if (e != [peek characterAtIndex:0]) {
                    if (reportTokens) {
                        [self append:c];
                    }
                    c = [r read];
                }
            }
        }
        if (reportTokens) {
            [self append:c];
        }
    }
    
    if (-1 != c) {
        [r unread];
    }
    
    self.currentStartSymbol = nil;

    if (reportTokens) {
        return [TDToken tokenWithTokenType:TDTokenTypeComment stringValue:[self bufferedString] floatValue:0.0];
    } else {
        return [t nextToken];
    }
}

@synthesize startSymbols;
@synthesize endSymbols;
@synthesize currentStartSymbol;
@end
