//
//  TDComment.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/31/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTerminal.h"

/*!
    @class      TDComment
    @brief      A Comment matches a comment from a token assembly.
*/
@interface TDComment : TDTerminal {

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDComment</tt> object.
    @result     an initialized autoreleased <tt>TDComment</tt> object
*/
+ (id)comment;
@end
