//
//  TDNumberState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTokenizerState.h"

/*!
    @class      TDNumberState 
    @brief      A number state returns a number from a reader.
    @details    This state's idea of a number allows an optional, initial minus sign, followed by one or more digits. A decimal point and another string of digits may follow these digits.
*/
@interface TDNumberState : TDTokenizerState {
    BOOL allowsTrailingDot;
    BOOL gotADigit;
    BOOL negative;
    NSInteger c;
    CGFloat floatValue;
}

/*!
    @property   allowsTrailingDot
    @brief      If true, numbers are allowed to end with a trialing dot, e.g. <tt>42.<tt>
    @details    false by default.
*/
@property (nonatomic) BOOL allowsTrailingDot;
@end
