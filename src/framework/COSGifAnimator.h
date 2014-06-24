//
//  COSGifAnimator.h
//  Cocoa Script
//
//  Created by August Mueller on 6/1/14.
//
//

#import <Foundation/Foundation.h>
#import <CocoaScript/COScript.h>
#import <CocoaScript/MOJavaScriptObject.h>

@interface COSGifAnimator : NSObject {
    COScript *_jstalk;
}


@property (assign) CGFloat fps;
@property (assign) CGFloat seconds;
@property (assign) NSSize size;


@end
