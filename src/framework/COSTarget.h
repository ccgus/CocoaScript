//
//  COSTarget.h
//  Cocoa Script
//
//  Created by Abhi Beckert on 13/11/2013.
//
//

#import <Foundation/Foundation.h>
#import "MOJavaScriptObject.h"
#import <CocoaScript/COScript.h>

@interface COSTarget : NSObject

@property (strong) MOJavaScriptObject *jsFunction;
@property NSUInteger callCount;

+ (instancetype)targetWithJSFunction:(MOJavaScriptObject *)jsFunction;

- (instancetype)initWithJSFunction:(MOJavaScriptObject *)jsFunction;

- (void)callAction:(id)sender;

- (SEL)action;

@end

@interface NSObject (COSTargetAdditions)

- (void)setCOSJSTargetFunction:(MOJavaScriptObject *)jsFunction;

@end

