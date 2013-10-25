//
//  TDParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDAssembly;

/*!
    @class      TDParser 
    @brief      An Abstract class. A <tt>TDParser</tt> is an object that recognizes the elements of a language.
    @details    <p>Each <tt>TDParser</tt> object is either a <tt>TDTerminal</tt> or a composition of other parsers. The <tt>TDTerminal</tt> class is a subclass of Parser, and is itself a hierarchy of parsers that recognize specific patterns of text. For example, a <tt>TDWord</tt> recognizes any word, and a <tt>TDLiteral</tt> matches a specific string.</p>
                <p>In addition to <tt>TDTerminal</tt>, other subclasses of <tt>TDParser</tt> provide composite parsers, describing sequences, alternations, and repetitions of other parsers. For example, the following <tt>TDParser</tt> objects culminate in a good parser that recognizes a description of good coffee.</p>
@code
    TDAlternation *adjective = [TDAlternation alternation];
    [adjective add:[TDLiteral literalWithString:@"steaming"]];
    [adjective add:[TDLiteral literalWithString:@"hot"]];
    TDSequence *good = [TDSequence sequence];
    [good add:[TDRepetition repetitionWithSubparser:adjective]];
    [good add:[TDLiteral literalWithString:@"coffee"]];
    NSString *s = @"hot hot steaming hot coffee";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    NSLog([good bestMatchFor:a]);
@endcode
                <p>This prints out:</p>
@code
    [hot, hot, steaming, hot, coffee]
    hot/hot/steaming/hot/coffee^
@endcode
                <p>The parser does not match directly against a string, it matches against a <tt>TDAssembly</tt>. The resulting assembly shows its stack, with four words on it, along with its sequence of tokens, and the index at the end of these. In practice, parsers will do some work on an assembly, based on the text they recognize.</p>
*/
@interface TDParser : NSObject {
    id assembler;
    SEL selector;
    NSString *name;
}

/*!
    @brief      Convenience factory method for initializing an autoreleased parser.
    @result     an initialized autoreleased parser.
*/
+ (id)parser;

/*!
    @brief      Sets the object and method that will work on an assembly whenever this parser successfully matches against the assembly.
    @details    The method represented by <tt>sel</tt> must accept a single <tt>TDAssembly</tt> argument. The signature of <tt>sel</tt> should be similar to: <tt>- (void)workOnAssembly:(TDAssembly *)a</tt>.
    @param      a the assembler this parser will use to work on an assembly
    @param      sel a selector that assembler <tt>a</tt> responds to which will work on an assembly
*/
- (void)setAssembler:(id)a selector:(SEL)sel;

/*!
    @brief      Returns the most-matched assembly in a collection.
    @param      inAssembly the assembly for which to find the best match
    @result     an assembly with the greatest possible number of elements consumed by this parser
*/
- (TDAssembly *)bestMatchFor:(TDAssembly *)inAssembly;

/*!
    @brief      Returns either <tt>nil</tt>, or a completely matched version of the supplied assembly.
    @param      inAssembly the assembly for which to find the complete match
    @result     either <tt>nil</tt>, or a completely matched version of the supplied assembly
*/
- (TDAssembly *)completeMatchFor:(TDAssembly *)inAssembly;

/*!
    @brief      Given a set of assemblies, this method matches this parser against all of them, and returns a new set of the assemblies that result from the matches.
    @details    <p>Given a set of assemblies, this method matches this parser against all of them, and returns a new set of the assemblies that result from the matches.</p>
                <p>For example, consider matching the regular expression <tt>a*</tt> against the string <tt>aaab</tt>. The initial set of states is <tt>{^aaab}</tt>, where the <tt>^</tt> indicates how far along the assembly is. When <tt>a*</tt> matches against this initial state, it creates a new set <tt>{^aaab, a^aab, aa^ab, aaa^b}</tt>.</p>
    @param      inAssemblies set of assemblies to match against
    @result     a set of assemblies that result from matching against a beginning set of assemblies
*/
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;

/*!
    @property   assembler
    @brief      The assembler this parser will use to work on a matched assembly.
    @details    <tt>assembler</tt> should respond to the selector held by this parser's <tt>selector</tt> property.
*/
@property (nonatomic, assign) id assembler;

/*!
    @property   selector
    @brief      The method of <tt>assembler</tt> this parser will call to work on a matched assembly.
    @details    The method represented by <tt>selector</tt> must accept a single <tt>TDAssembly</tt> argument. The signature of <tt>selector</tt> should be similar to: <tt>- (void)workOnAssembly:(TDAssembly *)a</tt>.
*/
@property (nonatomic, assign) SEL selector;

/*!
    @property   name
    @brief      The name of this parser.
    @discussion Use this property to help in identifying a parser or for debugging purposes.
*/
@property (nonatomic, copy) NSString *name;
@end
