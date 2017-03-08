//
//  TDLetter.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDLetter.h"

@implementation TDLetter

+ (id)letter {
    return [[(TDLetter*)[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    NSInteger c = [obj integerValue];
    return isalpha((int)c);
}

@end
