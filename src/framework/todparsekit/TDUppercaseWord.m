//
//  TDUppercaseWord.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDUppercaseWord.h"
#import "TDToken.h"

@implementation TDUppercaseWord

- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    if (!tok.isWord) {
        return NO;
    }
    
    NSString *s = tok.stringValue;
    return s.length && isupper([s characterAtIndex:0]);
}

@end
