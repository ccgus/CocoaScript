//
//  JSTDocument.m
//  JSTalk
//
//  Created by August Mueller on 1/14/09.
//  Copyright Flying Meat Inc 2009 . All rights reserved.
//

#import "JSTDocument.h"
#import "JSTAppDelegate.h"
#import "COSListener.h"
#import "COScript.h"
#import "COSPreprocessor.h"

@interface JSTDocument (SuperSecretItsPrivateDontEvenThinkOfUsingTheseMethodsOutsideThisClass)
- (void)updateFont:(id)sender;
@end


@implementation JSTDocument
@synthesize externalEditorFileWatcher=_externalEditorFileWatcher;
@synthesize previousOutputTypingAttributes=_previousOutputTypingAttributes;

- (id)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFont:) name:@"JSTFontChangeNotification" object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)autosavesInPlace {
    // defaults write org.jstalk.JSTalkEditor autosavesInPlace 1
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"autosavesInPlace"];
}

- (NSString *)windowNibName {
    return @"JSTDocument";
}

- (void)readFromFile:(NSURL*)fileURL {
    
    NSError *err = nil;
    NSString *src = [NSString stringWithContentsOfURL:[self fileURL] encoding:NSUTF8StringEncoding error:&err];
    
    if (err) {
        NSBeep();
        NSLog(@"err: %@", err);
    }
    
    if (src) {
        [[[jsTextView textStorage] mutableString] setString:src];
    }
    
    [[[[self windowControllers] objectAtIndex:0] window] setFrameAutosaveName:[[self fileURL] path]];
    [splitView setAutosaveName:[[self fileURL] path]];
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController {
    [super windowControllerDidLoadNib:aController];
    
    if ([self fileURL]) {
        [self readFromFile:[self fileURL]];
    }
    
    NSToolbar *toolbar  = [[NSToolbar alloc] initWithIdentifier:@"JSTalkDocument"];
    _toolbarItems       = [NSMutableDictionary dictionary];
    
    JSTAddToolbarItem(_toolbarItems, @"Run", @"Run", @"Run", @"Run the script", nil, @selector(setImage:), [NSImage imageNamed:@"Play.tiff"], @selector(executeScript:), nil);
    JSTAddToolbarItem(_toolbarItems, @"Clear", @"Clear", @"Clear", @"Clear the console", nil, @selector(setImage:), [NSImage imageNamed:@"Clear.tiff"], @selector(clearConsole:), nil);
    
    [toolbar setDelegate:self];
    [toolbar setAllowsUserCustomization:YES];
    [toolbar setAutosavesConfiguration:YES];
    
    [[splitView window] setToolbar:toolbar];
    
    [[splitView window] setContentBorderThickness:NSMinY([splitView frame]) forEdge:NSMinYEdge];
    
    [errorLabel setStringValue:@""];
    
    [self updateFont:nil];
	
    __weak __typeof__(self) weakSelf = self;
    [jsTextView setNumberDragHandler:^(NSTextView *textView, NSString *updatedLine) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf executeScript:weakSelf];
        });
    }];
    
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    
    NSData *d = [[[jsTextView textStorage] string] dataUsingEncoding:NSUTF8StringEncoding];
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    
	return d;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    
    // our data is loaded up from windowControllerDidLoadNib, as well as here.
    // revert to saved will call readFromData:, and we'll check and see if we have
    // a UI element to put our file in, and then revert it to what's saved on disk.
    // does that make sense?  prolly not.
    
    if (jsTextView && [self fileURL]) {
        [self readFromFile:[self fileURL]];
    }
    
    return YES;
}

- (void)print:(NSString*)s {
    
    BOOL needToSetAtts = [[outputTextView textStorage] length] == 0;
    
    [[[outputTextView textStorage] mutableString] appendFormat:@"%@\n", s];
    
    if (needToSetAtts) {
        [[outputTextView textStorage] setAttributes:_previousOutputTypingAttributes range:NSMakeRange(0, [[outputTextView textStorage] length])];
        // this doesn't always work:
        // [outputTextView setTypingAttributes:_previousOutputTypingAttributes];
    }
    
}

- (void)JSTalk:(COScript*)jstalk hadError:(NSString*)error onLineNumber:(NSInteger)lineNumber atSourceURL:(id)url {
    
    if (!error) {
        return;
    }
    
    if (lineNumber < 0) {
        [errorLabel setStringValue:error];
    }
    else {
        [errorLabel setStringValue:[NSString stringWithFormat:@"Line %ld, %@", lineNumber, error]];
        
        NSUInteger lineIdx = 0;
        NSRange lineRange  = NSMakeRange(0, 0);
        
        while (lineIdx < lineNumber) {
            
            lineRange = [[[jsTextView textStorage] string] lineRangeForRange:NSMakeRange(NSMaxRange(lineRange), 0)];
            lineIdx++;
        }
        
        if (lineRange.length) {
            [jsTextView showFindIndicatorForRange:lineRange];
        }
    }
}

