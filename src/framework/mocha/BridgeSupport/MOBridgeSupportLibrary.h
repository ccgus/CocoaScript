//
//  MOBridgeSupportLibrary.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOBridgeSupportSymbol.h"


@interface MOBridgeSupportLibrary : NSObject

@property (copy) NSString *name;
@property (copy) NSURL *URL;

@property (copy) NSArray *dependencies;
- (void)addDependency:(NSString *)dependency;
- (void)removeDependency:(NSString *)dependency;

- (NSDictionary *)symbolsWithName:(NSString *)name;
- (NSDictionary *)symbolsWithName:(NSString *)name types:(NSArray *)types;
- (NSDictionary *)symbolsOfType:(NSString *)type;
- (void)addSymbol:(MOBridgeSupportSymbol *)symbol;

@end
