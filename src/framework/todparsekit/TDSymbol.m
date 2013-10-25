//
//  TDSymbol.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSymbol.h"
#import "TDToken.h"

@interface TDSymbol ()
@property (nonatomic, retain) TDToken *symbol;
@end

@implementation TDSymbol

+ (id)symbol {
    return [[[self alloc] initWithString:nil] autorelease];
}


+ (id)symbolWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
    self = [super initWithString:s];
    if (self) {
        if (s.length) {
            self.symbol = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:s floatValue:0.0];
        }
    }
    return self;
}


- (void)dealloc {
    self.symbol = nil;
    [super dealloc];
}


- (BOOL)qualifies:(id)obj {
    if (symbol) {
        return [symbol isEqual:obj];
    } else {
        TDToken *tok = (TDToken *)obj;
        return tok.isSymbol;
    }
}


- (NSString *)description {
    NSString *className = [[self className] substringFromIndex:2];
    if (name.length) {
        if (symbol) {
            return [NSString stringWithFormat:@"%@ (%@) %@", className, name, symbol.stringValue];
        } else {
            return [NSString stringWithFormat:@"%@ (%@)", className, name];
        }
    } else {
        if (symbol) {
            return [NSString stringWithFormat:@"%@ %@", className, symbol.stringValue];
        } else {
            return [NSString stringWithFormat:@"%@", className];
        }
    }
}

@synthesize symbol;
@end
