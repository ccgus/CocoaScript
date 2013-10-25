//
//  TDSequence.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDCollectionParser.h"

/*!
    @class      TDSequence 
    @brief      A <tt>TDSequence</tt> object is a collection of parsers, all of which must in turn match against an assembly for this parser to successfully match.
*/
@interface TDSequence : TDCollectionParser {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDSequence</tt> parser.
    @result     an initialized autoreleased <tt>TDSequence</tt> parser.
*/
+ (id)sequence;
@end
