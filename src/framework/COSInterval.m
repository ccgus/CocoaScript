//
//  COSInterval.m
//  Cocoa Script
//
//  Created by August Mueller on 11/21/13.
//
//

#import "COSInterval.h"

#pragma message "FIXME: This guy should be tied to the COScript class somehow - like adding a timer there.  Or at least add some sort of notification that gets sent out when the context is rerun, so that repeating intervals don't continue to happen again and again with each run... and then these guys can get dealloc'd somehow."


@implementation COSInterval

+ (id)scheduleWithRepeatingInterval:(NSTimeInterval)i jsFunction:(MOJavaScriptObject *)jsFunction {
    return [self scheduleWithInterval:i jsFunction:jsFunction repeat:YES];
}

+ (id)scheduleWithInterval:(NSTimeInterval)i jsFunction:(MOJavaScriptObject *)jsFunction {
    return [self scheduleWithInterval:i jsFunction:jsFunction repeat:NO];
}

+ (id)scheduleWithInterval:(NSTimeInterval)i jsFunction:(MOJavaScriptObject *)jsFunction repeat:(BOOL)repeat {
    
    COSInterval *interval = [[[self class] alloc] init];
    
    interval->_jsfunc = jsFunction;
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:i target:interval selector:@selector(timerHit:) userInfo:nil repeats:repeat];
    
    interval->_onshot = !repeat;
    
    interval->_timer = t;
    
    interval->_callingContext = [COScript currentCOScript];
    
    return interval;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cleanup {
    
    _jsfunc = nil;
    _callingContext = nil;
}

- (void)cancel {
    [_timer invalidate];
    _timer = nil;
    
    [self cleanup];
}

- (void)timerHit:(NSTimer*)timer {
    
    [_callingContext callJSFunction:[_jsfunc JSObject] withArgumentsInArray:@[self]];
    
    if (_onshot) {
        [self cancel];
    }
    
}

@end
