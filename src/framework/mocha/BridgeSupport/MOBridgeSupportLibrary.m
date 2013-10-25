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
    NSMutableDictionary *_symbols;
}

@synthesize name=_name;
@synthesize URL=_URL;

- (id)init {
    self = [super init];
    if (self) {
        _dependencies = [[NSMutableArray alloc] init];
        _symbols = [[NSMutableDictionary alloc] init];
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

- (NSDictionary *)symbols {
    return _symbols;
}

- (void)setSymbols:(NSDictionary *)symbols {
    [_symbols setDictionary:symbols];
}

- (MOBridgeSupportSymbol *)symbolWithName:(NSString *)name {
    return [_symbols objectForKey:name];
}

- (void)setSymbol:(MOBridgeSupportSymbol *)symbol forName:(NSString *)name {
    [_symbols setObject:symbol forKey:name];
}

- (void)removeSymbolForName:(NSString *)name {
    [_symbols removeObjectForKey:name];
}

@end
