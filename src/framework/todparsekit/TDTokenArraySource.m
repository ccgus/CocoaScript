//
//  TDTokenArraySource.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/11/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenArraySource.h"
#import "TDToken.h"
#import "TDTokenizer.h"

@interface TDTokenArraySource ()
@property (nonatomic, retain) TDTokenizer *tokenizer;
@property (nonatomic, retain) NSString *delimiter;
@property (nonatomic, retain) TDToken *nextToken;
@end

@implementation TDTokenArraySource

- (id)init {
    return [self initWithTokenizer:nil delimiter:nil];
}


- (id)initWithTokenizer:(TDTokenizer *)t delimiter:(NSString *)s {
    NSParameterAssert(t);
    NSParameterAssert(s);
    self = [super init];
    if (self) {
        self.tokenizer = t;
        self.delimiter = s;
    }
    return self;
}


- (void)dealloc {
    self.tokenizer = nil;
    self.delimiter = nil;
    self.nextToken = nil;
    [super dealloc];
}


- (BOOL)hasMore {
    if (!nextToken) {
        self.nextToken = [tokenizer nextToken];
    }

    return ([TDToken EOFToken] != nextToken);
}


- (NSArray *)nextTokenArray {
    if (![self hasMore]) {
        return nil;
    }
    
    NSMutableArray *res = [NSMutableArray arrayWithObject:nextToken];
    self.nextToken = nil;
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;

    while ((tok = [tokenizer nextToken]) != eof) {
        if ([tok.stringValue isEqualToString:delimiter]) {
            break; // discard delimiter tok
        }
        [res addObject:tok];
    }
    
    //return [[res copy] autorelease];
    return res; // optimization
}

@synthesize tokenizer;
@synthesize delimiter;
@synthesize nextToken;
@end
