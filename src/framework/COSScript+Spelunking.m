//
//  COSScript+Spelunking.m
//  Cocoa Script
//
//  Created by August Mueller on 11/29/13.
//
//

#import "COSScript+Spelunking.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/objc-runtime.h>
#import <OpenGL/OpenGL.h>
#include <OpenGL/gl.h>

@interface CIContext (TSAdditions) {
    
}

@end

@implementation CIContext (TSAdditions)

- (id)tsinitWithCGContext:(struct CGContext *)arg1 options:(id)ops{
    debug(@"%s:%d", __FUNCTION__, __LINE__);
    debug(@"ops: '%@'", ops);
	return [self tsinitWithCGContext:arg1 options:ops];
}

- (void)tsdrawImage:(CIImage *)im inRect:(CGRect)dest fromRect:(CGRect)src {
    
    
    int viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
    
    printf("----------------------------------\n");
    debug(@"viewport: %d %d %d %d", viewport[0], viewport[1], viewport[2], viewport[3]);
    
    debug(@"im: '%@'", im);
    debug(@"dest: %@", NSStringFromRect(dest));
    debug(@"src: %@", NSStringFromRect(src));
    [self tsdrawImage:im inRect:dest fromRect:src];
}


@end




@implementation COScript (SpelunkingAdditions)

+ (BOOL)insertInMainMenu {
    
    NSMenu *mainMenu = [NSApp mainMenu];
    
    NSMenuItem *mi = [[NSMenuItem alloc] init];
    NSMenu *submenu = [[NSMenu alloc] initWithTitle:@"Cocoa Script"];
    [mi setTitle:@"Cocoa Script"];
    [mi setSubmenu:submenu];
    
    // insert it before the Help menu.
    [mainMenu insertItem:mi atIndex:[[mainMenu itemArray] count] - 1];
    
    NSMenuItem *sItem = [submenu addItemWithTitle:@"Spelunk" action:@selector(cosShowSpelunker:) keyEquivalent:@""];
    
    [sItem setTarget:self];
    
    return YES;
}

+ (void)cosShowSpelunker:(id)sender {
    debug(@"%s:%d", __FUNCTION__, __LINE__);
    
    
    
}

+ (void)cosLogCIContextDrawImageInRectFromRect {
    
    method_exchangeImplementations(class_getInstanceMethod([CIContext class], @selector(drawImage:inRect:fromRect:)),
                                   class_getInstanceMethod([CIContext class], @selector(tsdrawImage:inRect:fromRect:)));
    
    
}

@end
