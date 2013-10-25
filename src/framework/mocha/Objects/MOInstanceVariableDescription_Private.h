//
//  MOInstanceVariableDescription_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOInstanceVariableDescription.h"


@interface MOInstanceVariableDescription ()

- (id)initWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding;

@property (copy, readwrite) NSString *name;
@property (copy, readwrite) NSString *typeEncoding;

@end
