//
//  MOBlock.h
//  Mocha
//
//  Created by Logan Collins on 12/11/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


@class MOJavaScriptObject;


@interface MOBlock : NSObject

- (id)initWithJavaScriptObject:(MOJavaScriptObject *)object typeEncoding:(NSString *)typeEncoding;

@property (readonly) MOJavaScriptObject *javaScriptObject;
@property (readonly) NSString *typeEncoding;

@end
