//
//  JSTFileWatcher.m
//  jstalk
//
//  Created by August Mueller on 3/15/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import "JSTFileWatcher.h"

@interface JSTFileWatcher (Private)
- (void)setupEventStreamRef;
@end



@implementation JSTFileWatcher


+ (id) fileWatcherWithPath:(NSString*)filePath delegate:(id)delegate {
    
    JSTFileWatcher *fw = [self new];
    
    fw.path = filePath;
    fw.delegate = delegate;
    
    [fw setupEventStreamRef];
    
    return fw;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (streamRef) {
        FSEventStreamStop(streamRef);
        FSEventStreamInvalidate(streamRef);
        FSEventStreamRelease(streamRef);
    }
    
}


static void fsevents_callback(FSEventStreamRef streamRef, JSTFileWatcher *fw, int numEvents, const char *const eventPaths[], const FSEventStreamEventFlags *eventMasks, const uint64_t *eventIDs)
{
    id delegate = [fw delegate];
    
    if (delegate && [delegate respondsToSelector:@selector(fileWatcherDidRecieveFSEvent:)]) {
        [delegate fileWatcherDidRecieveFSEvent:fw];
    }
    
}

- (void)setupEventStreamRef {
    
    FSEventStreamContext  context = {0, (__bridge void *)self, NULL, NULL, NULL};
    NSArray              *pathsToWatch = [NSArray arrayWithObject:[_path stringByDeletingLastPathComponent]];
    
    streamRef = FSEventStreamCreate(kCFAllocatorDefault,
                                    (FSEventStreamCallback)&fsevents_callback,
                                    &context,
                                    (CFArrayRef)CFBridgingRetain(pathsToWatch),
                                    kFSEventStreamEventIdSinceNow,
                                    2,
                                    0);
    
    FSEventStreamScheduleWithRunLoop(streamRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    
    FSEventStreamStart(streamRef);
    
}

@end

