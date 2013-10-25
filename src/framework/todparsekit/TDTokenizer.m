//
//  TDParseKit.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenizer.h"
#import "TDParseKit.h"

@interface TDTokenizer ()
- (void)addTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end;
- (TDTokenizerState *)tokenizerStateFor:(NSInteger)c;
@property (nonatomic, retain) TDReader *reader;
@property (nonatomic, retain) NSMutableArray *tokenizerStates;
@end

@implementation TDTokenizer

+ (id)tokenizer {
    return [self tokenizerWithString:nil];
}


+ (id)tokenizerWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    self = [super init];
    if (self) {
        self.string = s;
        self.reader = [[[TDReader alloc] init] autorelease];
        
        numberState = [[TDNumberState alloc] init];
        quoteState = [[TDQuoteState alloc] init];
        commentState = [[TDCommentState alloc] init];
        symbolState = [[TDSymbolState alloc] init];
        whitespaceState = [[TDWhitespaceState alloc] init];
        wordState = [[TDWordState alloc] init];
        
        [symbolState add:@"<="];
        [symbolState add:@">="];
        [symbolState add:@"!="];
        [symbolState add:@"=="];
        
        [commentState addSingleLineStartSymbol:@"//"];
        [commentState addMultiLineStartSymbol:@"/*" endSymbol:@"*/"];
        
        tokenizerStates = [[NSMutableArray alloc] initWithCapacity:256];
        
        [self addTokenizerState:whitespaceState from:   0 to: ' ']; // From:  0 to: 32    From:0x00 to:0x20
        [self addTokenizerState:symbolState     from:  33 to:  33];
        [self addTokenizerState:quoteState      from: '"' to: '"']; // From: 34 to: 34    From:0x22 to:0x22
        [self addTokenizerState:symbolState     from:  35 to:  38];
        [self addTokenizerState:quoteState      from:'\'' to:'\'']; // From: 39 to: 39    From:0x27 to:0x27
        [self addTokenizerState:symbolState     from:  40 to:  42];
        [self addTokenizerState:symbolState     from: '+' to: '+']; // From: 43 to: 43    From:0x2B to:0x2B
        [self addTokenizerState:symbolState     from:  44 to:  44];
        [self addTokenizerState:numberState     from: '-' to: '-']; // From: 45 to: 45    From:0x2D to:0x2D
        [self addTokenizerState:numberState     from: '.' to: '.']; // From: 46 to: 46    From:0x2E to:0x2E
        [self addTokenizerState:commentState    from: '/' to: '/']; // From: 47 to: 47    From:0x2F to:0x2F
        [self addTokenizerState:numberState     from: '0' to: '9']; // From: 48 to: 57    From:0x30 to:0x39
        [self addTokenizerState:symbolState     from:  58 to:  64];
        [self addTokenizerState:wordState       from: 'A' to: 'Z']; // From: 65 to: 90    From:0x41 to:0x5A
        [self addTokenizerState:symbolState     from:  91 to:  96];
        [self addTokenizerState:wordState       from: 'a' to: 'z']; // From: 97 to:122    From:0x61 to:0x7A
        [self addTokenizerState:symbolState     from: 123 to: 191];
        [self addTokenizerState:wordState       from:0xC0 to:0xFF]; // From:192 to:255    From:0xC0 to:0xFF
    }
    return self;
}


- (void)dealloc {
    self.string = nil;
    self.reader = nil;
    self.tokenizerStates = nil;
    self.numberState = nil;
    self.quoteState = nil;
    self.commentState = nil;
    self.symbolState = nil;
    self.whitespaceState = nil;
    self.wordState = nil;
    [super dealloc];
}


- (TDToken *)nextToken {
    NSInteger c = [reader read];
    
    TDToken *result = nil;
    
    if (-1 == c) {
        result = [TDToken EOFToken];
    } else {
        TDTokenizerState *state = [self tokenizerStateFor:c];
        if (state) {
            result = [state nextTokenFromReader:reader startingWith:c tokenizer:self];
        } else {
            result = [TDToken EOFToken];
        }
    }
    
    return result;
}


- (void)addTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end {
    NSParameterAssert(state);
    
    //void (*addObject)(id, SEL, id);
    //addObject = (void (*)(id, SEL, id))[tokenizerStates methodForSelector:@selector(addObject:)];
    
    NSInteger i = start;
    for ( ; i <= end; i++) {
        [tokenizerStates addObject:state];
        //addObject(tokenizerStates, @selector(addObject:), state);
    }
}


- (void)setTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end {
    NSParameterAssert(state);

    //void (*relaceObject)(id, SEL, NSUInteger, id);
    //relaceObject = (void (*)(id, SEL, NSUInteger, id))[tokenizerStates methodForSelector:@selector(replaceObjectAtIndex:withObject:)];

    NSInteger i = start;
    for ( ; i <= end; i++) {
        [tokenizerStates replaceObjectAtIndex:i withObject:state];
        //relaceObject(tokenizerStates, @selector(replaceObjectAtIndex:withObject:), i, state);
    }
}


- (TDReader *)reader {
    return reader;
}


- (void)setReader:(TDReader *)r {
    if (reader != r) {
        [reader release];
        reader = [r retain];
        reader.string = string;
    }
}


- (NSString *)string {
    return string;
}


- (void)setString:(NSString *)s {
    if (string != s) {
        [string retain];
        string = [s retain];
    }
    reader.string = string;
}


#pragma mark -

- (TDTokenizerState *)tokenizerStateFor:(NSInteger)c {
    if (c < 0 || c > 255) {
        if (c >= 0x19E0 && c <= 0x19FF) { // khmer symbols
            return symbolState;
        } else if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
            return symbolState;
        } else if (c >= 0x2E00 && c <= 0x2E7F) { // supplemental punctuation
            return symbolState;
        } else if (c >= 0x3000 && c <= 0x303F) { // cjk symbols & punctuation
            return symbolState;
        } else if (c >= 0x3200 && c <= 0x33FF) { // enclosed cjk letters and months, cjk compatibility
            return symbolState;
        } else if (c >= 0x4DC0 && c <= 0x4DFF) { // yijing hexagram symbols
            return symbolState;
        } else if (c >= 0xFE30 && c <= 0xFE6F) { // cjk compatibility forms, small form variants
            return symbolState;
        } else if (c >= 0xFF00 && c <= 0xFFFF) { // hiragana & katakana halfwitdh & fullwidth forms, Specials
            return symbolState;
        } else {
            return wordState;
        }
    }
    return [tokenizerStates objectAtIndex:c];
}

@synthesize numberState;
@synthesize quoteState;
@synthesize commentState;
@synthesize symbolState;
@synthesize whitespaceState;
@synthesize wordState;
@synthesize string;
@synthesize tokenizerStates;
@end
