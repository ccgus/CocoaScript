//
//  JSTListener.m
//  jstalk
//
//  Created by August Mueller on 1/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import "COSListener.h"

@interface COSListener (Private)
- (void)setupListener;
@end


@implementation COSListener

@synthesize rootObject=_rootObject;

+ (id)sharedListener {
    static COSListener *me = nil;
    if (!me) {
        me = [[COSListener alloc] init];
    }
    
    return me;
}

+ (void)listen {
    [[self sharedListener] setupListener];
}

+ (void)listenWithRootObject:(id)rootObject; {
    ((COSListener*)[self sharedListener]).rootObject = rootObject;
    [self listen];
}


- (void)setupListener {
    NSString *myBundleId    = [[NSBundle mainBundle] bundleIdentifier];
    NSString *port          = [NSString stringWithFormat:@"%@.JSTalk", myBundleId];
    
    _conn = [[NSConnection alloc] init];
    // Pick your poision:
    // "Without Independent Conversation Queueing, your app will be re-entered during upon a 2nd remote DO call if you return to the run loop"
    // http://www.mac-developer-network.com/shows/podcasts/lnc/lnc020/
    // "Because independent conversation queueing causes remote messages to block where they normally do not, it can cause deadlock to occur between applications."
    // http://developer.apple.com/documentation/Cocoa/Conceptual/DistrObjects/Tasks/configuring.html#//apple_ref/doc/uid/20000766
    // We'll go with ICQ for now.
    [_conn setIndependentConversationQueueing:YES]; 
    [_conn setRootObject:_rootObject ? _rootObject : NSApp];
    
    if ([_conn registerName:port]) {
        //NSLog(@"JSTalk listening on port %@", port);
    }
    else {
        NSLog(@"CocoaScript could not listen on port %@", port);
        _conn = nil;
    }
}

@end
