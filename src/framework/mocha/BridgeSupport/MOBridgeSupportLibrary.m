//
//  MOBridgeSupportLibrary.m
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOBridgeSupportLibrary.h"


@implementation MOBridgeSupportLibrary {
    NSMutableArray *_dependencies;
    NSMutableDictionary *_symbolsByType;
}

- (id)init {
    self = [super init];
    if (self) {
        _dependencies = [[NSMutableArray alloc] init];
        _symbolsByType = [[NSMutableDictionary alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Dependencies

- (NSArray *)dependencies {
    return _dependencies;
}

- (void)setDependencies:(NSArray *)dependencies {
    [_dependencies setArray:dependencies];
}

- (void)addDependency:(NSString *)dependency {
    if (![_dependencies containsObject:dependency]) {
        [_dependencies addObject:dependency];
    }
}

- (void)removeDependency:(NSString *)dependency {
    if ([_dependencies containsObject:dependency]) {
        [_dependencies removeObject:dependency];
    }
}


#pragma mark -
#pragma mark Symbols

- (NSDictionary *)symbolsWithName:(NSString *)name {
    return [self symbolsWithName:name types:nil];
}

- (NSDictionary *)symbolsWithName:(NSString *)name types:(NSArray *)types {
    if (types == nil) {
        types = [_symbolsByType allKeys];
    }
    
    NSMutableDictionary *symbols = [NSMutableDictionary dictionaryWithCapacity:[_symbolsByType count]];
    
    for (NSString *className in types) {
        NSDictionary *typeSymbols = _symbolsByType[className];
        MOBridgeSupportSymbol *symbol = [typeSymbols objectForKey:name];
        if (symbol != nil) {
            [symbols setObject:symbol forKey:className];
        }
    }
    
    return symbols;
}

- (NSDictionary *)symbolsOfType:(NSString *)type {
    return [_symbolsByType objectForKey:type];
}

- (void)addSymbol:(MOBridgeSupportSymbol *)symbol {
    NSString *name = symbol.name;
    
    NSMutableDictionary *symbolSet = [_symbolsByType objectForKey:NSStringFromClass([symbol class])];
    if (symbolSet == nil) {
        symbolSet = [NSMutableDictionary dictionary];
        [_symbolsByType setObject:symbolSet forKey:NSStringFromClass([symbol class])];
    }
    
    [symbolSet setObject:symbol forKey:name];
}

@end
