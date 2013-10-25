//
//  TDWhitespaceState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDWhitespaceState.h"
#import "TDReader.h"
#import "TDTokenizer.h"
#import "TDToken.h"

#define TDTRUE (id)kCFBooleanTrue
#define TDFALSE (id)kCFBooleanFalse

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(NSInteger)c;
- (NSString *)bufferedString;
@end

@interface TDWhitespaceState ()
@property (nonatomic, retain) NSMutableArray *whitespaceChars;
@end

@implementation TDWhitespaceState

- (id)init {
    self = [super init];
    if (self) {
        const NSUInteger len = 255;
        self.whitespaceChars = [NSMutableArray arrayWithCapacity:len];
        NSUInteger i = 0;
        for ( ; i <= len; i++) {
            [whitespaceChars addObject:TDFALSE];
        }
        
        [self setWhitespaceChars:YES from:0 to:' '];
    }
    return self;
}


- (void)dealloc {
    self.whitespaceChars = nil;
    [super dealloc];
}


- (void)setWhitespaceChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end {
    NSUInteger len = whitespaceChars.count;
    if (start > len || end > len || start < 0 || end < 0) {
        [NSException raise:@"TDWhitespaceStateNotSupportedException" format:@"TDWhitespaceState only supports setting word chars for chars in the latin1 set (under 256)"];
    }

    id obj = yn ? TDTRUE : TDFALSE;
    NSUInteger i = start;
    for ( ; i <= end; i++) {
        [whitespaceChars replaceObjectAtIndex:i withObject:obj];
    }
}


- (BOOL)isWhitespaceChar:(NSInteger)cin {
    if (cin < 0 || cin > whitespaceChars.count - 1) {
        return NO;
    }
    return TDTRUE == [whitespaceChars objectAtIndex:cin];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    if (reportsWhitespaceTokens) {
        [self reset];
    }
    
    NSInteger c = cin;
    while ([self isWhitespaceChar:c]) {
        if (reportsWhitespaceTokens) {
            [self append:c];
        }
        c = [r read];
    }
    if (-1 != c) {
        [r unread];
    }
    
    if (reportsWhitespaceTokens) {
        return [TDToken tokenWithTokenType:TDTokenTypeWhitespace stringValue:[self bufferedString] floatValue:0.0];
    } else {
        return [t nextToken];
    }
}

@synthesize whitespaceChars;
@synthesize reportsWhitespaceTokens;
@end

