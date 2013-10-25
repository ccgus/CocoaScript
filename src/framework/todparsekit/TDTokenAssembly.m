//
//  TDTokenAssembly.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenAssembly.h"
#import "TDTokenizer.h"
#import "TDToken.h"

@interface TDTokenAssembly ()
- (id)initWithString:(NSString *)s tokenzier:(TDTokenizer *)t tokenArray:(NSArray *)a;
- (void)tokenize;
- (NSString *)objectsFrom:(NSInteger)start to:(NSInteger)end separatedBy:(NSString *)delimiter;

@property (nonatomic, retain) TDTokenizer *tokenizer;
@property (nonatomic, copy) NSArray *tokens;
@end

@implementation TDTokenAssembly

+ (id)assemblyWithTokenizer:(TDTokenizer *)t {
    return [[[self alloc] initWithTokenzier:t] autorelease];
}


- (id)initWithTokenzier:(TDTokenizer *)t {
    return [self initWithString:t.string tokenzier:t tokenArray:nil];
}


+ (id)assemblyWithTokenArray:(NSArray *)a {
    return [[[self alloc] initWithTokenArray:a] autorelease];
}


- (id)initWithTokenArray:(NSArray *)a {
    return [self initWithString:[a componentsJoinedByString:@""] tokenzier:nil tokenArray:a];
}


- (id)initWithString:(NSString *)s {
    return [self initWithTokenzier:[[[TDTokenizer alloc] initWithString:s] autorelease]];
}


// designated initializer. this method is private and should not be called from other classes
- (id)initWithString:(NSString *)s tokenzier:(TDTokenizer *)t tokenArray:(NSArray *)a {
    self = [super initWithString:s];
    if (self) {
        if (t) {
            self.tokenizer = t;
        } else {
            self.tokens = a;
        }
    }
    return self;
}


- (void)dealloc {
    [tokenizer release];
    [tokens release];
    //self.tokenizer = nil;
    //self.tokens = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    TDTokenAssembly *a = (TDTokenAssembly *)[super copyWithZone:zone];
    a->tokens = [self.tokens copyWithZone:zone];
    a->preservesWhitespaceTokens = preservesWhitespaceTokens;
    return a;
}


- (NSArray *)tokens {
    if (!tokens) {
        [self tokenize];
    }
    return tokens;
}


- (id)peek {
    TDToken *tok = nil;
    
    while (1) {
        if (index >= self.tokens.count) {
            tok = nil;
            break;
        }
        
        tok = [self.tokens objectAtIndex:index];
        if (!preservesWhitespaceTokens) {
            break;
        }
        if (TDTokenTypeWhitespace == tok.tokenType) {
            [self push:tok];
            index++;
        } else {
            break;
        }
    }
    
    return tok;
}


- (id)next {
    id tok = [self peek];
    if (tok) {
        index++;
    }
    return tok;
}


- (BOOL)hasMore {
    return (index < self.tokens.count);
}


- (NSUInteger)length {
    return self.tokens.count;
} 


- (NSUInteger)objectsConsumed {
    return index;
}


- (NSUInteger)objectsRemaining {
    return (self.tokens.count - index);
}


- (NSString *)consumedObjectsJoinedByString:(NSString *)delimiter {
    NSParameterAssert(delimiter);
    return [self objectsFrom:0 to:self.objectsConsumed separatedBy:delimiter];
}


- (NSString *)remainingObjectsJoinedByString:(NSString *)delimiter {
    NSParameterAssert(delimiter);
    return [self objectsFrom:self.objectsConsumed to:self.length separatedBy:delimiter];
}


#pragma mark -
#pragma mark Private

- (void)tokenize {
    if (!tokenizer) {
        return;
    }
    
    NSMutableArray *a = [NSMutableArray array];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    while ((tok = [tokenizer nextToken]) != eof) {
        [a addObject:tok];
    }

    self.tokens = a;
}


- (NSString *)objectsFrom:(NSInteger)start to:(NSInteger)end separatedBy:(NSString *)delimiter {
    NSMutableString *s = [NSMutableString string];

    NSInteger i = start;
    for ( ; i < end; i++) {
        TDToken *tok = [self.tokens objectAtIndex:i];
        [s appendString:tok.stringValue];
        if (end - 1 != i) {
            [s appendString:delimiter];
        }
    }
    
    return [[s copy] autorelease];
}

@synthesize tokenizer;
@synthesize tokens;
@synthesize preservesWhitespaceTokens;
@end
