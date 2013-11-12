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

@property (strong) MOJavaScriptObject *action;
@property NSUInteger callCount;

+ (instancetype)targetWithAction:(MOJavaScriptObject *)action;

- (instancetype)initWithAction:(MOJavaScriptObject *)action;

- (void)callAction:(id)sender;

@end
