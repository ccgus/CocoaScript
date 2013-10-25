//
//  TDWordState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDWordState.h"
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

@interface TDWordState () 
- (BOOL)isWordChar:(NSInteger)c;

@property (nonatomic, retain) NSMutableArray *wordChars;
@end

@implementation TDWordState

- (id)init {
    self = [super init];
    if (self) {
        const NSUInteger len = 255;
        self.wordChars = [NSMutableArray arrayWithCapacity:len];
        NSInteger i = 0;
        for ( ; i <= len; i++) {
            [wordChars addObject:TDFALSE];
        }
        
        [self setWordChars:YES from: 'a' to: 'z'];
        [self setWordChars:YES from: 'A' to: 'Z'];
        [self setWordChars:YES from: '0' to: '9'];
        [self setWordChars:YES from: '-' to: '-'];
        [self setWordChars:YES from: '_' to: '_'];
        [self setWordChars:YES from:'\'' to:'\''];
        [self setWordChars:YES from:0xC0 to:0xFF];
    }
    return self;
}


- (void)dealloc {
    self.wordChars = nil;
    [super dealloc];
}


- (void)setWordChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end {
    NSInteger len = wordChars.count;
    if (start > len || end > len || start < 0 || end < 0) {
        [NSException raise:@"TDWordStateNotSupportedException" format:@"TDWordState only supports setting word chars for chars in the latin1 set (under 256)"];
    }
    
    id obj = yn ? TDTRUE : TDFALSE;
    NSInteger i = start;
    for ( ; i <= end; i++) {
        [wordChars replaceObjectAtIndex:i withObject:obj];
    }
}


- (BOOL)isWordChar:(NSInteger)c {    
    if (c > -1 && c < wordChars.count - 1) {
        return (TDTRUE == [wordChars objectAtIndex:c]);
    }

    if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
        return NO;
    } else if (c >= 0xFE30 && c <= 0xFE6F) { // general punctuation
        return NO;
    } else if (c >= 0xFE30 && c <= 0xFE6F) { // western musical symbols
        return NO;
    } else if (c >= 0xFF00 && c <= 0xFF65) { // symbols within Hiragana & Katakana
        return NO;            
    } else if (c >= 0xFFF0 && c <= 0xFFFF) { // specials
        return NO;            
    } else if (c < 0) {
        return NO;
    } else {
        return YES;
    }
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    [self reset];
    
    NSInteger c = cin;
    do {
        [self append:c];
        c = [r read];
    } while ([self isWordChar:c]);
    
    if (-1 != c) {
        [r unread];
    }
    
    return [TDToken tokenWithTokenType:TDTokenTypeWord stringValue:[self bufferedString] floatValue:0.0];
}


@synthesize wordChars;
@end
