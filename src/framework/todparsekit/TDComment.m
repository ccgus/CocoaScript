//
//  TDComment.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/31/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDComment.h"
#import "TDToken.h"

@implementation TDComment

+ (id)comment {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    return tok.isComment;
}

@end