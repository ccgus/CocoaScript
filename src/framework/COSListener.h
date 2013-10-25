//
//  JSTListener.h
//  jstalk
//
//  Created by August Mueller on 1/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface COSListener : NSObject {
    
    CFMessagePortRef messagePort;
    
    NSConnection *_conn;
    
    __unsafe_unretained id _rootObject;
    
}

@property (assign) id rootObject;

+ (COSListener*)sharedListener;

+ (void)listen;
+ (void)listenWithRootObject:(id)rootObject;

@end
