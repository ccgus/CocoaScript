//
//  JSTCodeSketcher.m
//  ImageTools
//
//  Created by August Mueller on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "COSCodeSketcher.h"

@interface COScript (Private)

@end

@interface COSCodeSketcher()
- (void)setupWindow;
- (void)resizeContext;
@end

@implementation COSCodeSketcher

@synthesize jstalk = _jstalk;
@synthesize mouseLocation = _mouseLocation;
@synthesize pmouseLocation = _pmouseLocation;
@synthesize mousePressed = _mousePressed;
@synthesize lookupName = _lookupName;
@synthesize frameRate = _frameRate;
@synthesize nsContext = _nsContext;
@synthesize size = _size;

@synthesize drawRect = _drawRect;
@synthesize setup = _setup;
@synthesize mouseMoved = _mouseMoved;
@synthesize mouseUp = _mouseUp;
@synthesize mouseDown = _mouseDown;
@synthesize mouseDragged = _mouseDragged;

static NSMutableDictionary *JSTSketchers = nil;

+ (id)codeSketcherWithName:(NSString*)name {
    
    
    
    if (!JSTSketchers) {
        JSTSketchers = [NSMutableDictionary dictionary];
    }
    
    COSCodeSketcher *cs = [JSTSketchers objectForKey:name];
    
    if (!cs) {
        cs = [[COSCodeSketcher alloc] initWithFrame:NSMakeRect(0, 0, 10, 10)];
        [cs setLookupName:name];
        [JSTSketchers setObject:cs forKey:name];
    }
    
    [cs stop];
    
    [cs setJstalk:[COScript currentCOScript]];
    
    dispatch_async(dispatch_get_main_queue(),^ {
        [cs start];
    });
    
    return cs;
}


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _flipped = YES;
        _size = NSMakeSize(400, 800);
    }
    return self;
}


- (void)dealloc {
    debug(@"%s:%d", __FUNCTION__, __LINE__);
    if (_context) {
        CGContextRelease(_context);
    }
}

- (void)resizeContext {
    
    NSSize mySize = [self bounds].size;
    
    if (_context) {
        
        if (CGBitmapContextGetWidth(_context) == mySize.width && CGBitmapContextGetHeight(_context) == mySize.height) {
            return;
        }
        
        CGContextRelease(_context);
    }
    
    CGColorSpaceRef cs = [[[NSScreen mainScreen] colorSpace] CGColorSpace];
    // using float components because it helps with premultiplication.
    _context = CGBitmapContextCreate(nil, mySize.width, mySize.height, 32, 0, cs, kCGBitmapFloatComponents | kCGImageAlphaPremultipliedLast);
    
    [self setNsContext:[NSGraphicsContext graphicsContextWithGraphicsPort:_context flipped:_flipped]];
    
}

- (void)stop {
    
    [_redrawTimer invalidate];
    _redrawTimer = nil;
    
    _drawRect = nil;
    
    _setup = nil;
    
    _mouseMoved = nil;
    
    _mouseUp = nil;
    
    _mouseDown = nil;
    
    _mouseDragged = nil;
}

- (void)start {
    
    if (_setup) {
        [_jstalk callJSFunction:[_setup JSObject] withArgumentsInArray:nil];
    }
    
    [self setupWindow];
    
    NSSize newSize = [_mwindow frameRectForContentRect:NSMakeRect(0, 0, _size.width, _size.height)].size;
    
    NSRect newFrame = [_mwindow frame];
    newFrame.size = newSize;
    
    [_mwindow setFrame:newFrame display:YES];
    
    [self resizeContext];
    
    [self setNeedsDisplay:YES];
    
    if (_frameRate > 60) {
        _frameRate = 60;
        NSLog(@"FPS set too high, limiting to 60");
    }
    
    if (_frameRate > 0) {
        _redrawTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / _frameRate) target:self selector:@selector(fpsTimerHit:) userInfo:nil repeats:YES];
    }
}

- (void)fpsTimerHit:(NSTimer*)timer {
    [self setNeedsDisplay:YES];
}

- (void)setupWindow {
    if (!_mwindow) {
        
        CGFloat bottomBorderHeight = 20;
        
        NSRect winRect = NSMakeRect(0, 0, _size.width, _size.height);
        NSRect extent = winRect;
        
        winRect.size.height += bottomBorderHeight;
        
        
        _mwindow = [[NSWindow alloc] initWithContentRect:winRect
                                         styleMask:NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask
                                           backing:NSBackingStoreBuffered
                                             defer:NO];
        
        [_mwindow center];
        [_mwindow setShowsResizeIndicator:YES];
        [_mwindow makeKeyAndOrderFront:self];
        [_mwindow setReleasedWhenClosed:YES]; // we retain it in the dictionary.
        [_mwindow setContentBorderThickness:bottomBorderHeight forEdge:NSMinYEdge];
        [_mwindow setPreferredBackingLocation:NSWindowBackingLocationMainMemory];
        
        
        [_mwindow setAcceptsMouseMovedEvents:YES];
        
        extent.origin.y += bottomBorderHeight;
        [self setFrame:extent];
        
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        [[_mwindow contentView] addSubview:self];
        [_mwindow setTitle:_lookupName];
        
        [_mwindow makeFirstResponder:self];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification object:_mwindow queue:nil usingBlock:^(NSNotification *arg1) {
            
            dispatch_async(dispatch_get_main_queue(),^ {
                [JSTSketchers removeObjectForKey:[self lookupName]];
                debug(@"done?");
            });
        }];
        
        NSPoint p = [NSEvent mouseLocation];
        
        p = [_mwindow convertScreenToBase:p];
        _mouseLocation = [self convertPoint:p fromView:nil];
    }
}