- (void)runScript:(NSString*)s {
    
    COScript *jstalk = [[COScript alloc] init];
    
    [[[NSThread currentThread] threadDictionary] setObject:jstalk forKey:@"org.jstalk.currentJSTalkContext"];
    
    [jstalk setPrintController:self];
    [jstalk setErrorController:self];
    
    [errorLabel setStringValue:@""];
    
    if ([self fileURL]) {
        [jstalk.env setObject:[self fileURL] forKey:@"scriptURL"];
    }
    
    if ([JSTPrefs boolForKey:@"clearConsoleOnRun"]) {
        [self clearConsole:nil];
    }
    
    id result = [jstalk executeString:s];
    
    if (result) {
        [self print:[result description]];
    }
    
    [[[NSThread currentThread] threadDictionary] removeObjectForKey:@"org.jstalk.currentJSTalkContext"];
    
    
    if ([jstalk hasFunctionNamed:@"fmain"]) {
        debug(@"HEY THERE'S A MAIN FUNCTION.");
        [jstalk callFunctionNamed:@"fmain" withArguments:nil];
    }
}

- (void)executeScript:(id)sender {
    [self runScript:[[jsTextView textStorage] string]];
}

- (void)clearConsole:(id)sender {
    
    // NSTextView hates it when there is no string to store attributes on, and -[outputTextView typingAttributes] doesn't always work.
    if ([[outputTextView textStorage] length]) {
        self.previousOutputTypingAttributes = [[outputTextView textStorage] attributesAtIndex:0 effectiveRange:nil];
    }
    
    [[[outputTextView textStorage] mutableString] setString:@""];
}

- (void)executeSelectedScript:(id)sender {
    
    NSRange r = [jsTextView selectedRange];
    
    if (r.length == 0) {
        r = NSMakeRange(0, [[jsTextView textStorage] length]);
    }
    
    NSString *s = [[[jsTextView textStorage] string] substringWithRange:r];
    
    [self runScript:s];
    
}

- (void)preprocessCodeAction:(id)sender {
    
    NSString *code = [COSPreprocessor preprocessCode:[[jsTextView textStorage] string]];
    
    [[[outputTextView textStorage] mutableString] setString:code];
    
    if (_previousOutputTypingAttributes) {
        [outputTextView setTypingAttributes:_previousOutputTypingAttributes];
    }
}


- (void)saveAsApplication:(id)sender {
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    
    NSString *appName = @"";
    
    if ([self lastComponentOfFileName]) {
        appName = [NSString stringWithFormat:@"%@.app", [[self lastComponentOfFileName] stringByDeletingPathExtension]];
    }
    
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"app"]];
    
    [savePanel beginSheetModalForWindow:[splitView window] completionHandler:^(NSInteger result) {
        
        if (!result) {
            return;
        }
        
        NSString *fileName = [[savePanel URL] path];
        if (!fileName) {
            return;
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            if (![[NSFileManager defaultManager] removeItemAtPath:fileName error:nil]) {
                NSRunAlertPanel(@"Could not remove file", @"Sorry, but I could not remove the old file in order to save your application.", @"OK", nil, nil);
                NSBeep();
                return;
            }
        }
        
        NSString *runnerPath = [[NSBundle mainBundle] pathForResource:@"JSTalkRunner" ofType:@"app"];
        
        if (![[NSFileManager defaultManager] copyItemAtPath:runnerPath toPath:fileName error:nil]) {
            NSRunAlertPanel(@"Could not save", @"Sorry, but I could not save the application to the folder", @"OK", nil, nil);
            return;
        }
        
        NSString *sourcePath = [[[fileName stringByAppendingPathComponent:@"Contents"]
                                 stringByAppendingPathComponent:@"Resources"]
                                stringByAppendingPathComponent:@"main.jstalk"];
        
        NSURL *sourceURL = [NSURL fileURLWithPath:sourcePath];
        NSError *err = nil;
        [[[jsTextView textStorage] string] writeToURL:sourceURL atomically:NO encoding:NSUTF8StringEncoding error:&err];
        
        if (err) {
            NSLog(@"err: %@", err);
        }
    }];
    
    
}

- (void)updateFont:(id)sender {
    
    [[jsTextView textStorage] addAttribute:NSFontAttributeName value:[[NSApp delegate] defaultEditorFont] range:NSMakeRange(0, [[jsTextView textStorage] length])];
    [[outputTextView textStorage] addAttribute:NSFontAttributeName value:[[NSApp delegate] defaultEditorFont] range:NSMakeRange(0, [[outputTextView textStorage] length])];
    
    
}

