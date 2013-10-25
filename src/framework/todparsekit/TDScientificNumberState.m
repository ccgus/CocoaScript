//
//  TDScientificNumberState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDScientificNumberState.h"
#import "TDReader.h"

@interface TDTokenizerState ()
- (void)append:(NSInteger)c;
@end

@interface TDNumberState ()
- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)isFraction;
- (void)parseRightSideFromReader:(TDReader *)r;
- (void)reset:(NSInteger)cin;
- (CGFloat)value;
@end

@implementation TDScientificNumberState

- (void)parseRightSideFromReader:(TDReader *)r {
    NSParameterAssert(r);
    [super parseRightSideFromReader:r];
    if ('e' == c || 'E' == c) {
        NSInteger e = c;
        c = [r read];
        
        BOOL hasExp = isdigit((int)c);
        negativeExp = ('-' == c);
        BOOL positiveExp = ('+' == c);

        if (!hasExp && (negativeExp || positiveExp)) {
            c = [r read];
            hasExp = isdigit((int)c);
        }
        if (-1 != c) {
            [r unread];
        }
        if (hasExp) {
            [self append:e];
            if (negativeExp) {
                [self append:'-'];
            } else if (positiveExp) {
                [self append:'+'];
            }
            c = [r read];
            exp = [super absorbDigitsFromReader:r isFraction:NO];
        }
    }
}


- (void)reset:(NSInteger)cin {
    [super reset:cin];
    exp = (CGFloat)0.0;
    negativeExp = NO;
}


- (CGFloat)value {
    CGFloat result = (CGFloat)floatValue;
    
    NSUInteger i = 0;
    for ( ; i < exp; i++) {
        if (negativeExp) {
            result /= (CGFloat)10.0;
        } else {
            result *= (CGFloat)10.0;
        }
    }
    
    return (CGFloat)result;
}

@end
