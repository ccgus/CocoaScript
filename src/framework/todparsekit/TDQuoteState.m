//
//  TDQuoteState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDQuoteState.h"
#import "TDReader.h"
#import "TDToken.h"

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(NSInteger)c;
- (NSString *)bufferedString;
@end

@implementation TDQuoteState

- (void)dealloc {
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    [self reset];
    
    [self append:cin];
    NSInteger c;
    do {
        c = [r read];
        if (-1 == c) {
            c = cin;
            if (balancesEOFTerminatedQuotes) {
                [self append:c];
            }
        } else {
            [self append:c];
        }
        
    } while (c != cin);
    
    return [TDToken tokenWithTokenType:TDTokenTypeQuotedString stringValue:[self bufferedString] floatValue:0.0];
}

@synthesize balancesEOFTerminatedQuotes;
@end
