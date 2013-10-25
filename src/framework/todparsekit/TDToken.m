//
//  TDToken.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDToken.h"

@interface TDTokenEOF : TDToken {}
+ (TDTokenEOF *)instance;
@end

@implementation TDTokenEOF

static TDTokenEOF *EOFToken = nil;

+ (TDTokenEOF *)instance {
    @synchronized(self) {
        if (!EOFToken) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return EOFToken;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (!EOFToken) {
            EOFToken = [super allocWithZone:zone];
            return EOFToken;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (id)retain {
    return self;
}


- (oneway void)release {
    // do nothing
}


- (id)autorelease {
    return self;
}


- (NSUInteger)retainCount {
    return UINT_MAX; // denotes an object that cannot be released
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<TDTokenEOF %p>", self];
}


- (NSString *)debugDescription {
    return [self description];
}

@end

@interface TDToken ()
- (BOOL)isEqual:(id)rhv ignoringCase:(BOOL)ignoringCase;

@property (nonatomic, readwrite, getter=isNumber) BOOL number;
@property (nonatomic, readwrite, getter=isQuotedString) BOOL quotedString;
@property (nonatomic, readwrite, getter=isSymbol) BOOL symbol;
@property (nonatomic, readwrite, getter=isWord) BOOL word;
@property (nonatomic, readwrite, getter=isWhitespace) BOOL whitespace;
@property (nonatomic, readwrite, getter=isComment) BOOL comment;

@property (nonatomic, readwrite) CGFloat floatValue;
@property (nonatomic, readwrite, copy) NSString *stringValue;
@property (nonatomic, readwrite) TDTokenType tokenType;
@property (nonatomic, readwrite, copy) id value;
@end

@implementation TDToken

+ (TDToken *)EOFToken {
    return [TDTokenEOF instance];
}


+ (id)tokenWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n {
    return [[[self alloc] initWithTokenType:t stringValue:s floatValue:n] autorelease];
}


// designated initializer
- (id)initWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n {
    //NSParameterAssert(s);
    self = [super init];
    if (self) {
        self.tokenType = t;
        self.stringValue = s;
        self.floatValue = n;
        
        self.number = (TDTokenTypeNumber == t);
        self.quotedString = (TDTokenTypeQuotedString == t);
        self.symbol = (TDTokenTypeSymbol == t);
        self.word = (TDTokenTypeWord == t);
        self.whitespace = (TDTokenTypeWhitespace == t);
        self.comment = (TDTokenTypeComment == t);
    }
    return self;
}


- (void)dealloc {
    self.stringValue = nil;
    self.value = nil;
    [super dealloc];
}


- (NSUInteger)hash {
    return [stringValue hash];
}


- (BOOL)isEqual:(id)rhv {
    return [self isEqual:rhv ignoringCase:NO];
}


- (BOOL)isEqualIgnoringCase:(id)rhv {
    return [self isEqual:rhv ignoringCase:YES];
}


- (BOOL)isEqual:(id)rhv ignoringCase:(BOOL)ignoringCase {
    if (![rhv isMemberOfClass:[TDToken class]]) {
        return NO;
    }
    
    TDToken *tok = (TDToken *)rhv;
    if (tokenType != tok.tokenType) {
        return NO;
    }
    
    if (self.isNumber) {
        return floatValue == tok.floatValue;
    } else {
        if (ignoringCase) {
            return (NSOrderedSame == [stringValue caseInsensitiveCompare:tok.stringValue]);
        } else {
            return [stringValue isEqualToString:tok.stringValue];
        }
    }
}


- (id)value {
    if (!value) {
        id v = nil;
        if (self.isNumber) {
            v = [NSNumber numberWithFloat:floatValue];
        } else if (self.isQuotedString) {
            v = stringValue;
        } else if (self.isSymbol) {
            v = stringValue;
        } else if (self.isWord) {
            v = stringValue;
        } else if (self.isWhitespace) {
            v = stringValue;
        } else { // support for token type extensions
            v = stringValue;
        }
        self.value = v;
    }
    return value;
}


- (NSString *)debugDescription {
    NSString *typeString = nil;
    if (self.isNumber) {
        typeString = @"Number";
    } else if (self.isQuotedString) {
        typeString = @"Quoted String";
    } else if (self.isSymbol) {
        typeString = @"Symbol";
    } else if (self.isWord) {
        typeString = @"Word";
    } else if (self.isWhitespace) {
        typeString = @"Whitespace";
    } else if (self.isComment) {
        typeString = @"Comment";
    }
    return [NSString stringWithFormat:@"<%@ %C%@%C>", typeString, (unsigned short)0x00AB, self.value, (unsigned short)0x00BB];
}


- (NSString *)description {
    return stringValue;
}

@synthesize number;
@synthesize quotedString;
@synthesize symbol;
@synthesize word;
@synthesize whitespace;
@synthesize comment;
@synthesize floatValue;
@synthesize stringValue;
@synthesize tokenType;
@synthesize value;
@end
