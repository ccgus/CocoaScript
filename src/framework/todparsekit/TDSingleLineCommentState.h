//
//  TDSingleLineCommentState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDTokenizerState.h"

@interface TDSingleLineCommentState : TDTokenizerState {
    NSMutableArray *startSymbols;
    NSString *currentStartSymbol;
}

@end
