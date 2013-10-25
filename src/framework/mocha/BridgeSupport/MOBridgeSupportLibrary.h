//
//  MOBridgeSupportLibrary.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOBridgeSupportSymbol;


@interface MOBridgeSupportLibrary : NSObject

@property (copy) NSString *name;
@property (copy) NSURL *URL;

@property (copy) NSArray *dependencies;
- (void)addDependency:(NSString *)dependency;
- (void)removeDependency:(NSString *)dependency;

@property (copy) NSDictionary *symbols;
- (MOBridgeSupportSymbol *)symbolWithName:(NSString *)name;
- (void)setSymbol:(MOBridgeSupportSymbol *)symbol forName:(NSString *)name;
- (void)removeSymbolForName:(NSString *)name;

@end
