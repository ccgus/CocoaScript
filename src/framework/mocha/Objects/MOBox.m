//
//  MOBox.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOBox.h"


@implementation MOBox

- (void)dealloc {
    
    debug(@"representedObject: '%p'", _representedObject);
    debug(@"%s:%d", __FUNCTION__, __LINE__);
}


@end
