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

@property (strong) NSMutableArray *textFields;

@end

@implementation COSAlertWindow

- (id)init {
	self = [super init];
	if (self != nil) {
		
        [self setAlert:[NSAlert new]];
        
	}
	return self;
}

- (void)addToTextFields:(NSTextField*)tf {
    
    if (!_textFields) {
        _textFields = [NSMutableArray array];
    }
    
    [_textFields addObject:tf];
}

- (void)addTextFieldWithValue:(NSString*)value {
    
    NSTextField *tf = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 24)];
    
    if (value) {
        [tf setStringValue:value];
    }
    
    [self addToTextFields:tf];
}

- (NSString*)textFieldAtIndex:(NSUInteger)idx {
    return [_textFields objectAtIndex:idx];
}

- (void)layout {
    
    if (!_textFields) {
        return;
    }
    
    CGFloat height = 0;
    NSView *sup = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 1)];
    
    for (NSTextField *tf in [_textFields reverseObjectEnumerator]) {
        
        NSRect currentFrame = [tf bounds];
        
        currentFrame.origin.y = height;
        
        height += currentFrame.size.height + 8;
        
        [tf setFrame:currentFrame];
        
        [sup addSubview:tf];
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
