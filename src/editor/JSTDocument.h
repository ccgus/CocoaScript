//
//  JSTDocument.h
//  JSTalk
//
//  Created by August Mueller on 1/14/09.
//  Copyright Flying Meat Inc 2009 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "JSTTextView.h"
#import "JSTFileWatcher.h"

#define JSC_OBJC_API_ENABLED 1

//@import JavaScriptCore;

#import <JavaScriptCore/JSBase.h>
#import <JavaScriptCore/JSContext.h>
#import <JavaScriptCore/JSExport.h>

@protocol JSTDocumentScriptMethods <JSExport>
- (void)print:(id)f;
@end


@interface JSTDocument : NSDocument <NSToolbarDelegate, JSTDocumentScriptMethods> {
    IBOutlet JSTTextView *jsTextView;
    IBOutlet NSTextView *outputTextView;
    IBOutlet NSSplitView *splitView;
    IBOutlet NSTextField *errorLabel;
    
	//NoodleLineNumberView	*lineNumberView;
    //TDTokenizer *_tokenizer;
    //NSDictionary *_keywords;
    
    NSMutableDictionary *_toolbarItems;
    
    JSTFileWatcher *_externalEditorFileWatcher;
    
    NSDictionary *_previousOutputTypingAttributes;
}

@property (retain) JSTFileWatcher *externalEditorFileWatcher;
@property (retain) NSDictionary *previousOutputTypingAttributes;
@property (assign) BOOL shouldCleanupAfterRun;

- (void) executeScript:(id)sender;
- (void) clearConsole:(id)sender;

@end


NSToolbarItem *JSTAddToolbarItem(NSMutableDictionary *theDict,
                                 NSString *identifier,
                                 NSString *label,
                                 NSString *paletteLabel,
                                 NSString *toolTip,
                                 id target,
                                 SEL settingSelector,
                                 id itemContent,
                                 SEL action, 
                                 NSMenu * menu);

