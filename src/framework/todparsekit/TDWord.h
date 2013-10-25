//
//  TDWord.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTerminal.h"

/*!
    @class      TDWord 
    @brief      A <tt>TDWord</tt> matches a word from a token assembly.
*/
@interface TDWord : TDTerminal {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDWord</tt> object.
    @result     an initialized autoreleased <tt>TDWord</tt> object
*/
+ (id)word;
@end
