//
//  MOBridgeSupportSymbol.m
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOBridgeSupportSymbol.h"


@implementation MOBridgeSupportSymbol

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : name=%@>", [self class], self, self.name];
}

@end


@implementation MOBridgeSupportStruct

@end


@implementation MOBridgeSupportCFType

@end


@implementation MOBridgeSupportOpaque

@end


@implementation MOBridgeSupportConstant

@end


@implementation MOBridgeSupportStringConstant

@end


@implementation MOBridgeSupportEnum

@end


@implementation MOBridgeSupportFunction {
    NSMutableArray *_arguments;
}

- (id)init {
    self = [super init];
    if (self) {
        _arguments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)description {
    NSString *returnEncoding = nil;
    if (self.returnValue != nil) {
#if __LP64__
        returnEncoding = (self.returnValue.type64 ? self.returnValue.type64 : self.returnValue.type);
#else
        returnEncoding = self.returnValue.type;
#endif
        if (returnEncoding == nil) {
            returnEncoding = @"?";
        }
    }
    else {
        returnEncoding = @"v";
    }
    
    NSMutableArray *argumentEncodings = [NSMutableArray arrayWithCapacity:[[self arguments] count]];
    for (MOBridgeSupportArgument *arg in self.arguments) {
#if __LP64__
        NSString *encoding = (arg.type64 ? arg.type64 : arg.type);
#else
        NSString *encoding = arg.type;
#endif
        [argumentEncodings addObject:(encoding ? encoding : @"?")];
    }
    
    return [NSString stringWithFormat:@"<%@: %p : name=%@, variadic=%@, argTypes=%@, returnType=%@>", [self class], self, self.name, (self.variadic ? @"YES" : @"NO"), [argumentEncodings componentsJoinedByString:@","], returnEncoding];
}


#pragma mark -
#pragma mark Arguments

- (NSArray *)arguments {
    return [_arguments copy];
}

- (void)setArguments:(NSArray *)arguments {
    [_arguments setArray:arguments];
}

- (void)addArgument:(MOBridgeSupportArgument *)argument {
    if (![_arguments containsObject:argument]) {
        [_arguments addObject:argument];
    }
}

- (void)removeArgument:(MOBridgeSupportArgument *)argument {
    if ([_arguments containsObject:argument]) {
        [_arguments removeObject:argument];
    }
}

@end


@implementation MOBridgeSupportFunctionAlias

@end


@implementation MOBridgeSupportClass {
    NSMutableArray *_methods;
}

- (id)init {
    self = [super init];
    if (self) {
        _methods = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Methods

- (NSArray *)methods {
    return _methods;
}

- (void)setMethods:(NSArray *)methods {
    [_methods setArray:methods];
}

- (void)addMethod:(MOBridgeSupportMethod *)method {
    if (![_methods containsObject:method]) {
        [_methods addObject:method];
    }
}

- (void)removeMethod:(MOBridgeSupportMethod *)method {
    if ([_methods containsObject:method]) {
        [_methods removeObject:method];
    }
}

- (MOBridgeSupportMethod *)methodWithSelector:(SEL)selector {
    NSUInteger index = [_methods indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ([obj selector] == selector);
    }];
    if (index != NSNotFound) {
        return [_methods objectAtIndex:index];
    }
    return nil;
}

@end


@implementation MOBridgeSupportInformalProtocol {
    NSMutableArray *_methods;
}

- (id)init {
    self = [super init];
    if (self) {
        _methods = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Methods

- (NSArray *)methods {
    return _methods;
}

- (void)setMethods:(NSArray *)methods {
    [_methods setArray:methods];
}

- (void)addMethod:(MOBridgeSupportMethod *)method {
    if (![_methods containsObject:method]) {
        [_methods addObject:method];
    }
}

- (void)removeMethod:(MOBridgeSupportMethod *)method {
    if ([_methods containsObject:method]) {
        [_methods removeObject:method];
    }
}

- (MOBridgeSupportMethod *)methodWithSelector:(SEL)selector {
    NSUInteger index = [_methods indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ([obj selector] == selector);
    }];
    if (index != NSNotFound) {
        return [_methods objectAtIndex:index];
    }
    return nil;
}

@end


@implementation MOBridgeSupportMethod {
    NSMutableArray *_arguments;
}

- (id)init {
    self = [super init];
    if (self) {
        _arguments = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Arguments

- (NSArray *)arguments {
    return [_arguments copy];
}

- (void)setArguments:(NSArray *)arguments {
    [_arguments setArray:arguments];
}

- (void)addArgument:(MOBridgeSupportArgument *)argument {
    if (![_arguments containsObject:argument]) {
        [_arguments addObject:argument];
    }
}

- (void)removeArgument:(MOBridgeSupportArgument *)argument {
    if ([_arguments containsObject:argument]) {
        [_arguments removeObject:argument];
    }
}

@end


@implementation MOBridgeSupportArgument {
    NSMutableArray *_arguments;
}

- (id)init {
    self = [super init];
    if (self) {
        _arguments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)description {
    if (self.typeModifier != nil) {
        return [NSString stringWithFormat:@"<%@: %p : type=%@, typeModifier=%@>", [self class], self, (self.type64 ? self.type64 : self.type), self.typeModifier];
    }
    else {
        return [NSString stringWithFormat:@"<%@: %p : type=%@>", [self class], self, (self.type64 ? self.type64 : self.type)];
    }
}


#pragma mark -
#pragma mark Arguments

- (NSArray *)arguments {
    return [_arguments copy];
}

- (void)setArguments:(NSArray *)arguments {
    [_arguments setArray:arguments];
}

- (void)addArgument:(MOBridgeSupportArgument *)argument {
    if (![_arguments containsObject:argument]) {
        [_arguments addObject:argument];
    }
}

- (void)removeArgument:(MOBridgeSupportArgument *)argument {
    if ([_arguments containsObject:argument]) {
        [_arguments removeObject:argument];
    }
}

@end


