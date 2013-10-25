//
//  TDCaseInsensitiveLiteral.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDCaseInsensitiveLiteral.h"
#import "TDToken.h"

@implementation TDCaseInsensitiveLiteral

- (BOOL)qualifies:(id)obj {
    return NSOrderedSame == [literal.stringValue caseInsensitiveCompare:[obj stringValue]];
//    return [literal isEqualIgnoringCase:obj];
}

@end
