//
//  TDSingleLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSingleLineCommentState.h"
#import "TDCommentState.h"
#import "TDReader.h"
#import "TDTokenizer.h"
#import "TDToken.h"

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(NSInteger)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;
@end

@interface TDSingleLineCommentState ()
- (void)addStartSymbol:(NSString *)start;
- (void)removeStartSymbol:(NSString *)start;
@property (nonatomic, retain) NSMutableArray *startSymbols;
@property (nonatomic, retain) NSString *currentStartSymbol;
@end

@implementation TDSingleLineCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.startSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startSymbols = nil;
    self.currentStartSymbol = nil;
    [super dealloc];
}


- (void)addStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [startSymbols addObject:start];
}


- (void)removeStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [startSymbols removeObject:start];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    BOOL reportTokens = t.commentState.reportsCommentTokens;
    if (reportTokens) {
        [self reset];
        if (currentStartSymbol.length > 1) {
            [self appendString:currentStartSymbol];
        }
    }
    
    NSInteger c;
    while (1) {
        c = [r read];
        if ('\n' == c || '\r' == c || -1 == c) {
            break;
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
@synthesize currentStartSymbol;
@end
