//
//  NSObject+MochaAdditions.h
//  Mocha
//
//  Created by Logan Collins on 5/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOClassDescription;


@interface NSObject (MochaAdditions)

+ (void)mo_swizzleAdditions;

+ (MOClassDescription *)mo_mocha;

@end
