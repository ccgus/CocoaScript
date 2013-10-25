//
//  JSTAppDelegate.m
//  jstalk
//
//  Created by August Mueller on 1/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import "JSTAppDelegate.h"
#import "COScript.h"

@interface JSTAppDelegate (PrivateStuff)
- (void)restoreWorkspace;
- (void)saveWorkspace;
- (void)loadExternalEditorPrefs;
- (void)updatePrefsFontField;
@end

void JSTUncaughtExceptionHandler(NSException *exception) {
    NSLog(@"Uncaught exception: %@", exception);
}

@implementation JSTAppDelegate

+ (void)initialize {
    
	NSMutableDictionary *defaultValues 	= [NSMutableDictionary dictionary];
    NSUserDefaults      *defaults 	 	= [NSUserDefaults standardUserDefaults];
    
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"rememberWorkspace"];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"clearConsoleOnRun"];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"codeCompletionEnabled"];
    [defaultValues setObject:@"com.apple.xcode"            forKey:@"externalEditor"];
    
    [defaults registerDefaults: defaultValues];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultValues];
}


- (void)awakeFromNib {
    
    if ([JSTPrefs boolForKey:@"rememberWorkspace"]) {
        [self restoreWorkspace];
    }
    
    [COScript setShouldLoadJSTPlugins:YES];
    [COScript listen];
    
    NSSetUncaughtExceptionHandler(JSTUncaughtExceptionHandler);
    
    
    // register this object to handle the services stuff.
    [NSApp setServicesProvider:self];
    
    // have all the services menus get updated.
    //NSUpdateDynamicServices();
    
    [COScript loadPlugins]; // some guys will setup custom UI in the app.
}

- (IBAction)showPrefs:(id)sender {
    
    [self loadExternalEditorPrefs];
    [self updatePrefsFontField];
    
    if (![prefsWindow isVisible]) {
        [prefsWindow center];
    }
    
    [prefsWindow makeKeyAndOrderFront:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self saveWorkspace];
}

- (void)restoreWorkspace {
    
    NSArray *ar = [[NSUserDefaults standardUserDefaults] objectForKey:@"workspaceOpenDocuments"];
    
    for (NSString *path in ar) {
        
        if ([path hasSuffix:@".jstplugin"]) {
            debug(@"Skipping %@", path);
            continue;
        }
        
        [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil];
    }
}

- (void)saveWorkspace {
    
    NSMutableArray *openDocs = [NSMutableArray array];
    
    for (NSDocument *doc in [[NSDocumentController sharedDocumentController] documents]) {
        
        if ([doc fileURL]) {
            // saving the file alias would be better.
            [openDocs addObject:[[doc fileURL] path]];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:openDocs forKey:@"workspaceOpenDocuments"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)loadExternalEditorPrefs {
    
    NSString *editorId = [[NSUserDefaults standardUserDefaults] objectForKey:@"externalEditor"];
    
    NSWorkspace *ws     = [NSWorkspace sharedWorkspace];
    NSString *appPath   = [ws absolutePathForAppBundleWithIdentifier:editorId];
    NSString *appName   = nil;
    
    if (appPath) {
        
        NSBundle *appBundle  = [NSBundle bundleWithPath:appPath];
        NSString *bundleName = [appBundle objectForInfoDictionaryKey:@"CFBundleName"];
        
        if (bundleName) {
            appName = bundleName;
        }
    }
    
    if (!appName) {
        appName = @"Unknown";
    }
    
    [externalEditorField setStringValue:appName];
}


- (void)chooseExternalEditor:(id)sender {
    
    NSOpenPanel *p = [NSOpenPanel openPanel];
    
    [p setCanChooseFiles:YES];
    [p setCanChooseDirectories:NO];
    [p setAllowsMultipleSelection:NO];
    
    [p setAllowedFileTypes:[NSArray arrayWithObjects:@"app", @"APPL", nil]];
    
    [p beginSheetModalForWindow:prefsWindow completionHandler:^(NSInteger result) {
        
        if (!result) {
            return;
        }
            
        NSString *path = [[p URL] path];
        
        NSBundle *appBundle = [NSBundle bundleWithPath:path];
        NSString *bundleId  = [appBundle bundleIdentifier];
        
        if (!bundleId) {
            NSBeep();
            NSLog(@"Could not load the bundle info for %@", bundleId);
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:bundleId forKey:@"externalEditor"];
        
        [self loadExternalEditorPrefs];
    }];
    
}

- (void)prefsChoosefont:(id)sender {
    
    [[NSFontManager sharedFontManager] setTarget:self];
    
    [[NSFontManager sharedFontManager] orderFrontFontPanel:self];
    
}

- (void)changeFont:(id)sender {
    
    NSFont *f = [[sender fontPanel:NO] panelConvertFont:[self defaultEditorFont]];
    
    [self setDefaultEditorFont:f];
    
    [self updatePrefsFontField];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSTFontChangeNotification" object:self];
    
}

- (void)updatePrefsFontField {
    NSFont *f = [self defaultEditorFont];
    [prefsFontField setStringValue:[NSString stringWithFormat:@"%@ %dfp", [f fontName],(int)[f pointSize]]];
}

- (void)setDefaultEditorFont:(NSFont*)f {
    NSData *fontAsData = [NSArchiver archivedDataWithRootObject:f];
    [[NSUserDefaults standardUserDefaults] setObject:fontAsData forKey: @"defaultFont"];
}

- (NSFont*)defaultEditorFont {
    
    NSFont *defaultFont = nil;
    
    NSData *d = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultFont"];
    if (d) {
        defaultFont = [NSUnarchiver unarchiveObjectWithData:d];
    }
    
    if (!defaultFont) {
        defaultFont = [NSFont fontWithName:@"Monaco" size:10];
    }
    
    if (!defaultFont) {
        defaultFont = [NSFont systemFontOfSize:12];
    }
    
    return defaultFont;
}

- (void)JSTalk:(COScript*)jstalk hadError:(NSString*)error onLineNumber:(NSInteger)lineNumber atSourceURL:(id)url {
    _serviceError = error;
}


- (void)runAsJSTalkScript:(NSPasteboard *)pb userData:(NSDictionary *)userData error:(NSString **)error {
    
    _serviceError = nil;
    
    // Test for strings on the pasteboard.
    NSArray *classes = [NSArray arrayWithObject:[NSString class]];
    NSDictionary *options = [NSDictionary dictionary];
    if (![pb canReadObjectForClasses:classes options:options])  {
        *error = NSLocalizedString(@"Error: couldn't read the text.", @"pboard couldn't give string.");
        return;
    }
    
    NSString *result = nil;
    NSString *script = [pb stringForType:NSPasteboardTypeString];
    
    @try {
        
        COScript *jstalk = [[COScript alloc] init];
        
        [jstalk setErrorController:self];
        
        [[[NSThread currentThread] threadDictionary] setObject:jstalk forKey:@"org.jstalk.currentJSTalkContext"];
        
        result = [[jstalk executeString:script] description];
        
        [[[NSThread currentThread] threadDictionary] removeObjectForKey:@"org.jstalk.currentJSTalkContext"];
    }
    @catch (NSException *e) {
        *error = [e reason];
        return;
    }
    
    if (_serviceError) {
        result = _serviceError;
    }
    
    [pb clearContents];
    
    if (result) {
        [pb writeObjects:[NSArray arrayWithObject:result]];
    }
}

@end
