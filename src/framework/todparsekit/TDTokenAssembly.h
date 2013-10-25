//
//  TDTokenAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDAssembly.h"

@class TDTokenizer;

/*!
    @class      TDTokenAssembly 
    @brief      A <tt>TDTokenAssembly</tt> is a <tt>TDAssembly</tt> whose elements are <tt>TDToken</tt>s.
    @details    <tt>TDToken</tt>s are, roughly, the chunks of text that a <tt>TDTokenizer</tt> returns.
*/
@interface TDTokenAssembly : TDAssembly <NSCopying> {
    TDTokenizer *tokenizer;
    NSArray *tokens;
    BOOL preservesWhitespaceTokens;
}

/*!
    @brief      Convenience factory method for initializing an autoreleased assembly with the tokenizer <tt>t</tt> and its string
    @param      t tokenizer whose string will be worked on
    @result     an initialized autoreleased assembly
*/
+ (id)assemblyWithTokenizer:(TDTokenizer *)t;

/*!
    @brief      Initializes an assembly with the tokenizer <tt>t</tt> and its string
    @param      t tokenizer whose string will be worked on
    @result     an initialized assembly
*/
- (id)initWithTokenzier:(TDTokenizer *)t;

/*!
    @brief      Convenience factory method for initializing an autoreleased assembly with the token array <tt>a</tt> and its string
    @param      a token array whose string will be worked on
    @result     an initialized autoreleased assembly
*/
+ (id)assemblyWithTokenArray:(NSArray *)a;

/*!
    @brief      Initializes an assembly with the token array <tt>a</tt> and its string
    @param      a token array whose string will be worked on
    @result     an initialized assembly
*/
- (id)initWithTokenArray:(NSArray *)a;

/*!
    @property   preservesWhitespaceTokens
    @brief      If true, whitespace tokens retreived from this assembly's tokenizier will be silently placed on this assembly's stack without being reported by -next or -peek. Default is false.
*/
@property (nonatomic) BOOL preservesWhitespaceTokens;
@end
