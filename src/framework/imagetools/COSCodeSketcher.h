//
//  JSTCodeSketcher.h
//  ImageTools
//
//  Created by August Mueller on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaScript/COScript.h>
#import <CocoaScript/MOJavaScriptObject.h>

@interface COSCodeSketcher : NSView {
    
    COScript *_jstalk;
    
    MOJavaScriptObject *_drawRect;
    MOJavaScriptObject *_setup;
    MOJavaScriptObject *_mouseMoved;
    MOJavaScriptObject *_mouseUp;
    MOJavaScriptObject *_mouseDown;
    MOJavaScriptObject *_mouseDragged;
    
    CGFloat _frameRate;
    
    NSWindow *_mwindow;
    
    BOOL _flipped;
    
    NSString *_lookupName;
    
    NSTimer *_redrawTimer;
    
    CGContextRef _context;
    NSGraphicsContext *_nsContext;
    
    // Processing type stuff.
    NSPoint _mouseLocation;
    NSPoint _pmouseLocation;
    BOOL _mousePressed;
    NSSize _size;
    
    
}

@property (assign) CGFloat frameRate;
@property (retain) COScript *jstalk;
@property (assign) NSPoint mouseLocation;
@property (assign) NSPoint pmouseLocation;
@property (assign, getter=isMousePressed) BOOL mousePressed;
@property (retain) NSString *lookupName;
@property (retain) NSGraphicsContext *nsContext;
@property (assign) NSSize size;

@property (strong) MOJavaScriptObject *drawRect;
@property (strong) MOJavaScriptObject *setup;
@property (strong) MOJavaScriptObject *mouseMoved;
@property (strong) MOJavaScriptObject *mouseUp;
@property (strong) MOJavaScriptObject *mouseDown;
@property (strong) MOJavaScriptObject *mouseDragged;

- (void)stop;
- (void)start;

@end


@interface JSTFakePoint : NSObject {
    CGFloat _x;
    CGFloat _y;
}
@property (assign) CGFloat x;
@property (assign) CGFloat y;
@end

@interface JSTFakeSize : NSObject {
    CGFloat _width;
    CGFloat _height;
}
@property (assign) CGFloat width;
@property (assign) CGFloat height;
@end


@interface JSTFakeRect : NSObject {
    JSTFakePoint *_origin;
    JSTFakeSize *_size;
}
@property (retain) JSTFakePoint *origin;
@property (retain) JSTFakeSize *size;
+ (id)rectWithRect:(NSRect)rect;
@end

CGColorRef JSTCGColorCreateFromNSColor(NSColor *c);
