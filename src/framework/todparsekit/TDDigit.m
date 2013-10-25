//
//  TDDigit.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDDigit.h"

@implementation TDDigit

+ (id)digit {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    NSInteger c = [obj integerValue];
    return isdigit((int)c);
}

@end
