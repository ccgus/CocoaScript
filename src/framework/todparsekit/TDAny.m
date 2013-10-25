//
//  TDAny.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDAny.h"
#import "TDToken.h"

@implementation TDAny

+ (id)any {
    return [[[self alloc] initWithString:nil] autorelease];
}


- (BOOL)qualifies:(id)obj {
    return [obj isKindOfClass:[TDToken class]];
}

@end
