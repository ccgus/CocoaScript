//
//  MOMethodDescription.m
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOMethodDescription.h"
#import "MOMethodDescription_Private.h"


@implementation MOMethodDescription

@synthesize selector=_selector;
@synthesize typeEncoding=_typeEncoding;

+ (MOMethodDescription *)methodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding {
    return [[self alloc] initWithSelector:selector typeEncoding:typeEncoding];
}

- (id)initWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding {
    self = [super init];
    if (self) {
        self.selector = selector;
        self.typeEncoding = typeEncoding;
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : selector=%@, typeEncoding=%@>", [self class], self, NSStringFromSelector(self.selector), self.typeEncoding];
}

@end
