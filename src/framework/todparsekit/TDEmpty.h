//
//  TDEmpty.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDParser.h"

/*!
    @class      TDEmpty 
    @brief      A <tt>TDEmpty</tt> parser matches any assembly once, and applies its assembler that one time.
    @details    <p>Language elements often contain empty parts. For example, a language may at some point allow a list of parameters in parentheses, and may allow an empty list. An empty parser makes it easy to match, within the parenthesis, either a list of parameters or "empty".</p>
*/
@interface TDEmpty : TDParser {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDEmpty</tt> parser.
    @result     an initialized autoreleased <tt>TDEmpty</tt> parser.
*/
+ (id)empty;
@end
