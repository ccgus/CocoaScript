//
//  TDScientificNumberState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDNumberState.h"

/*!
    @class      TDScientificNumberState 
    @brief      A <tt>TDScientificNumberState</tt> object returns a number from a reader.
    @details    <p>This state's idea of a number expands on its superclass, allowing an 'e' followed by an integer to represent 10 to the indicated power. For example, this state will recognize <tt>1e2</tt> as equaling <tt>100</tt>.</p>
                <p>This class exists primarily to show how to introduce a new tokenizing state.</p>
*/
@interface TDScientificNumberState : TDNumberState {
    CGFloat exp;
    BOOL negativeExp;
}

@end
