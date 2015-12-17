//
//  COSGifAnimator.m
//  Cocoa Script
//
//  Created by August Mueller on 6/1/14.
//
//

#import "COSGifAnimator.h"

@implementation COSGifAnimator


- (void)mouseDown:(NSEvent *)event {
    /*
    [self pushContext];
        [_jstalk callJSFunction:[_mouseDown JSObject] withArgumentsInArray:[NSArray arrayWithObject:event]];
        [self popContext];
        [self setNeedsDisplay:YES];
    }
     */
}


- (void)drawInBlock:(MOJavaScriptObject*)drawFunction {
    
    COScript *cos = [COScript currentCOScript];
    
    CGFloat d = 1.0 / _fps;
    
    NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             (__bridge id)kCGImagePropertyGIFUnclampedDelayTime: @((float)d)
                                             }
                                     };
    
    NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: @((float)d), // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              (__bridge id)kCGImageDestinationLossyCompressionQuality: @(0.0)
                                              }
                                      };
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:@"/tmp/foo.gif"], kUTTypeGIF, _fps * _seconds, NULL);
    
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);

    
    CGColorSpaceRef cs = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGContextRef context = CGBitmapContextCreate(nil, _size.width, _size.height, 8, 0, cs, kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(cs);
    
    NSGraphicsContext *gc = [NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:gc];

    NSInteger count = _fps * _seconds;
    
    for (NSInteger i = 0; i < count; i++) {
        
        CGContextClearRect(context, CGRectMake(0, 0, _size.width, _size.height));
        
        [cos callJSFunction:[drawFunction JSObject] withArgumentsInArray:@[@(d * i)]];
        
        CGImageRef r = CGBitmapContextCreateImage(context);
        
        CGImageDestinationAddImage(destination, r, (__bridge CFDictionaryRef)frameProperties);
        
        CGImageRelease(r);

        
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    
    CFRelease(destination);
    
    
    
    [NSGraphicsContext restoreGraphicsState];
    CGContextRelease(context);
    
}


/*
 
 - (void)writeAnimatedGIFToPath:(NSString*)path {
 
 NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary: @{
 (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
 }
 };
 
 NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary: @{
 (__bridge id)kCGImagePropertyGIFDelayTime: @0.02f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
 }
 };
 
 NSUInteger frames = [[_baseGroup layers] count];
 
 CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:path], kUTTypeGIF, frames, NULL);
 CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
 
 for (NSUInteger i = 0; i < frames; i++) {
 @autoreleasepool {
 
 TSLayer *layer = [[_baseGroup layers] objectAtIndex:i];
 CGImageRef r = [layer newCGImageRefWithStyles:NO];
 
 CGImageDestinationAddImage(destination, r, (__bridge CFDictionaryRef)frameProperties);
 
 CGImageRelease(r);
 }
 }
 
 if (!CGImageDestinationFinalize(destination)) {
 NSLog(@"failed to finalize image destination");
 }
 
 CFRelease(destination);
 
 }*/
 
@end
