//
//  TDSpecificChar.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSpecificChar.h"

@implementation TDSpecificChar

+ (id)specificCharWithChar:(NSInteger)c {
    return [[[self alloc] initWithSpecificChar:c] autorelease];
}


- (id)initWithSpecificChar:(NSInteger)c {
    self = [super initWithString:[NSString stringWithFormat:@"%C", (unsigned short)c]];
    if (self) {
    }
    return self;
}


- (BOOL)qualifies:(id)obj {
    NSInteger c = [obj integerValue];
    return c == [string characterAtIndex:0];
}

@end
