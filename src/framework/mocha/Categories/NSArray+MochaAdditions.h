//
//  NSArray+MochaAdditions.h
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (MochaAdditions)

- (id)mo_objectForIndexedSubscript:(NSUInteger)idx;

@end


@interface NSMutableArray (MochaAdditions)

- (void)mo_setObject:(id)obj forIndexedSubscript:(NSUInteger)idx;

@end
