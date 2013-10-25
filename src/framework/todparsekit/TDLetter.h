//
//  TDLetter.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTerminal.h"

/*!
    @class      TDLetter 
    @brief      A <tt>TDLetter</tt> matches any letter from a character assembly.
    @details    <tt>-[TDLetter qualifies:]</tt> returns true if an assembly's next element is a letter.
*/
@interface TDLetter : TDTerminal {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDLetter</tt> parser.
    @result     an initialized autoreleased <tt>TDLetter</tt> parser.
*/
+ (id)letter;
@end
