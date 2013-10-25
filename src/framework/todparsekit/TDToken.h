//
//  TDToken.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @typedef    enum TDTokenType
    @brief      Indicates the type of a <tt>TDToken</tt>
    @var        TDTokenTypeEOF A constant indicating that the endo fo the stream has been read.
    @var        TDTokenTypeNumber A constant indicating that a token is a number, like <tt>3.14</tt>.
    @var        TDTokenTypeQuotedString A constant indicating that a token is a quoted string, like <tt>"Launch Mi"</tt>.
    @var        TDTokenTypeSymbol A constant indicating that a token is a symbol, like <tt>"&lt;="</tt>.
    @var        TDTokenTypeWord A constant indicating that a token is a word, like <tt>cat</tt>.
*/
typedef enum {
    TDTokenTypeEOF,
    TDTokenTypeNumber,
    TDTokenTypeQuotedString,
    TDTokenTypeSymbol,
    TDTokenTypeWord,
    TDTokenTypeWhitespace,
    TDTokenTypeComment
} TDTokenType;

/*!
    @class      TDToken
    @brief      A token represents a logical chunk of a string.
    @details    For example, a typical tokenizer would break the string <tt>"1.23 &lt;= 12.3"</tt> into three tokens: the number <tt>1.23</tt>, a less-than-or-equal symbol, and the number <tt>12.3</tt>. A token is a receptacle, and relies on a tokenizer to decide precisely how to divide a string into tokens.
*/
@interface TDToken : NSObject {
    CGFloat floatValue;
    NSString *stringValue;
    TDTokenType tokenType;
    
    BOOL number;
    BOOL quotedString;
    BOOL symbol;
    BOOL word;
    BOOL whitespace;
    BOOL comment;
    
    id value;
}

/*!
    @brief      Factory method for creating a singleton <tt>TDToken</tt> used to indicate that there are no more tokens.
    @result     A singleton used to indicate that there are no more tokens.
*/
+ (TDToken *)EOFToken;

/*!
    @brief      Factory convenience method for creating an autoreleased token.
    @param      t the type of this token.
    @param      s the string value of this token.
    @param      n the number falue of this token.
    @result     an autoreleased initialized token.
*/
+ (id)tokenWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n;

/*!
    @brief      Designated initializer. Constructs a token of the indicated type and associated string or numeric values.
    @param      t the type of this token.
    @param      s the string value of this token.
    @param      n the number falue of this token.
    @result     an autoreleased initialized token.
*/
- (id)initWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n;

/*!
    @brief      Returns true if the supplied object is an equivalent <tt>TDToken</tt>, ignoring differences in case.
    @param      obj the object to compare this token to.
    @result     true if <tt>obj</tt> is an equivalent <tt>TDToken</tt>, ignoring differences in case.
*/
- (BOOL)isEqualIgnoringCase:(id)obj;

/*!
    @brief      Returns more descriptive textual representation than <tt>-description</tt> which may be useful for debugging puposes only.
    @details    Usually of format similar to: <tt>&lt;QuotedString "Launch Mi"></tt>, <tt>&lt;Word cat></tt>, or <tt>&lt;Num 3.14></tt>
    @result     A textual representation including more descriptive information than <tt>-description</tt>.
*/
- (NSString *)debugDescription;

/*!
    @property   number
    @brief      True if this token is a number. getter=isNumber
*/
@property (nonatomic, readonly, getter=isNumber) BOOL number;

/*!
    @property   quotedString
    @brief      True if this token is a quoted string. getter=isQuotedString
*/
@property (nonatomic, readonly, getter=isQuotedString) BOOL quotedString;

/*!
    @property   symbol
    @brief      True if this token is a symbol. getter=isSymbol
*/
@property (nonatomic, readonly, getter=isSymbol) BOOL symbol;

/*!
    @property   word
    @brief      True if this token is a word. getter=isWord
*/
@property (nonatomic, readonly, getter=isWord) BOOL word;

/*!
    @property   whitespace
    @brief      True if this token is whitespace. getter=isWhitespace
*/
@property (nonatomic, readonly, getter=isWhitespace) BOOL whitespace;

/*!
    @property   comment
    @brief      True if this token is a comment. getter=isComment
*/
@property (nonatomic, readonly, getter=isComment) BOOL comment;

/*!
    @property   tokenType
    @brief      The type of this token.
*/
@property (nonatomic, readonly) TDTokenType tokenType;

/*!
    @property   floatValue
    @brief      The numeric value of this token.
*/
@property (nonatomic, readonly) CGFloat floatValue;

/*!
    @property   stringValue
    @brief      The string value of this token.
*/
@property (nonatomic, readonly, copy) NSString *stringValue;

/*!
    @property   value
    @brief      Returns an object that represents the value of this token.
*/
@property (nonatomic, readonly, copy) id value;
@end
