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

#import "NSArray+MochaAdditions.h"


@implementation MOBridgeSupportController {
    NSMutableArray *_loadedURLs;
    NSMutableArray *_loadedLibraries;
    NSLock *_loadedLibrariesLock;
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
        _loadedLibrariesLock = [[NSLock alloc] init];
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
    
    [_loadedLibrariesLock lock];
    [_loadedURLs addObject:aURL];
    [_loadedLibraries addObject:library];
    [_loadedLibrariesLock unlock];
    
    return YES;
}


#pragma mark -
#pragma mark Queries

- (NSDictionary *)symbolsOfType:(Class)type {
    NSMutableDictionary *symbols = [NSMutableDictionary dictionary];
    
    [_loadedLibrariesLock lock];
    NSArray *loadedLibraries = [_loadedLibraries copy];
    [_loadedLibrariesLock unlock];
    
    for (MOBridgeSupportLibrary *library in loadedLibraries) {
        NSDictionary *librarySymbols = [library symbolsOfType:NSStringFromClass(type)];
        [symbols addEntriesFromDictionary:librarySymbols];
    }
    
    return symbols;
}

- (NSDictionary *)symbolsWithName:(NSString *)name types:(NSArray *)types {
    NSMutableDictionary *symbols = [NSMutableDictionary dictionary];
    
    [_loadedLibrariesLock lock];
    NSArray *loadedLibraries = [_loadedLibraries copy];
    [_loadedLibrariesLock unlock];
    
    for (MOBridgeSupportLibrary *library in loadedLibraries) {
        NSDictionary *librarySymbols = [library symbolsWithName:name types:[types mo_objectsByApplyingBlock:^id(id obj, NSUInteger idx, BOOL *stop) {
            return NSStringFromClass(obj);
        }]];
        [symbols addEntriesFromDictionary:librarySymbols];
    }
    
    return symbols;
}

- (id)symbolWithName:(NSString *)name type:(Class)type {
    [_loadedLibrariesLock lock];
    NSArray *loadedLibraries = [_loadedLibraries copy];
    [_loadedLibrariesLock unlock];
    
    for (MOBridgeSupportLibrary *library in loadedLibraries) {
        NSDictionary *symbols = [library symbolsWithName:name types:@[NSStringFromClass(type)]];
        if ([symbols count] > 0) {
            return [symbols objectForKey:NSStringFromClass(type)];
        }
    }
    
    return nil;
}

@end
