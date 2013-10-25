//
//  TDParseKitState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TD_USE_MUTABLE_STRING_BUF 1

@class TDToken;
@class TDTokenizer;
@class TDReader;

/*!
    @class      TDTokenizerState 
    @brief      A <tt>TDTokenizerState</tt> returns a token, given a reader, an initial character read from the reader, and a tokenizer that is conducting an overall tokenization of the reader.
    @details    The tokenizer will typically have a character state table that decides which state to use, depending on an initial character. If a single character is insufficient, a state such as <tt>TDSlashState</tt> will read a second character, and may delegate to another state, such as <tt>TDSlashStarState</tt>. This prospect of delegation is the reason that the <tt>-nextToken</tt> method has a tokenizer argument.
*/
@interface TDTokenizerState : NSObject {
#if TD_USE_MUTABLE_STRING_BUF
    NSMutableString *stringbuf;
#else
    unichar *__strong charbuf;
    NSUInteger length;
    NSUInteger index;
#endif
}

/*!
    @brief      Return a token that represents a logical piece of a reader.
    @param      r the reader from which to read additional characters
    @param      cin the character that a tokenizer used to determine to use this state
    @param      t the tokenizer currently powering the tokenization
    @result     a token that represents a logical piece of the reader
*/
- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t;
@end
