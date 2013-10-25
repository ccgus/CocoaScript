//
//  TDReservedWord.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDReservedWord.h"
#import "TDToken.h"

static NSArray *sTDReservedWords = nil;

@interface TDReservedWord ()
+ (NSArray *)reservedWords;
@end

@implementation TDReservedWord

+ (NSArray *)reservedWords {
    return [[sTDReservedWords retain] autorelease];
}


+ (void)setReservedWords:(NSArray *)inWords {
    if (inWords != sTDReservedWords) {
        [sTDReservedWords autorelease];
        sTDReservedWords = [inWords copy];
    }
}


- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    if (!tok.isWord) {
        return NO;
    }
    
    NSString *s = tok.stringValue;
    return s.length && [[TDReservedWord reservedWords] containsObject:s];
}

@end
