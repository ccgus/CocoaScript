//
//  COScript+Interval.m
//  Cocoa Script
//
//  Created by August Mueller on 11/21/13.
//
//

#import "COScript+Interval.h"
#import "COSInterval.h"

@implementation COScript (IntervalAdditions)

- (void)addInterval:(COSInterval*)i {
    
    if (!_intervals) {
        _intervals = [NSMutableArray array];
    }
    
    [_intervals addObject:i];
}

- (void)cleanupIntervals {
    
    for (COSInterval *i in _intervals) {
        [i cancel];
    }
    
    [_intervals removeAllObjects];
    
    _intervals = nil;
    
}

- (void)removeInterval:(COSInterval*)interval {
    
    if ([_intervals indexOfObject:interval] == NSNotFound) {
        NSLog(@"Could not remove interval %@ because it is not in %@'s interval stack.", interval, self);
        return;
    }
    
    debug(@"removing %@", interval);
    
    [_intervals removeObject:interval];
}

- (id)scheduleWithRepeatingInterval:(NSTimeInterval)i jsFunction:(MOJavaScriptObject *)jsFunction {
    
    COSInterval *cosi = [COSInterval scheduleWithInterval:i cocoaScript:self jsFunction:jsFunction repeat:YES];
    [self addInterval:cosi];
    
    return cosi;
}

- (id)scheduleWithInterval:(NSTimeInterval)i jsFunction:(MOJavaScriptObject *)jsFunction {
    
    COSInterval *cosi = [COSInterval scheduleWithInterval:i cocoaScript:self jsFunction:jsFunction repeat:NO];
    [self addInterval:cosi];
    
    return cosi;
}


@end