- (void)externalEditorAction:(id)sender {
    
    if (_externalEditorFileWatcher) {
        /// wait, what?  Should we care?
        _externalEditorFileWatcher = nil;
    }
    
    if (![self fileURL]) {
        [self saveDocument:self];
        return;
    }
    
    [self saveDocument:self];
    
    /*
    // get a unique name for the file.
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    [uuidString autorelease];
    
    // write it all out.
    NSString *fileName      = [NSString stringWithFormat:@"%@.jstalk", [uuidString lowercaseString]];
    NSString *fileLocation  = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSURL *fileURL          = [NSURL fileURLWithPath:fileLocation];
    NSError *err            = nil;
    
    [[[jsTextView textStorage] string] writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    */
    
    // find our external editor to do some editing.
    NSString *externalEditorBundleId = [[NSUserDefaults standardUserDefaults] objectForKey:@"externalEditor"];
    NSString *appPath   = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:externalEditorBundleId];
    
    if (!appPath) {
        NSLog(@"Could not find the app path for %@", externalEditorBundleId);
        NSBeep();
        return;
    }
    
    // setup our watcher.0
    self.externalEditorFileWatcher = [JSTFileWatcher fileWatcherWithPath:[[self fileURL] path] delegate:self];
    
    // and away we go.
    [[NSWorkspace sharedWorkspace] openFile:[[self fileURL] path] withApplication:appPath];
}

- (void)fileWatcherDidRecieveFSEvent:(JSTFileWatcher*)fw {
    
    NSString *path = [fw path];
    
    NSError *err = nil;
    NSString *src = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:NSUTF8StringEncoding error:&err];
    
    if (err) {
        NSBeep();
        NSLog(@"err: %@", err);
        return;
    }
    
    if (src) {
        [[[jsTextView textStorage] mutableString] setString:src];
    }
}


- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier 
 willBeInsertedIntoToolbar:(BOOL)flag {
    
    // We create and autorelease a new NSToolbarItem, and then go through the process of setting up its
    // attributes from the master toolbar item matching that identifier in our dictionary of items.
    NSToolbarItem *newItem  = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    NSToolbarItem *item     = [_toolbarItems objectForKey:itemIdentifier];
    
    [newItem setLabel:[item label]];
    [newItem setPaletteLabel:[item paletteLabel]];
    if ([item view]!=NULL) {
        [newItem setView:[item view]];
    }
    else {
        [newItem setImage:[item image]];
    }
    
    [newItem setToolTip:[item toolTip]];
    [newItem setTarget:[item target]];
    [newItem setAction:[item action]];
    [newItem setMenuFormRepresentation:[item menuFormRepresentation]];
    // If we have a custom view, we *have* to set the min/max size - otherwise, it'll default to 0,0 and the custom
    // view won't show up at all!  This doesn't affect toolbar items with images, however.
    if ([newItem view]!=NULL){
    	[newItem setMinSize:[[item view] bounds].size];
        [newItem setMaxSize:[[item view] bounds].size];
    }
    
    return newItem;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
    return [NSArray arrayWithObjects: @"Run", @"Clear", nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
    return [NSArray arrayWithObjects: @"Run", @"Clear", NSToolbarSeparatorItemIdentifier, NSToolbarCustomizeToolbarItemIdentifier, NSToolbarSpaceItemIdentifier,NSToolbarFlexibleSpaceItemIdentifier, NSToolbarPrintItemIdentifier, nil];

}


- (void)copyBookmarkletToPasteboard:(id)sender {
    
    NSRange r = [jsTextView selectedRange];
    
    NSString *selectedText = nil;
        
    if (r.length == 0) {
        selectedText = [[jsTextView textStorage] string];
    }
    else {
        selectedText = [[[jsTextView textStorage] string] substringWithRange:r];
    }
    
    NSString *bookmarklet = [NSString stringWithFormat:@"javascript:%@", [selectedText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pb setString:bookmarklet forType:NSStringPboardType];
}


@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

NSToolbarItem *JSTAddToolbarItem(NSMutableDictionary *theDict,
                              NSString *identifier,
                              NSString *label,
                              NSString *paletteLabel,
                              NSString *toolTip,
                              id target,
                              SEL settingSelector,
                              id itemContent,
                              SEL action, 
                              NSMenu * menu)
{
    NSMenuItem *mItem;
    // here we create the NSToolbarItem and setup its attributes in line with the parameters
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:identifier];
    [item setLabel:label];
    [item setPaletteLabel:paletteLabel];
    [item setToolTip:toolTip];
    [item setTarget:target];
    // the settingSelector parameter can either be @selector(setView:) or @selector(setImage:).  Pass in the right
    // one depending upon whether your NSToolbarItem will have a custom view or an image, respectively
    // (in the itemContent parameter).  Then this next line will do the right thing automatically.
    [item performSelector:settingSelector withObject:itemContent];
    [item setAction:action];
    // If this NSToolbarItem is supposed to have a menu "form representation" associated with it (for text-only mode),
    // we set it up here.  Actually, you have to hand an NSMenuItem (not a complete NSMenu) to the toolbar item,
    // so we create a dummy NSMenuItem that has our real menu as a submenu.
    if (menu!=NULL) {
        // we actually need an NSMenuItem here, so we construct one
        mItem=[[NSMenuItem alloc] init];
        [mItem setSubmenu: menu];
        [mItem setTitle:[menu title]];
        [item setMenuFormRepresentation:mItem];
    }
    // Now that we've setup all the settings for this new toolbar item, we add it to the dictionary.
    // The dictionary retains the toolbar item for us, which is why we could autorelease it when we created
    // it (above).
    [theDict setObject:item forKey:identifier];
    
    return item;
}

#pragma clang diagnostic pop



