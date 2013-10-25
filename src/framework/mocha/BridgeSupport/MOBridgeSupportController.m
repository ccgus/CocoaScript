//
//  MOBridgeSupportController.m
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOBridgeSupportController.h"

#import "MOBridgeSupportLibrary.h"
#import "MOBridgeSupportSymbol.h"

#import "MOBridgeSupportParser.h"


@implementation MOBridgeSupportController {
    NSMutableArray *_loadedURLs;
    NSMutableArray *_loadedLibraries;
    NSMutableDictionary *_symbols;
    MOBridgeSupportParser *_parser;
}

+ (MOBridgeSupportController *)sharedController {
    static MOBridgeSupportController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

- (id)init {
    self = [super init];
    if (self) {
        _loadedURLs = [[NSMutableArray alloc] init];
        _loadedLibraries = [[NSMutableArray alloc] init];
        _symbols = [[NSMutableDictionary alloc] init];
        _parser = [[MOBridgeSupportParser alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Loading

- (BOOL)isBridgeSupportLoadedForURL:(NSURL *)aURL {
    return [_loadedURLs containsObject:aURL];
}

- (BOOL)loadBridgeSupportAtURL:(NSURL *)aURL error:(NSError **)outError {
    if ([self isBridgeSupportLoadedForURL:aURL]) {
        return YES;
    }
    
    MOBridgeSupportLibrary *library = [_parser libraryWithBridgeSupportURL:aURL error:outError];
    if (library == nil) {
        return NO;
    }
    
    [_loadedURLs addObject:aURL];
    [_loadedLibraries addObject:library];
    
    for (NSString *name in library.symbols) {
        MOBridgeSupportSymbol *symbol = [library.symbols objectForKey:name];
        if ([_symbols objectForKey:name] == nil) {
            [_symbols setObject:symbol forKey:name];
        }
        else {
            //NSLog(@"Symbol with name \"%@\" is already loaded.", name);
        }
    }
    
    return YES;
}


#pragma mark -
#pragma mark Queries

- (NSDictionary *)symbols {
    return _symbols;
}

- (NSDictionary *)performQueryForSymbolsOfType:(NSArray *)classes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[_symbols count]];
    for (NSString *key in _symbols) {
        MOBridgeSupportSymbol *symbol = [_symbols objectForKey:key];
        for (Class klass in classes) {
            if ([symbol isKindOfClass:klass]) {
                [dictionary setObject:symbol forKey:[symbol name]];
            }
        }
    }
    return dictionary;
}

- (id)performQueryForSymbolName:(NSString *)name {
    return [_symbols objectForKey:name];
}

- (id)performQueryForSymbolName:(NSString *)name ofType:(Class)klass {
    id symbol = [self performQueryForSymbolName:name];
    if ([symbol isKindOfClass:klass]) {
        return symbol;
    }
    return nil;
}

@end
