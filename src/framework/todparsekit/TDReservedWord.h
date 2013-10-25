//
//  TDReservedWord.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDWord.h"

@interface TDReservedWord : TDWord {

}

+ (void)setReservedWords:(NSArray *)inWords;
@end
