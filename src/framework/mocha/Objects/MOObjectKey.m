//
//  MOObjectKey.m
//  Mocha
//
//  Created by Adam Fedor on 3/11/15.
//  Copyright (c) 2015 Sunflower Softworks. All rights reserved.
//

#import "MOObjectKey.h"

@implementation MOObjectKey

@synthesize keyObject=_keyObject;

- (id)initWithObject:(id)object {
  self = [super init];
  if (self) {
    _keyObject = object;
  }
  return self;
}

- (BOOL)isEqual:(id)object
{
  if ([object isKindOfClass: [MOObjectKey class]] == NO)
    return NO;
  return ([(MOObjectKey *)object keyObject] == self.keyObject);
}

- (NSUInteger)hash
{
  return (NSUInteger)self.keyObject;
}

@end
