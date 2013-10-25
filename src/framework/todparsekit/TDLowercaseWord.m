//
//  TDLowercaseWord.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDLowercaseWord.h"
#import "TDToken.h"

@implementation TDLowercaseWord

- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    if (!tok.isWord) {
        return NO;
    }
    
    NSString *s = tok.stringValue;
    return s.length && islower([s characterAtIndex:0]);
}

@end
