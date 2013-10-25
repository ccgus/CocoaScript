//
//  TDSpecificChar.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTerminal.h"

/*!
    @class      TDSpecificChar 
    @brief      A <tt>TDSpecificChar</tt> matches a specified character from a character assembly.
    @details    <tt>-[TDSpecificChar qualifies:] returns true if an assembly's next element is equal to the character this object was constructed with.
*/
@interface TDSpecificChar : TDTerminal {
}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDSpecificChar</tt> parser.
    @param      c the character this object should match
    @result     an initialized autoreleased <tt>TDSpecificChar</tt> parser.
*/
+ (id)specificCharWithChar:(NSInteger)c;

/*!
    @brief      Designated Initializer. Initializes a <tt>TDSpecificChar</tt> parser.
    @param      c the character this object should match
    @result     an initialized <tt>TDSpecificChar</tt> parser.
*/
- (id)initWithSpecificChar:(NSInteger)c;
@end
