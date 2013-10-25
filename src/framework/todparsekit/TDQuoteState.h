//
//  TDQuoteState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTokenizerState.h"

/*!
    @class      TDQuoteState 
    @brief      A quote state returns a quoted string token from a reader
    @details    This state will collect characters until it sees a match to the character that the tokenizer used to switch to this state. For example, if a tokenizer uses a double- quote character to enter this state, then <tt>-nextToken</tt> will search for another double-quote until it finds one or finds the end of the reader.
*/
@interface TDQuoteState : TDTokenizerState {
    BOOL balancesEOFTerminatedQuotes;
}

/*!
    @property   balancesEOFTerminatedQuotes
    @brief      if true, this state will append a matching quote char (<tt>'</tt> or <tt>"</tt>) to quotes terminated by EOF. Default is NO.
*/
@property (nonatomic) BOOL balancesEOFTerminatedQuotes;
@end
