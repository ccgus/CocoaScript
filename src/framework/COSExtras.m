
#import "COSExtras.h"
#import "COScript.h"
#import <ScriptingBridge/ScriptingBridge.h>

@implementation COScript (JSTExtras)

- (void)exit:(int)termCode {
    exit(termCode);
}

- (void)modifiers:(NSString*)using down:(BOOL)pressDown {
    
    // THIS IS TOTOALLY BROKEN, BUT AT LEAST IT DOESN'T USE DEPREICATED APIS ANYMORE.
    
    // we're doing it this way, since for some reason, it doesn't always
    // work correct when using the "using command & option down" stuff
    // for applescript.  I DON'T KNOW WHY IT JUST DOESN'T.
    
    BOOL option = [using rangeOfString:@"option"].location != NSNotFound;
    BOOL command = [using rangeOfString:@"command"].location != NSNotFound;
    BOOL control = [using rangeOfString:@"control"].location != NSNotFound;
    BOOL shift = [using rangeOfString:@"shift"].location != NSNotFound;
    
    if (command) {
        debug(@"sending command: %d", pressDown);
        CGEventRef event = CGEventCreateKeyboardEvent(nil, (CGKeyCode)55, pressDown);
        CGEventPost(kCGHIDEventTap, event);
        CFRelease(event);
    }
    if (option) {
        CGEventRef event = CGEventCreateKeyboardEvent(nil, (CGKeyCode)58, pressDown);
        CGEventPost(kCGHIDEventTap, event);
        CFRelease(event);
    }
    
    if (control) {
        CGEventRef event = CGEventCreateKeyboardEvent(nil, (CGKeyCode)59, pressDown);
        CGEventPost(kCGHIDEventTap, event);
        CFRelease(event);
    }
    if (shift) {
        CGEventRef event = CGEventCreateKeyboardEvent(nil, (CGKeyCode)56, pressDown);
        CGEventPost(kCGHIDEventTap, event);
        CFRelease(event);
    }
}


- (void)keystroke:(NSString*)keys using:(NSString*)using {
    keys = [keys stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *appleScriptString = [NSString stringWithFormat:@"tell application \"System Events\"\nkeystroke \"%@\"\nend tell", keys];
    
    NSAppleScript *as = [[NSAppleScript alloc] initWithSource:appleScriptString];
    
    [self modifiers:using down:YES];
    
    NSDictionary *err;
    if (![as executeAndReturnError:&err]) {
        NSLog(@"Error: %@", err);
    }
    
    [self modifiers:using down:NO];
    
}

- (void)keystroke:(NSString*)keys {
    [self keystroke:keys using:@""];
}

- (void)keyCode:(NSString*)keys using:(NSString*)using {

    NSString *appleScriptString = [NSString stringWithFormat:@"tell application \"System Events\"\nkey code %@\nend tell", keys];
    
    NSAppleScript *as = [[NSAppleScript alloc] initWithSource:appleScriptString];
    
    [self modifiers:using down:YES];
    
    NSDictionary *err;
    if (![as executeAndReturnError:&err]) {
        NSLog(@"Error: %@", err);
    }
    
    [self modifiers:using down:NO];
}

- (void)keyCode:(NSString*)keys {
    [self keyCode:keys using:@""];
}

- (void)sleep:(CGFloat)s {
    sleep(s);
}

- (void)system:(NSString*)s {
    system([s UTF8String]);
}


@end

@implementation NSApplication (COSExtras)

- (id)open:(NSString*)pathToFile {
    
    NSError *err = nil;
    
    NSURL *url = [NSURL fileURLWithPath:pathToFile];
    
    id doc = [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url
                                                                                    display:YES
                                                                                      error:&err];
    
    if (err) {
        NSLog(@"Error: %@", err);
        return nil;
    }
    
    return doc;
}

- (void)activate {
    ProcessSerialNumber xpsn = { 0, kCurrentProcess };
    SetFrontProcess( &xpsn );
}

- (NSInteger)displayDialog:(NSString*)msg withTitle:(NSString*) title {
    
    NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", msg];
    
    NSInteger button = [alert runModal];
    
    return button;
}

- (NSInteger)displayDialog:(NSString*)msg {
    
    NSString *title = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey];
    
    if (!title) {
        title = @"Unknown Application";
    }
    
    return [self displayDialog:msg withTitle:title];
}

- (id)sharedDocumentController {
    return [NSDocumentController sharedDocumentController];
}

- (id)standardUserDefaults {
    return [NSUserDefaults standardUserDefaults];
}

@end


@implementation NSDocument (JSTExtras)

- (id)dataOfType:(NSString*)type {
    
    NSError *err = nil;
    
    NSData *data = [self dataOfType:type error:&err];
    
    
    return data;
    
}

@end


@implementation NSData (JSTExtras)

- (BOOL)writeToFile:(NSString*)path {
    
    return [self writeToURL:[NSURL fileURLWithPath:path] atomically:YES];
}

@end

@implementation NSObject (JSTExtras)

- (Class)ojbcClass {
    return [self class];
}

@end


@implementation SBApplication (JSTExtras)

