//
//  COSInterval.h
//  Cocoa Script
//
//  Created by August Mueller on 11/21/13.
//
//

#import <Foundation/Foundation.h>

#import "MOJavaScriptObject.h"
#import <CocoaScript/COScript.h>
#import "COSFiber.h"

@interface COSInterval : COSFiber {
    
    NSTimer *_timer;
    BOOL _onshot;
}

@property (strong) MOJavaScriptObject *jsfunc;

+ (id)scheduleWithInterval:(NSTimeInterval)i cocoaScript:(COScript*)cos jsFunction:(MOJavaScriptObject *)jsFunction repeat:(BOOL)repeat;
- (void)cancel;

@end
