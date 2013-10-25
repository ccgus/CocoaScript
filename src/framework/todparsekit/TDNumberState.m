//
//  TDNumberState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDNumberState.h"
#import "TDReader.h"
#import "TDToken.h"
#import "TDTokenizer.h"
#import "TDSymbolState.h"

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(NSInteger)c;
- (NSString *)bufferedString;
@end

@interface TDNumberState ()
- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)fraction;
- (CGFloat)value;
- (void)parseLeftSideFromReader:(TDReader *)r;
- (void)parseRightSideFromReader:(TDReader *)r;
- (void)reset:(NSInteger)cin;
@end

@implementation TDNumberState

- (void)dealloc {
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);

    [self reset];
    negative = NO;
    NSInteger originalCin = cin;
    
    if ('-' == cin) {
        negative = YES;
        cin = [r read];
        [self append:'-'];
    } else if ('+' == cin) {
        cin = [r read];
        [self append:'+'];
    }
    
    [self reset:cin];
    if ('.' == c) {
        [self parseRightSideFromReader:r];
    } else {
        [self parseLeftSideFromReader:r];
        [self parseRightSideFromReader:r];
    }
    
    // erroneous ., +, or -
    if (!gotADigit) {
        if (negative && -1 != c) { // ??
            [r unread];
        }
        return [t.symbolState nextTokenFromReader:r startingWith:originalCin tokenizer:t];
    }
    
    if (-1 != c) {
        [r unread];
    }

    if (negative) {
        floatValue = -floatValue;
    }
    
    return [TDToken tokenWithTokenType:TDTokenTypeNumber stringValue:[self bufferedString] floatValue:[self value]];
}


- (CGFloat)value {
    return floatValue;
}


- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)isFraction {
    CGFloat divideBy = 1.0;
    CGFloat v = 0.0;
    
    while (1) {
        if (isdigit((int)c)) {
            [self append:c];
            gotADigit = YES;
            v = v * 10.0 + (c - '0');
            c = [r read];
            if (isFraction) {
                divideBy *= 10.0;
            }
        } else {
            break;
        }
    }
    
    if (isFraction) {
        v = v / divideBy;
    }

    return (CGFloat)v;
}


- (void)parseLeftSideFromReader:(TDReader *)r {
    floatValue = [self absorbDigitsFromReader:r isFraction:NO];
}


- (void)parseRightSideFromReader:(TDReader *)r {
    if ('.' == c) {
        NSInteger n = [r read];
        BOOL nextIsDigit = isdigit((int)n);
        if (-1 != n) {
            [r unread];
        }

        if (nextIsDigit || allowsTrailingDot) {
            [self append:'.'];
            if (nextIsDigit) {
                c = [r read];
                floatValue += [self absorbDigitsFromReader:r isFraction:YES];
            }
        }
    }
}


- (void)reset:(NSInteger)cin {
    gotADigit = NO;
    floatValue = 0.0;
    c = cin;
}

@synthesize allowsTrailingDot;
@end
