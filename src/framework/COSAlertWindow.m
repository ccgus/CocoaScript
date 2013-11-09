//
//  COSAlertWindow.m
//  Cocoa Script
//
//  Created by August Mueller on 11/9/13.
//
//

#import "COSAlertWindow.h"

// NSAlert is not designed for subclassing.  So we wrap it instead

@interface COSAlertWindow ()

@property (strong) NSMutableArray *views;

@end

@implementation COSAlertWindow

- (id)init {
	self = [super init];
	if (self != nil) {
		
        [self setAlert:[NSAlert new]];
        
	}
	return self;
}

- (void)addAccessoryView:(NSView*)view {
    
    if (!_views) {
        _views = [NSMutableArray array];
    }
    
    [_views addObject:view];
}

- (void)addTextFieldWithValue:(NSString*)value {
    
    NSTextField *tf = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 24)];
    
    if (value) {
        [tf setStringValue:value];
    }
    
    [self addAccessoryView:tf];
}

- (NSString*)viewAtIndex:(NSUInteger)idx {
    return [_views objectAtIndex:idx];
}

- (void)layout {
    
    if (!_views) {
        return;
    }
    
    CGFloat height = 0;
    NSView *sup = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 1)];
    
    for (NSView *view in [_views reverseObjectEnumerator]) {
        
        NSRect currentFrame = [view bounds];
        
        currentFrame.origin.y = height;
        
        height += currentFrame.size.height + 8;
        
        [view setFrame:currentFrame];
        
        [sup addSubview:view];
    }
    
    NSRect viewFrame = [sup frame];
    viewFrame.size.height = height;
    
    [sup setFrame:viewFrame];
    
    
    [_alert setAccessoryView:sup];
}

- (NSModalResponse)runModal {
    [self layout];
    
    return [_alert runModal];
}

- (void)setMessageText:(NSString *)messageText {
    [_alert setMessageText:messageText];
}

- (void)setInformativeText:(NSString *)informativeText {
    [_alert setInformativeText:informativeText];
}

- (NSString *)messageText {
    return [_alert messageText];
}

- (NSString *)informativeText {
    return [_alert informativeText];
}

- (void)setIcon:(NSImage *)icon {
    [_alert setIcon:icon];
}

- (NSImage *)icon {
    return [_alert icon];
}

- (NSButton *)addButtonWithTitle:(NSString *)title {
    return [_alert addButtonWithTitle:title];
}

- (NSArray *)buttons {
    return [_alert buttons];
}

- (void)setShowsSuppressionButton:(BOOL)flag {
    [_alert setShowsSuppressionButton:flag];
}

- (BOOL)showsSuppressionButton {
    return [_alert showsSuppressionButton];
}

- (void)setAccessoryView:(NSView *)view {
    [_alert setAccessoryView:view];
}

- (NSView *)accessoryView {
    return [_alert accessoryView];
}



@end
