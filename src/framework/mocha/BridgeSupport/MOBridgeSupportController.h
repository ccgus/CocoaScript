//
//  MOBridgeSupportController.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOBridgeSupportSymbol;


@interface MOBridgeSupportController : NSObject

+ (MOBridgeSupportController *)sharedController;

- (BOOL)isBridgeSupportLoadedForURL:(NSURL *)aURL;
- (BOOL)loadBridgeSupportAtURL:(NSURL *)aURL error:(NSError **)outError;

- (NSDictionary *)symbolsOfType:(Class)type;
- (NSDictionary *)symbolsWithName:(NSString *)name types:(NSArray *)types;
- (id)symbolWithName:(NSString *)name type:(Class)type;

@end
