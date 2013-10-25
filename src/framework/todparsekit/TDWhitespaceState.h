//
//  TDWhitespaceState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTokenizerState.h"

/*!
    @class      TDWhitespaceState
    @brief      A whitespace state ignores whitespace (such as blanks and tabs), and returns the tokenizer's next token.
    @details    By default, all characters from 0 to 32 are whitespace.
*/
@interface TDWhitespaceState : TDTokenizerState {
    NSMutableArray *whitespaceChars;
    BOOL reportsWhitespaceTokens;
}

/*!
    @brief      Informs whether the given character is recognized as whitespace (and therefore ignored) by this state.
    @param      cin the character to check
    @result     true if the given chracter is recognized as whitespace
*/
- (BOOL)isWhitespaceChar:(NSInteger)cin;

/*!
    @brief      Establish the given character range as whitespace to ignore.
    @param      yn true if the given character range is whitespace
    @param      start the "start" character. e.g. <tt>'a'</tt> or <tt>65</tt>.
    @param      end the "end" character. <tt>'z'</tt> or <tt>90</tt>.
*/
- (void)setWhitespaceChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end;

/*!
    @property   reportsWhitespaceTokens
    @brief      determines whether a <tt>TDTokenizer</tt> associated with this state reports or silently consumes whitespace tokens. default is <tt>NO</tt> which causes silent consumption of whitespace chars
*/
@property (nonatomic) BOOL reportsWhitespaceTokens;
@end
