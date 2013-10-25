//
//  MOBridgeSupportParser.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOBridgeSupportLibrary;


@interface MOBridgeSupportParser : NSObject

- (MOBridgeSupportLibrary *)libraryWithBridgeSupportURL:(NSURL *)aURL error:(NSError **)outError;

@end
