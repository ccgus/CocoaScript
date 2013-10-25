//
//  TDParseKit.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDToken;
@class TDTokenizerState;
@class TDNumberState;
@class TDQuoteState;
@class TDSlashState;
@class TDCommentState;
@class TDSymbolState;
@class TDWhitespaceState;
@class TDWordState;
@class TDReader;

/*!
    @class      TDTokenizer
    @brief      A tokenizer divides a string into tokens.
    @details    <p>This class is highly customizable with regard to exactly how this division occurs, but it also has defaults that are suitable for many languages. This class assumes that the character values read from the string lie in the range <tt>0-MAXINT</tt>. For example, the Unicode value of a capital A is 65, so <tt>NSLog(@"%C", (unichar)65);</tt> prints out a capital A.</p>
                <p>The behavior of a tokenizer depends on its character state table. This table is an array of 256 <tt>TDTokenizerState</tt> states. The state table decides which state to enter upon reading a character from the input string.</p>
                <p>For example, by default, upon reading an 'A', a tokenizer will enter a "word" state. This means the tokenizer will ask a <tt>TDWordState</tt> object to consume the 'A', along with the characters after the 'A' that form a word. The state's responsibility is to consume characters and return a complete token.</p>
                <p>The default table sets a <tt>TDSymbolState</tt> for every character from 0 to 255, and then overrides this with:</p>
@code
     From     To    State
        0    ' '    whitespaceState
      'a'    'z'    wordState
      'A'    'Z'    wordState
      160    255    wordState
      '0'    '9'    numberState
      '-'    '-'    numberState
      '.'    '.'    numberState
      '"'    '"'    quoteState
     '\''   '\''    quoteState
      '/'    '/'    commentState
@endcode
                <p>In addition to allowing modification of the state table, this class makes each of the states above available. Some of these states are customizable. For example, wordState allows customization of what characters can be part of a word, after the first character.</p>
*/
@interface TDTokenizer : NSObject {
    NSString *string;
    TDReader *reader;
    
    NSMutableArray *tokenizerStates;
    
    TDNumberState *numberState;
    TDQuoteState *quoteState;
    TDCommentState *commentState;
    TDSymbolState *symbolState;
    TDWhitespaceState *whitespaceState;
    TDWordState *wordState;
}

/*!
    @brief      Convenience factory method. Sets string to read from to <tt>nil</tt>.
    @result     An initialized tokenizer.
*/
+ (id)tokenizer;

/*!
    @brief      Convenience factory method.
    @param      s string to read from.
    @result     An autoreleased initialized tokenizer.
*/
+ (id)tokenizerWithString:(NSString *)s;

/*!
    @brief      Designated Initializer. Constructs a tokenizer to read from the supplied string.
    @param      s string to read from.
    @result     An initialized tokenizer.
*/
- (id)initWithString:(NSString *)s;

/*!
    @brief      Returns the next token.
    @result     the next token.
*/
- (TDToken *)nextToken;

/*!
    @brief      Change the state the tokenizer will enter upon reading any character between "start" and "end".
    @param      state the state for this character range
    @param      start the "start" character. e.g. <tt>'a'</tt> or <tt>65</tt>.
    @param      end the "end" character. <tt>'z'</tt> or <tt>90</tt>.
*/
- (void)setTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end;

/*!
    @property   string
    @brief      The string to read from.
*/
@property (nonatomic, retain) NSString *string;

/*!
    @property    numberState
    @brief       The state this tokenizer uses to build numbers.
*/
@property (nonatomic, retain) TDNumberState *numberState;

/*!
    @property   quoteState
    @brief      The state this tokenizer uses to build quoted strings.
*/
@property (nonatomic, retain) TDQuoteState *quoteState;

/*!
    @property   commentState
    @brief      The state this tokenizer uses to recognize (and possibly ignore) comments.
*/
@property (nonatomic, retain) TDCommentState *commentState;

/*!
    @property   symbolState
    @brief      The state this tokenizer uses to recognize symbols.
*/
@property (nonatomic, retain) TDSymbolState *symbolState;

/*!
    @property   whitespaceState
    @brief      The state this tokenizer uses to recognize (and possibly ignore) whitespace.
*/
@property (nonatomic, retain) TDWhitespaceState *whitespaceState;

/*!
    @property   wordState
    @brief      The state this tokenizer uses to build words.
*/
@property (nonatomic, retain) TDWordState *wordState;
@end
