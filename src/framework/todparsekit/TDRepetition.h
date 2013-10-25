//
//  TDRepetition.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDParser.h"

/*!
    @class      TDRepetition 
    @brief      A <tt>TDRepetition</tt> matches its underlying parser repeatedly against a assembly.
*/
@interface TDRepetition : TDParser {
    TDParser *subparser;
    id preassembler;
    SEL preassemblerSelector;
}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDRepetition</tt> parser to repeatedly match against subparser <tt>p</tt>.
    @param      p the subparser against wich to repeatedly match
    @result     an initialized autoreleased <tt>TDRepetition</tt> parser.
*/
+ (id)repetitionWithSubparser:(TDParser *)p;

/*!
    @brief      Designated Initializer. Initialize a <tt>TDRepetition</tt> parser to repeatedly match against subparser <tt>p</tt>.
    @details    Designated Initializer. Initialize a <tt>TDRepetition</tt> parser to repeatedly match against subparser <tt>p</tt>.
    @param      p the subparser against wich to repeatedly match
    @result     an initialized <tt>TDRepetition</tt> parser.
*/
- (id)initWithSubparser:(TDParser *)p;

/*!
    @brief      Sets the object that will work on every assembly before matching against it.
    @details    Setting a preassembler is entirely optional, but sometimes useful for repetition parsers to do work on an assembly before matching against it.
    @param      a the assembler this parser will use to work on an assembly before matching against it.
    @param      sel a selector that assembler <tt>a</tt> responds to which will work on an assembly
*/
- (void)setPreassembler:(id)a selector:(SEL)sel;

/*!
    @property   subparser
    @brief      this parser's subparser against which it repeatedly matches
*/
@property (nonatomic, readonly, retain) TDParser *subparser;

/*!
    @property   preassembler
    @brief      The assembler this parser will use to work on an assembly before matching against it.
    @discussion <tt>preassembler</tt> should respond to the selector held by this parser's <tt>preassemblerSelector</tt> property.
*/
@property (nonatomic, retain) id preassembler;

/*!
    @property   preAssemlerSelector
    @brief      The method of <tt>preassembler</tt> this parser will call to work on an assembly.
    @details    The method represented by <tt>preassemblerSelector</tt> must accept a single <tt>TDAssembly</tt> argument. The signature of <tt>preassemblerSelector</tt> should be similar to: <tt>- (void)workOnAssembly:(TDAssembly *)a</tt>.
*/
@property (nonatomic, assign) SEL preassemblerSelector;
@end