- (void)pushContext {
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:_nsContext];
    CGContextSaveGState(_context);
}

- (void)popContext {
    CGContextRestoreGState(_context);
    [NSGraphicsContext restoreGraphicsState];
}

- (void)drawRect:(NSRect)dirtyRect {
    
    if (!_context) {
        [self resizeContext];
    }
    
    if (_drawRect) {
        [self pushContext];
        
        [_jstalk callJSFunction:[_drawRect JSObject] withArgumentsInArray:nil];
        [self popContext];
    }
    
    CGContextRef screenContext = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGImageRef img = CGBitmapContextCreateImage(_context);
    CGContextDrawImage(screenContext, CGRectMake(0, 0, CGImageGetWidth(img), CGImageGetHeight(img)), img);
    CGImageRelease(img);
}

- (void)viewDidEndLiveResize {
    [self resizeContext];
    [self setNeedsDisplay:YES];
}



- (void)mouseDown:(NSEvent *)event {
    
    _mousePressed = YES;
    
    _pmouseLocation = _mouseLocation;
    _mouseLocation = [self convertPoint:[event locationInWindow] fromView:nil];;
    
    if (_mouseDown) {
        [self pushContext];
        [_jstalk callJSFunction:[_mouseDown JSObject] withArgumentsInArray:[NSArray arrayWithObject:event]];
        [self popContext];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseUp:(NSEvent *)event {
    _mousePressed = NO;
    _pmouseLocation = _mouseLocation;
    _mouseLocation = [self convertPoint:[event locationInWindow] fromView:nil];
    
    if (_mouseUp) {
        [self pushContext];
        [_jstalk callJSFunction:[_mouseUp JSObject] withArgumentsInArray:[NSArray arrayWithObject:event]];
        [self popContext];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseDragged:(NSEvent *)event {
    
    _pmouseLocation = _mouseLocation;
    _mouseLocation = [self convertPoint:[event locationInWindow] fromView:nil];
    
    if (_mouseDragged) {
        [self pushContext];
        [_jstalk callJSFunction:[_mouseDragged JSObject] withArgumentsInArray:[NSArray arrayWithObject:event]];
        [self popContext];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseMoved:(NSEvent *)event {
    
    _pmouseLocation = _mouseLocation;
    _mouseLocation = [self convertPoint:[event locationInWindow] fromView:nil];
    
    if (_mouseMoved) {
        [self pushContext];
        [_jstalk callJSFunction:[_mouseMoved JSObject] withArgumentsInArray:[NSArray arrayWithObject:event]];
        [self popContext];
        [self setNeedsDisplay:YES];
    }
    
}

- (BOOL)isFlipped {
    return _flipped;
}

- (void)setFlipped:(BOOL)flag {
    _flipped = flag;
}

- (void)translateX:(CGFloat)x Y:(CGFloat)y {
    
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextTranslateCTM(ctx, x, y);
}


- (void)copy:(id)sender {
    
    NSImage *img = [[NSImage alloc] initWithSize:[self bounds].size];
    [img lockFocus];
    
    [self drawRect:[self bounds]];
    
    [img unlockFocus];
    
    NSPasteboard *pboard = [NSPasteboard generalPasteboard];
    [pboard declareTypes:[NSArray arrayWithObjects:(id)kUTTypeTIFF, nil] owner:nil];
    
    [pboard setData:[img TIFFRepresentation] forType:(id)kUTTypeTIFF];
}

- (CGContextRef)context {
    if (!_context) {
        [self resizeContext];
    }
    
    return _context;
}

- (void)fillWithColor:(NSColor*)color {
    
    [color set];
    NSRectFillUsingOperation([self bounds], NSCompositeSourceOver);
    
    /*
    CGContextSaveGState([self context]);
    
    CGColorRef c = JSTCGColorCreateFromNSColor(color);
    
    CGContextSetFillColorWithColor([self context], c);
    
    CGColorRelease(c);
    
    CGContextFillRect([self context], [self bounds]);
    
    CGContextRestoreGState([self context]);
    */
}

- (void)clear {
    CGContextClearRect([self context], [self bounds]);
}

- (void)update {
    [self setNeedsDisplay:YES];
}

- (void)sketcherWhatever:(id)ctx {
    debug(@"ctx: %@", ctx);
}

@end





@implementation JSTFakePoint

@synthesize x = _x;
@synthesize y = _y;

@end

@implementation JSTFakeSize

@synthesize width = _width;
@synthesize height = _height;

@end

@implementation JSTFakeRect

@synthesize origin = _origin;
@synthesize size = _size;

+ (id)rectWithRect:(NSRect)rect {
    
    JSTFakeRect *r = [JSTFakeRect new];
    
    r.origin.x      = rect.origin.x;
    r.origin.y      = rect.origin.y;
    r.size.width    = rect.size.width;
    r.size.height   = rect.size.height;
    
    return r;
}

@end



CGColorRef JSTCGColorCreateFromNSColor(NSColor *c) {
    CGColorSpaceRef colorSpace = [[c colorSpace] CGColorSpace];
    NSInteger componentCount = [c numberOfComponents];
    CGFloat *components = (CGFloat *)calloc(componentCount, sizeof(CGFloat));
    [c getComponents:components];
    CGColorRef color = CGColorCreate(colorSpace, components);
    free((void*)components);
    return color;
}
