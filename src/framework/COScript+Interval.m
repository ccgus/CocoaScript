//
//  COScript+Interval.m
//  Cocoa Script
//
//  Created by August Mueller on 11/21/13.
//
//

#import "COScript+Interval.h"
#import "COScript+Fiber.h"
#import "COSInterval.h"

@implementation COScript (IntervalAdditions)

- (id)scheduleWithRepeatingInterval:(NSTimeInterval)i jsFunction:(MOJavaScriptObject *)jsFunction {
    
    COSInterval *cosi = [COSInterval scheduleWithInterval:i cocoaScript:self jsFunction:jsFunction repeat:YES];
    [self addFiber:cosi];
    
    return cosi;
}

- (id)scheduleWithInterval:(NSTimeInterval)i jsFunction:(MOJavaScriptObject *)jsFunction {
    
    COSInterval *cosi = [COSInterval scheduleWithInterval:i cocoaScript:self jsFunction:jsFunction repeat:NO];
    [self addFiber:cosi];
    
    return cosi;
}

@end
