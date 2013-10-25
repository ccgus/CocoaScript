//
//  TDParseKit.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

/*!
    @mainpage   TDParseKit
                TDParseKit is a Mac OS X Framework written by Todd Ditchendorf in Objective-C 2.0 and released under the MIT Open Source License.
				The framework is an Objective-C implementation of the tools described in <a href="http://www.amazon.com/Building-Parsers-Java-Steven-Metsker/dp/0201719622" title="Amazon.com: Building Parsers With Java(TM): Steven John Metsker: Books">"Building Parsers with Java" by Steven John Metsker</a>. 
				TDParseKit includes some significant additions beyond the designs from the book (many of them hinted at in the book itself) in order to enhance the framework's feature set, usefulness and ease-of-use. Other changes have been made to the designs in the book to match common Cocoa/Objective-C design patterns and conventions. 
				However, these changes are relatively superficial, and Metsker's book is the best documentation available for this framework.
                
                Classes in the TDParseKit Framework offer 2 basic services of general use to Cocoa developers:
    @li Tokenization via a tokenizer class
    @li Parsing via a high-level parser-building toolkit
                Learn more on the <a target="_top" href="http://code.google.com/p/todparsekit/">project site</a>
*/
 
#import <Foundation/Foundation.h>

// io
#import "TDReader.h"

// parse
#import "TDParser.h"
#import "TDAssembly.h"
#import "TDSequence.h"
#import "TDCollectionParser.h"
#import "TDAlternation.h"
#import "TDRepetition.h"
#import "TDEmpty.h"
#import "TDTerminal.h"
#import "TDTrack.h"
#import "TDTrackException.h"

//chars
#import "TDCharacterAssembly.h"
#import "TDChar.h"
#import "TDSpecificChar.h"
#import "TDLetter.h"
#import "TDDigit.h"

// tokens
#import "TDToken.h"
#import "TDTokenizer.h"
#import "TDTokenArraySource.h"
#import "TDTokenAssembly.h"
#import "TDTokenizerState.h"
#import "TDNumberState.h"
#import "TDQuoteState.h"
#import "TDCommentState.h"
#import "TDSingleLineCommentState.h"
#import "TDMultiLineCommentState.h"
#import "TDSymbolNode.h"
#import "TDSymbolRootNode.h"
#import "TDSymbolState.h"
#import "TDWordState.h"
#import "TDWhitespaceState.h"
#import "TDWord.h"
#import "TDNum.h"
#import "TDQuotedString.h"
#import "TDSymbol.h"
#import "TDComment.h"
#import "TDLiteral.h"
#import "TDCaseInsensitiveLiteral.h"
#import "TDAny.h"

// ext
#import "TDScientificNumberState.h"
#import "TDWordOrReservedState.h"
#import "TDUppercaseWord.h"
#import "TDLowercaseWord.h"
#import "TDReservedWord.h"
#import "TDNonReservedWord.h"