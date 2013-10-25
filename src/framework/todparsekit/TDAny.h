//
//  TDAny.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTerminal.h"

/*!
    @class      TDAny 
    @brief      A <tt>TDAny</tt> matches any token from a token assembly.
*/
@interface TDAny : TDTerminal {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDAny</tt> object.
    @result     an initialized autoreleased <tt>TDAny</tt> object
*/
+ (id)any;
@end
