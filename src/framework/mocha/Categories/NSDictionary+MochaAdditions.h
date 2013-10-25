//
//  NSDictionary+MochaAdditions.h
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (MochaAdditions)

- (id)mo_objectForKeyedSubscript:(id)key;

@end


@interface NSMutableDictionary (MochaAdditions)

- (void)mo_setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
