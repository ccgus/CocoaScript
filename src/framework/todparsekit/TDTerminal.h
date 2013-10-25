//
//  TDTerminal.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDParser.h"

@class TDToken;

/*!
    @class      TDTerminal
    @brief      An Abstract Class. A <tt>TDTerminal</tt> is a parser that is not a composition of other parsers.
*/
@interface TDTerminal : TDParser {
    NSString *string;
    BOOL discardFlag;
}

/*!
    @brief      Designated Initializer for all concrete <tt>TDTerminal</tt> subclasses.
    @details    Note this is an abtract class and this method must be called on a concrete subclass.
    @param      s the string matched by this parser
    @result     an initialized <tt>TDTerminal</tt> subclass object
*/
- (id)initWithString:(NSString *)s;

/*!
    @brief      By default, terminals push themselves upon a assembly's stack, after a successful match. This method will turn off that behavior.
    @details    This method returns this parser as a convenience for chainging-style usage.
    @result     this parser, returned for chaining/convenience
*/
- (TDTerminal *)discard;

/*!
    @property   string
    @brief      the string matched by this parser.
*/
@property (nonatomic, readonly, copy) NSString *string;
@end