+ (id)application:(NSString*)appName {
    
    NSString *appPath = [[NSWorkspace sharedWorkspace] fullPathForApplication:appName];
    
    if (!appPath) {
        NSLog(@"Could not find application '%@'", appName);
        return nil;
    }
    
    NSBundle *appBundle = [NSBundle bundleWithPath:appPath];
    NSString *bundleId  = [appBundle bundleIdentifier];
    
    return [SBApplication applicationWithBundleIdentifier:bundleId];
}


@end



@implementation NSString (JSTExtras)

- (NSURL*)fileURL {
    return [NSURL fileURLWithPath:self];
}

@end


@implementation NSApplication (JSTRandomCrap)

+ (NSDictionary*)JSTAXStuff {
    
    /*
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    
    AXUIElementRef uiElement = AXUIElementCreateSystemWide();
    
    CFTypeRef focusedUIElement = nil;
	
	AXError error = AXUIElementCopyAttributeValue(uiElement, kAXFocusedUIElementAttribute, &focusedUIElement);
    
    if (focusedUIElement) {
        
        NSArray* attributeNames;
        AXUIElementCopyAttributeNames(focusedUIElement, (CFArrayRef *)&attributeNames);
        
        for (NSString *attName in attributeNames) {
            
            CFTypeRef attValue;
            
            AXError lerror = AXUIElementCopyAttributeValue(focusedUIElement, (CFStringRef)attName, &attValue);
            if (!lerror) {
                
                if ((AXValueGetType(attValue) == kAXValueCGPointType)) {
                    NSPoint p;
                    AXValueGetValue(attValue, kAXValueCGPointType, &p);
                    [d setObject:[NSValue valueWithPoint:p] forKey:attName];
                }
                else if ((AXValueGetType(attValue) == kAXValueCGSizeType)) {
                    NSSize s;
                    AXValueGetValue(attValue, kAXValueCGSizeType, &s);
                    [d setObject:[NSValue valueWithSize:s] forKey:attName];
                }
                else if ((AXValueGetType(attValue) == kAXValueCGRectType)) {
                    NSRect r;
                    AXValueGetValue(attValue, kAXValueCGRectType, &r);
                    [d setObject:[NSValue valueWithRect:r] forKey:attName];
                }
                else if ((AXValueGetType(attValue) == kAXValueCFRangeType)) {
                    NSRange r;
                    AXValueGetValue(attValue, kAXValueCFRangeType, &r);
                    [d setObject:[NSValue valueWithRange:r] forKey:attName];
                }
                else {
                    [d setObject:(id)attValue forKey:attName];
                }
                
                CFRelease(attValue);
            }
            
        }
        
        if (attributeNames) {
            CFRelease(attributeNames);
        }
        
        CFRelease(focusedUIElement);
    }
    else if (error) {
        NSLog(@"Could not get AXFocusedUIElement");
    }
    
    
    CFRelease(uiElement);
    
    return d;
    */
    return nil;
}

+ (void)JSTAXSetSelectedTextAttributeOnFocusedElement:(NSString*)s {
    AXUIElementRef uiElement = AXUIElementCreateSystemWide();
    
    CFTypeRef focusedUIElement = nil;
	
	AXError error = AXUIElementCopyAttributeValue(uiElement, kAXFocusedUIElementAttribute, &focusedUIElement);
    
    if (focusedUIElement) {
        
        AXUIElementSetAttributeValue(focusedUIElement, kAXSelectedTextAttribute, (__bridge CFTypeRef)(s));
        
        CFRelease(focusedUIElement);
    }
    else if (error) {
        NSLog(@"Could not get AXFocusedUIElement");
    }
    
    CFRelease(uiElement);
}

+ (void)JSTAXSetSelectedTextRangeAttributeOnFocusedElement:(NSRange)range {
    AXUIElementRef uiElement = AXUIElementCreateSystemWide();
    
    CFTypeRef focusedUIElement = nil;
	
	AXError error = AXUIElementCopyAttributeValue(uiElement, kAXFocusedUIElementAttribute, &focusedUIElement);
    
    if (focusedUIElement) {
        
        //sscanf( [[_attributeValueTextField stringValue] cString], "pos=%ld len=%ld", &(range.location), &(range.length) );
        AXValueRef valueRef = AXValueCreate( kAXValueCFRangeType, (const void *)&range );
        if (valueRef) {
            AXError setError = AXUIElementSetAttributeValue(focusedUIElement, kAXSelectedTextRangeAttribute, valueRef );
            
            
            if (setError) {
                debug(@"error setting the range (%d)", setError);
            }
            
            CFRelease( valueRef );
        }
        
        
        CFRelease(focusedUIElement);
    }
    else if (error) {
        NSLog(@"Could not get AXFocusedUIElement");
    }
    
    CFRelease(uiElement);
}

@end



@implementation NSGradient (JSTExtras)


+ (id)gradientWithColors:(NSArray*)colors locationArray:(NSArray*)arLocs colorSpace:(NSColorSpace *)colorSpace {
    
    
    CGFloat *locs = malloc(sizeof(CGFloat) * [arLocs count]);
    
    [arLocs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        locs[idx] = [obj doubleValue];
    }];
    
    
    
    if (!colorSpace) {
        colorSpace = [NSColorSpace genericRGBColorSpace];
    }
    
    
    NSGradient *g = [[NSGradient alloc] initWithColors:colors atLocations:locs colorSpace:colorSpace];
    
    return g;
}

@end


