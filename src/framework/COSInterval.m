//
//  COSInterval.m
//  Cocoa Script
//
//  Created by August Mueller on 11/21/13.
//
//

#import "COSInterval.h"
#import "COScript+Interval.h"
@implementation COSInterval

+ (id)scheduleWithInterval:(NSTimeInterval)i cocoaScript:(COScript*)cos jsFunction:(MOJavaScriptObject *)jsFunction repeat:(BOOL)repeat {
    
    COSInterval *interval = [[[self class] alloc] init];
    
    [interval setJsfunc:jsFunction];
    [interval setCoscript:cos];
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:i target:interval selector:@selector(timerHit:) userInfo:nil repeats:repeat];
    
    interval->_onshot = !repeat;
    
    interval->_timer = t;
    
    return interval;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cleanup {
    
    [_coscript removeInterval:self];
    
    _jsfunc = nil;
    _coscript = nil;
}

- (void)cancel {
    [_timer invalidate];
    _timer = nil;
    
    [self cleanup];
}

- (void)timerHit:(NSTimer*)timer {
    
    [_coscript callJSFunction:[_jsfunc JSObject] withArgumentsInArray:@[self]];
    
    if (_onshot) {
        [self cancel];
    }
    
}

@end
