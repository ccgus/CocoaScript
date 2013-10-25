//
//  TDAlternation.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDCollectionParser.h"

/*!
    @class      TDAlternation
    @brief      A <tt>TDAlternation</tt> object is a collection of parsers, any one of which can successfully match against an assembly.
*/
@interface TDAlternation : TDCollectionParser {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDAlternation</tt> parser.
    @result     an initialized autoreleased <tt>TDAlternation</tt> parser.
*/
+ (id)alternation;
@end
