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

@interface COSInterval : NSObject {
    COScript *_callingContext;
    MOJavaScriptObject *_jsfunc;
    NSTimer *_timer;
    BOOL _onshot;
}

@end
