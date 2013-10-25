//
//  JSTScanner.h
//  jstalk
//
//  Created by August Mueller on 1/16/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JSTScanner : NSObject {
    NSString    *_jsString;
    unichar     *_uString;
    NSRange     _currentRange;
    NSUInteger  _stringLength;
    unichar     _breakChar;
    BOOL        _tokenIsBreakChar;
    
    // state stuff.
    BOOL _inComment;
    BOOL _inQuote;
    BOOL _inJSTalk;
    
    
    NSMutableArray *_frames;
    
}

@property (retain) NSString *jsString;
@property (retain) NSMutableArray *frames;

+ (JSTScanner*) scannerWithString:(NSString*)s;

- (void) scan;
- (NSString*) nextToken;

@end




#define isBreakChar(c) ((c == ' ')  || (c == '\r') || (c == '\n') || (c == '\t') ||\
                        (c == '\"') || (c == '\'') || (c == '(')  || (c == ')')  ||\
                        (c == '{')  || (c == '}')  || (c == '/')  || (c == '*')  ||\
                        (c == '\\')\
                        )




