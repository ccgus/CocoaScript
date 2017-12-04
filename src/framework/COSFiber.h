//
//  COSFiber.h
//  Cocoa Script
//
//  Created by Mathieu Dutour on 12/04/17.
//
//

#import <Foundation/Foundation.h>

#import "MOJavaScriptObject.h"
#import <CocoaScript/COScript.h>

@interface COSFiber : NSObject

@property (weak) COScript *coscript;
@property (strong) MOJavaScriptObject *cleanUpJSfunc;

+ (id)createWithCocoaScript:(COScript*)cos;
- (void)onCleanup:(MOJavaScriptObject *)jsFunction;
- (void)cleanup;

@end

