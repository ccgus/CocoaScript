//
//  NSOrderedSet+MochaAdditions.h
//  Mocha
//
//  Created by Logan Collins on 5/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSOrderedSet (MochaAdditions)

- (id)mo_objectForIndexedSubscript:(NSUInteger)idx;

@end


@interface NSMutableOrderedSet (MochaAdditions)

- (void)mo_setObject:(id)obj forIndexedSubscript:(NSUInteger)idx;

@end
