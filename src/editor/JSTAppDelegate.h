//
//  JSTAppDelegate.h
//  jstalk
//
//  Created by August Mueller on 1/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JSTAppDelegate : NSObject {
    IBOutlet NSPanel *prefsWindow;
    IBOutlet NSTextField *externalEditorField;
    IBOutlet NSTextField *prefsFontField;
    
    
    IBOutlet NSMenu         *statusMenu;
    NSStatusItem            *statusItem;
    NSString                *_serviceError;
}

- (void)chooseExternalEditor:(id)sender;
- (void)prefsChoosefont:(id)sender;

- (NSFont*)defaultEditorFont;
- (void)setDefaultEditorFont:(NSFont*)f;

@end
