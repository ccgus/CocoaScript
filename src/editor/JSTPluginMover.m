//
//  JSTPluginMover.m
//  jstalk
//
//  Created by August Mueller on 8/15/10.
//  Copyright 2010 Flying Meat Inc. All rights reserved.
//

#import "JSTPluginMover.h"
#import <CocoaScript/COScript.h>

@implementation JSTPluginMover

- (void)makeWindowControllers { }

- (NSData *)dataRepresentationOfType:(NSString *)type {
    return nil;
}

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)docType {
    NSString *thePluginName = [fileName lastPathComponent];
    NSString *pluginsFolder = [@"~/Library/Application Support/JSTalk/Plug-ins/" stringByExpandingTildeInPath];
    NSString *placeToPut    = [pluginsFolder stringByAppendingPathComponent:thePluginName];
    
    // is it already in the plugins folder?
    if ([placeToPut isEqualToString:fileName]) {
        // wait 2 seconds and close this guy.
        [self performSelector:@selector(close) withObject:nil afterDelay:2];
        return YES;
    }
    
    NSString *askQuestion = NSLocalizedString(@"Would you like to copy the plugin '%@' into your JSTalk Plug-ins folder?",
                                              @"Would you like to copy the plugin '%@' into your JSTalk Plug-ins folder?");
    
    int decision = NSRunAlertPanel(NSLocalizedString(@"Install Plug-in?", @"Install Plug-in?"),
                                   [NSString stringWithFormat:askQuestion, thePluginName], @"Install Plug-in", @"Cancel", nil);
    
    
    
    if (decision == NSOKButton) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *err = nil; // yes, I know the cocoa conventions on this.  I'm going to nil it out anyway.
        if (![fileManager createDirectoryAtPath:pluginsFolder withIntermediateDirectories:YES attributes:nil error:&err]) {
            NSLog(@"Error making the plug-in directory: %@", err);
            NSBeep();
            return NO;
        }
        
        // check and see if it's already there..
        BOOL isDir;
        
        if ([fileManager fileExistsAtPath:placeToPut isDirectory:&isDir] && isDir) {
            
            NSString *sorryQ = NSLocalizedString(@"There is already a plug-in installed with the name '%@'.  Please quit JSTalk, remove it, and then try again.",
                                                 @"There is already a plug-in installed with the name '%@'.  Please quit JSTalk, remove it, and then try again.");
            
            NSString *openFolder = NSLocalizedString(@"Open Plug-ins Folder", @"Open Plug-ins Folder");
            
            decision = NSRunAlertPanel(NSLocalizedString(@"Sorry", @"Sorry"), [NSString stringWithFormat:sorryQ, thePluginName], nil, openFolder, nil);
            
            // open up the plugins folder for the user to remove the plugin.
            if (decision != NSOKButton) {
                [[NSWorkspace sharedWorkspace] openFile:pluginsFolder];
            }
        }
        else {
            
            
            if (![fileManager copyItemAtPath:fileName toPath:[pluginsFolder stringByAppendingPathComponent:thePluginName] error:&err]) {
                
                NSLog(@"Error copying plug-in: %@", err);
                NSRunAlertPanel(NSLocalizedString(@"Sorry", @"Sorry"),
                                NSLocalizedString(@"I could not copy in the plug-in.",
                                                  @"I could not copy in the plug-in."),
                                nil, nil, nil);
            }
            else {
                
                [COScript resetPlugins];
                
                
                NSRunAlertPanel(NSLocalizedString(@"Plug-in Installed.", @"Plug-in Installed."), @"", nil, nil, nil);
                
                
            }
        }
    }

    
    // wait 2 seconds and close this guy.
    [self performSelector:@selector(close) withObject:nil afterDelay:2];
    
    return YES;
}

@end
