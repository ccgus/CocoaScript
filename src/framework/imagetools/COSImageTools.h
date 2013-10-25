//
//  JSTNSStringExtras.h
//  samplejstalkextra
//
//  Created by August Mueller on 3/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaScript/COScript.h>

@interface COSImageTools : NSObject {
    
}

@end

@interface JSTSimpleCIView : NSView {
    CIImage *_theImage;
}

@property (retain) CIImage *theImage;

@end

@interface NSImage (JSTExtras)
+ (id)imageWithSize:(NSSize)s;
@end