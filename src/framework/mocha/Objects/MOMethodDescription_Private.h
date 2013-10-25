//
//  MOMethodDescription_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOMethodDescription.h"


@interface MOMethodDescription ()

- (id)initWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding;

@property (readwrite) SEL selector;
@property (copy, readwrite) NSString *typeEncoding;

@end
