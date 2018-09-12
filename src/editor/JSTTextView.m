//
//  JSTTextView.m
//  jstalk
//
//  Created by August Mueller on 1/18/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import "JSTTextView.h"
#import "MarkerLineNumberView.h"
#import "TDParseKit.h"
#import "NoodleLineNumberView.h"
#import "TETextUtils.h"
#import <Carbon/Carbon.h>

static NSString *JSTQuotedStringAttributeName = @"JSTQuotedString";
static NSString *JSTIndent = @"    ";

@interface JSTTextView ()
@property JSTTextViewTheme _theme;
@property (assign) NSRange currentlyHighlightedRange;
@property (assign) NSRange initialNumberRange;
@property (assign) NSRange initialDragCommandRange;
@property (assign) CGPoint initialDragPoint;
@property (strong) NSNumber *initialNumber;
@property (strong) NSMutableDictionary *numberRanges;
@property (strong) NSDictionary *lightCodeHighlightingColors;
@property (strong) NSDictionary *darkCodeHighlightingColors;
@end


@implementation JSTTextView

@synthesize keywords=_keywords;
@synthesize lastAutoInsert=_lastAutoInsert;
@synthesize ignoredSymbols=_ignoredSymbols;

- (id)initWithFrame:(NSRect)frameRect textContainer:(NSTextContainer *)container {
    
	self = [super initWithFrame:frameRect textContainer:container];
    
	if (self != nil) {
        [self initThemes];
        [self performSelector:@selector(setupLineViewAndStuff) withObject:nil afterDelay:0];
        [self setSmartInsertDeleteEnabled:NO];
        [self setAutomaticQuoteSubstitutionEnabled:NO];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
	if (self != nil) {
        [self initThemes];
        // what's the right way to do this?
        [self performSelector:@selector(setupLineViewAndStuff) withObject:nil afterDelay:0];
        [self setSmartInsertDeleteEnabled:NO];
        [self setAutomaticQuoteSubstitutionEnabled:NO];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)initThemes {
    self.darkCodeHighlightingColors = @{
        @"keyword.control": [NSColor colorWithRed:0.81 green:0.43 blue:0.92 alpha:1],
        @"storage": [NSColor colorWithRed:0.81 green:0.43 blue:0.92 alpha:1],
        @"constant": [NSColor colorWithRed:0.98 green:0.78 blue:0.25 alpha:1.0],
        @"support.class": [NSColor colorWithRed:0.98 green:0.78 blue:0.25 alpha:1.0],
        @"support.function": [NSColor colorWithRed:0.40 green:0.83 blue:1.00 alpha:1.0],
        @"none": [NSColor colorWithRed:1 green:1 blue:1 alpha:0.85],
        @"string": [NSColor colorWithRed:0.57 green:0.87 blue:0.25 alpha:1.0],
        @"constant.numeric": [NSColor colorWithRed:0.98 green:0.78 blue:0.25 alpha:1.0],
        @"comment": [NSColor colorWithRed:1 green:1 blue:1 alpha:0.5],
        @"source.js keyword.operators": [NSColor colorWithRed:0.40 green:0.83 blue:1.00 alpha:1.0]
    };
    self.lightCodeHighlightingColors = @{
         @"keyword.control": [NSColor colorWithRed:0.54 green:0.09 blue:0.66 alpha:1.0],
         @"storage": [NSColor colorWithRed:0.54 green:0.09 blue:0.66 alpha:1.0],
         @"constant": [NSColor colorWithRed:0.73 green:0.53 blue:0.00 alpha:1.0],
         @"support.class": [NSColor colorWithRed:0.73 green:0.53 blue:0.00 alpha:1.0],
         @"support.function": [NSColor colorWithRed:0.15 green:0.58 blue:0.75 alpha:1.0],
         @"none": [NSColor colorWithRed:0 green:0 blue:0 alpha:0.85],
         @"string": [NSColor colorWithRed:0.32 green:0.62 blue:0.00 alpha:1.0],
         @"constant.numeric": [NSColor colorWithRed:0.73 green:0.53 blue:0.00 alpha:1.0],
         @"comment": [NSColor colorWithRed:0 green:0 blue:0 alpha:0.5],
         @"source.js keyword.operators": [NSColor colorWithRed:0.15 green:0.58 blue:0.75 alpha:1.0]
     };
}

- (void)setupLineViewAndStuff {
    
    NoodleLineNumberView *numberView = [[NoodleLineNumberView alloc] initWithScrollView:[self enclosingScrollView]];
    [[self enclosingScrollView] setVerticalRulerView:numberView];
    [[self enclosingScrollView] setHasHorizontalRuler:NO];
    [[self enclosingScrollView] setHasVerticalRuler:YES];
    [[self enclosingScrollView] setRulersVisible:YES];
    
    [[self textStorage] setDelegate:self];
    
    NSArray *controlKeywords = [NSArray arrayWithObjects:@"catch", @"finally", @"throw", @"try", @"break", @"continue", @"goto", @"do", @"while", @"return", @"case", @"default", @"switch", @"else", @"if", @"with", @"package", @"class", @"for", @"await", @"yield", @"async", nil];
    
    NSArray *jsKeywords = [NSArray arrayWithObjects:@"delete", @"in", @"of", @"instanceof", @"new", @"typeof", @"void", @"package", nil];
    
    NSArray *storageKeywords = [NSArray arrayWithObjects:@"var", @"let", @"const", @"function", nil];
    
    NSArray *constants = [NSArray arrayWithObjects:@"null", @"nil", @"undefined", @"this", @"NaN", @"Infinity", @"arguments", @"context", @"true", @"false", nil];
    
    NSArray *globalObjects = [NSArray arrayWithObjects:@"Array", @"Date", @"Map", @"Boolean", @"Number", @"Object", @"Proxy", @"Reflect", @"RegExp", @"Set", @"String", @"Symbol", @"WeakMap", @"WeakSet", @"EvalError", @"InternalError", @"RangeError", @"ReferenceError", @"SyntaxError", @"TypeError", @"URIError", @"Error", @"Math", @"console", @"JSON", @"Promise", nil];
    
    NSArray *globalFunctions = [NSArray arrayWithObjects:@"clearInterval", @"clearTimeout", @"decodeURI", @"decodeURIComponent", @"encodeURI", @"encodeURIComponent", @"escape", @"eval", @"isFinite", @"isNaN", @"parseFloat", @"parseInt", @"require", @"setInterval", @"setTimeout", @"super", @"unescape", @"uneval", nil];
    
    NSMutableDictionary *keywords = [NSMutableDictionary dictionary];
    
    for (NSString *word in controlKeywords) {
        [keywords setObject:@"keyword.control" forKey:word];
    }
    for (NSString *word in jsKeywords) {
        [keywords setObject:@"keyword.control" forKey:word];
    }
    for (NSString *word in storageKeywords) {
        [keywords setObject:@"storage" forKey:word];
    }
    for (NSString *word in constants) {
        [keywords setObject:@"constant" forKey:word];
    }
    for (NSString *word in globalObjects) {
        [keywords setObject:@"support.class" forKey:word];
    }
    for (NSString *word in globalFunctions) {
        [keywords setObject:@"support.function" forKey:word];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeSelection:) name:NSTextViewDidChangeSelectionNotification object:self];
    
    
    self.keywords = keywords;
    self.ignoredSymbols = [NSSet setWithArray:@[@"{", @"}", @"(", @")", @",", @";"]];
    
    self.numberRanges = [NSMutableDictionary new];
    
    [self parseCode:nil];
}

- (JSTTextViewTheme) theme {
    return self._theme;
}

- (void) setTheme:(JSTTextViewTheme)newTheme {
    if (self.theme != newTheme) {
        self._theme = newTheme;
        [self parseCode:self];
    }
}

- (NSDictionary<NSString*, NSColor*>*)colors {
    BOOL isDarkMode = self.theme == JSTTextViewThemeDark;
    if (isDarkMode) {
        return self.darkCodeHighlightingColors;
    }
    
    return self.lightCodeHighlightingColors;
}

- (void)parseCode:(id)sender {
    
    // we should really do substrings...
    
    NSString *sourceString = [[self textStorage] string];
    TDTokenizer *tokenizer = [TDTokenizer tokenizerWithString:sourceString];
    
    tokenizer.commentState.reportsCommentTokens = YES;
    tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    
    [[self textStorage] beginEditing];
    [self.numberRanges removeAllObjects];
    NSUInteger sourceLoc = 0;
    
    NSDictionary *colors = [self colors];
    
    while ((tok = [tokenizer nextToken]) != eof) {
        
        NSUInteger strLen = [[tok stringValue] length];
        NSRange tokenRange = NSMakeRange(sourceLoc, strLen);
        NSColor *fontColor = colors[@"none"];
        
        if ([tok isQuotedString]) {
            fontColor = colors[@"string"];
        }
        else if ([tok isNumber]) {
            fontColor = colors[@"constant.numeric"];
            [self setNumberString:[tok stringValue] forRange:tokenRange];
        }
        else if ([tok isComment]) {
            fontColor = colors[@"comment"];
        }
        else if ([tok isWord]) {
            NSString *c = [_keywords objectForKey:[tok stringValue]];
            fontColor = c && colors[c] ? colors[c] : fontColor;
        }
        else if ([tok isSymbol] && ![_ignoredSymbols containsObject:[tok stringValue]]) {
            fontColor = colors[@"source.js keyword.operators"];
        }
        
        
        if (fontColor) {
            [[self textStorage] addAttribute:NSForegroundColorAttributeName value:fontColor range:tokenRange];
        }
        
        if ([tok isQuotedString]) {
            [[self textStorage] addAttribute:JSTQuotedStringAttributeName value:[NSNumber numberWithBool:YES] range:tokenRange];
        }
        else {
            [[self textStorage] removeAttribute:JSTQuotedStringAttributeName range:tokenRange];
        }
        
        sourceLoc += strLen;
    }
    
    
    [[self textStorage] endEditing];
}



- (void) textStorageDidProcessEditing:(NSNotification *)note {
    [self parseCode:nil];
}

- (NSArray *)writablePasteboardTypes {
    return [[super writablePasteboardTypes] arrayByAddingObject:NSRTFPboardType];
}

- (void)insertTab:(id)sender {
    NSRange selectedRange = self.selectedRange;
    if (selectedRange.location == NSNotFound) {
        return [self insertText:JSTIndent];
    }
    
    // if we have some selected lines, then indent them all
    NSString *content = self.string;
    
    NSRange lineRange = [content lineRangeForRange:selectedRange];
    
    NSString *toProcess = [content substringWithRange:lineRange];
    NSArray *lines = [toProcess componentsSeparatedByString:@"\n"];
    NSMutableArray *modLines = [NSMutableArray arrayWithCapacity:lines.count];
    NSUInteger paddingLength = JSTIndent.length;
    
    __block NSUInteger totalShift = 0;
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        NSString *line = obj;
        if (line.length)
            totalShift += paddingLength;
        [modLines addObject:[JSTIndent stringByAppendingString:line]];
    }];
    if ([modLines.lastObject isEqualToString:JSTIndent])
    {
        [modLines removeLastObject];
        [modLines addObject:@""];
    }
    NSString *processed = [modLines componentsJoinedByString:@"\n"];
    [self insertText:processed replacementRange:lineRange];
    
    selectedRange.location += paddingLength;
    selectedRange.length +=
    (totalShift > paddingLength) ? totalShift - paddingLength : 0;
    self.selectedRange = selectedRange;
}

- (void)insertBacktab:(id)sender {
    NSString *content = self.string;
    NSRange selectedRange = self.selectedRange;
    NSRange lineRange = [content lineRangeForRange:selectedRange];
    
    // Get the lines to unindent.
    NSString *toProcess = [content substringWithRange:lineRange];
    NSArray *lines = [toProcess componentsSeparatedByString:@"\n"];
    
    // This will hold the modified lines.
    NSMutableArray *modLines = [NSMutableArray arrayWithCapacity:lines.count];
    
    // Unindent the lines one by one, and put them in the new array.
    __block NSUInteger firstShift = 0;      // Indentation of the first line.
    __block NSUInteger totalShift = 0;      // Indents removed in total.
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        NSString *line = obj;
        NSUInteger lineLength = line.length;
        NSUInteger shift = 0;
        
        for (shift = 0; shift < JSTIndent.length; shift++)
        {
            if (shift >= lineLength)
                break;
            unichar c = [line characterAtIndex:shift];
            if (c == '\t')
                shift++;
            if (c != ' ')
                break;
        }
        if (index == 0)
            firstShift += shift;
        totalShift += shift;
        if (shift && shift < lineLength)
            line = [line substringFromIndex:shift];
        [modLines addObject:line];
    }];
    
    // Join the processed lines, and replace the original with them.
    NSString *processed = [modLines componentsJoinedByString:@"\n"];
    [self insertText:processed replacementRange:lineRange];
    
    // Modify the selection range so that the same text (minus removed spaces)
    // are selected.
    selectedRange.location -= firstShift;
    selectedRange.length -= totalShift - firstShift;
    self.selectedRange = selectedRange;
}

- (void)autoInsertText:(NSString*)text {
    
    [super insertText:text];
    [self setLastAutoInsert:text];
    
}

- (void)insertText:(id)insertString {
    
    if (!([JSTPrefs boolForKey:@"codeCompletionEnabled"])) {
        [super insertText:insertString];
        return;
    }
    
    // make sure we're not doing anything fance in a quoted string.
    if (NSMaxRange([self selectedRange]) < [[self textStorage] length] && [[[self textStorage] attributesAtIndex:[self selectedRange].location effectiveRange:nil] objectForKey:JSTQuotedStringAttributeName]) {
        [super insertText:insertString];
        return;
    }
    
    if ([@")" isEqualToString:insertString] && [_lastAutoInsert isEqualToString:@")"]) {
        
        NSRange nextRange   = [self selectedRange];
        nextRange.length = 1;
        
        if (NSMaxRange(nextRange) <= [[self textStorage] length]) {
            
            NSString *next = [[[self textStorage] mutableString] substringWithRange:nextRange];
            
            if ([@")" isEqualToString:next]) {
                // just move our selection over.
                nextRange.length = 0;
                nextRange.location++;
                [self setSelectedRange:nextRange];
                return;
            }
        }
    }
    
    [self setLastAutoInsert:nil];
    
    [super insertText:insertString];
    
    NSRange currentRange = [self selectedRange];
    NSRange r = [self selectionRangeForProposedRange:currentRange granularity:NSSelectByParagraph];
    BOOL atEndOfLine = (NSMaxRange(r) - 1 == NSMaxRange(currentRange));
    
    
    if (atEndOfLine && [@"{" isEqualToString:insertString]) {
        
        r = [self selectionRangeForProposedRange:currentRange granularity:NSSelectByParagraph];
        NSString *myLine = [[[self textStorage] mutableString] substringWithRange:r];
        
        NSMutableString *indent = [NSMutableString string];
        
        int j = 0;
        
        while (j < [myLine length] && ([myLine characterAtIndex:j] == ' ' || [myLine characterAtIndex:j] == '\t')) {
            [indent appendFormat:@"%C", [myLine characterAtIndex:j]];
            j++;
        }
        
        [self autoInsertText:[NSString stringWithFormat:@"\n%@    \n%@}", indent, indent]];
        
        currentRange.location += [indent length] + 5;
        
        [self setSelectedRange:currentRange];
    }
    else if (atEndOfLine && [@"(" isEqualToString:insertString]) {
        
        [self autoInsertText:@")"];
        [self setSelectedRange:currentRange];
        
    }
    else if (atEndOfLine && [@"[" isEqualToString:insertString]) {
        [self autoInsertText:@"]"];
        [self setSelectedRange:currentRange];
    }
    else if ([@"\"" isEqualToString:insertString]) {
        [self autoInsertText:@"\""];
        [self setSelectedRange:currentRange];
    }
}

- (void)insertNewline:(id)sender {
    
    [super insertNewline:sender];
    
    if ([JSTPrefs boolForKey:@"codeCompletionEnabled"]) {
        
        NSRange r = [self selectedRange];
        if (r.location > 0) {
            r.location --;
        }
        
        r = [self selectionRangeForProposedRange:r granularity:NSSelectByParagraph];
        
        NSString *previousLine = [[[self textStorage] mutableString] substringWithRange:r];
        
        int j = 0;
        
        while (j < [previousLine length] && ([previousLine characterAtIndex:j] == ' ' || [previousLine characterAtIndex:j] == '\t')) {
            j++;
        }
        
        if (j > 0) {
            NSString *foo = [[[self textStorage] mutableString] substringWithRange:NSMakeRange(r.location, j)];
            [self insertText:foo];
        }
    }
}


- (BOOL)xrespondsToSelector:(SEL)aSelector {
    
    debug(@"%@: %@?", [self class], NSStringFromSelector(aSelector));
    
    return [super respondsToSelector:aSelector];
    
}

- (void)changeSelectedNumberByDelta:(NSInteger)d {
    NSRange r   = [self selectedRange];
    NSRange wr  = [self selectionRangeForProposedRange:r granularity:NSSelectByWord];
    NSString *s = [[[self textStorage] mutableString] substringWithRange:wr];
    
    NSInteger i = [s integerValue];
    
    if ([s isEqualToString:[NSString stringWithFormat:@"%ld", (long)i]]) {
        
        NSString *newString = [NSString stringWithFormat:@"%ld", (long)(i+d)];
        
        if ([self shouldChangeTextInRange:wr replacementString:newString]) { // auto undo.
            [[self textStorage] replaceCharactersInRange:wr withString:newString];
            [self didChangeText];
            
            r.length = 0;
            [self setSelectedRange:r];    
        }
    }
}

/*
- (void)moveForward:(id)sender {
    debug(@"%s:%d", __FUNCTION__, __LINE__);
    #pragma message "this really really needs to be a pref"
    // defaults write org.jstalk.JSTalkEditor optionNumberIncrement 1
    if ([JSTPrefs boolForKey:@"optionNumberIncrement"]) {
        [self changeSelectedNumberByDelta:-1];
    }
    else {
        [super moveForward:sender];
    }
}

- (void)moveBackward:(id)sender {
    if ([JSTPrefs boolForKey:@"optionNumberIncrement"]) {
        [self changeSelectedNumberByDelta:1];
    }
    else {
        [super moveBackward:sender];
    }
}


- (void)moveToEndOfParagraph:(id)sender {
    
    if (![JSTPrefs boolForKey:@"optionNumberIncrement"] || (([NSEvent modifierFlags] & NSAlternateKeyMask) != 0)) {
        [super moveToEndOfParagraph:sender];
    }
}

- (void)moveToBeginningOfParagraph:(id)sender {
    if (![JSTPrefs boolForKey:@"optionNumberIncrement"] || (([NSEvent modifierFlags] & NSAlternateKeyMask) != 0)) {
        [super moveToBeginningOfParagraph:sender];
    }
}
*/
/*
- (void)moveDown:(id)sender {
    debug(@"%s:%d", __FUNCTION__, __LINE__);
}

- (void)moveDownAndModifySelection:(id)sender {
    debug(@"%s:%d", __FUNCTION__, __LINE__);
}
*/
// Mimic BBEdit's option-delete behavior, which is THE WAY IT SHOULD BE DONE

- (void)deleteWordForward:(id)sender {
    
    NSRange r = [self selectedRange];
    NSUInteger textLength = [[self textStorage] length];
    
    if (r.length || (NSMaxRange(r) >= textLength)) {
        [super deleteWordForward:sender];
        return;
    }
    
    // delete the whitespace forward.
    
    NSRange paraRange = [self selectionRangeForProposedRange:r granularity:NSSelectByParagraph];
    
    NSUInteger diff = r.location - paraRange.location;
    
    paraRange.location += diff;
    paraRange.length   -= diff;
    
    NSString *foo = [[[self textStorage] string] substringWithRange:paraRange];
    
    NSUInteger len = 0;
    while ([foo characterAtIndex:len] == ' ' && len < paraRange.length) {
        len++;
    }
    
    if (!len) {
        [super deleteWordForward:sender];
        return;
    }
    
    r.length = len;
    
    if ([self shouldChangeTextInRange:r replacementString:@""]) { // auto undo.
        [self replaceCharactersInRange:r withString:@""];
    }
}

- (void)deleteBackward:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(textView:doCommandBySelector:)]) {
        // If the delegate wants a crack at command selectors, give it a crack at the standard selector too.
        if ([[self delegate] textView:self doCommandBySelector:@selector(deleteBackward:)]) {
            return;
        }
    }
    else {
        NSRange charRange = [self rangeForUserTextChange];
        if (charRange.location != NSNotFound) {
            if (charRange.length > 0) {
                // Non-zero selection.  Delete normally.
                [super deleteBackward:sender];
            } else {
                if (charRange.location == 0) {
                    // At beginning of text.  Delete normally.
                    [super deleteBackward:sender];
                } else {
                    NSString *string = [self string];
                    NSRange paraRange = [string lineRangeForRange:NSMakeRange(charRange.location - 1, 1)];
                    if (paraRange.location == charRange.location) {
                        // At beginning of line.  Delete normally.
                        [super deleteBackward:sender];
                    } else {
                        unsigned tabWidth = 4; //[[TEPreferencesController sharedPreferencesController] tabWidth];
                        unsigned indentWidth = 4;// [[TEPreferencesController sharedPreferencesController] indentWidth];
                        BOOL usesTabs = NO; //[[TEPreferencesController sharedPreferencesController] usesTabs];
                        NSRange leadingSpaceRange = paraRange;
                        unsigned leadingSpaces = TE_numberOfLeadingSpacesFromRangeInString(string, &leadingSpaceRange, tabWidth);
                        
                        if (charRange.location > NSMaxRange(leadingSpaceRange)) {
                            // Not in leading whitespace.  Delete normally.
                            [super deleteBackward:sender];
                        } else {
                            NSTextStorage *text = [self textStorage];
                            unsigned leadingIndents = leadingSpaces / indentWidth;
                            NSString *replaceString;
                            
                            // If we were indented to an fractional level just go back to the last even multiple of indentWidth, if we were exactly on, go back a full level.
                            if (leadingSpaces % indentWidth == 0) {
                                leadingIndents--;
                            }
                            leadingSpaces = leadingIndents * indentWidth;
                            replaceString = ((leadingSpaces > 0) ? TE_tabbifiedStringWithNumberOfSpaces(leadingSpaces, tabWidth, usesTabs) : @"");
                            if ([self shouldChangeTextInRange:leadingSpaceRange replacementString:replaceString]) {
                                NSDictionary *newTypingAttributes;
                                if (charRange.location < [string length]) {
                                    newTypingAttributes = [text attributesAtIndex:charRange.location effectiveRange:NULL];
                                } else {
                                    newTypingAttributes = [text attributesAtIndex:(charRange.location - 1) effectiveRange:NULL];
                                }
                                
                                [text replaceCharactersInRange:leadingSpaceRange withString:replaceString];
                                
                                [self setTypingAttributes:newTypingAttributes];
                                
                                [self didChangeText];
                            }
                        }
                    }
                }
            }
        }
    }
}



- (void)TE_doUserIndentByNumberOfLevels:(int)levels {
    // Because of the way paragraph ranges work we will add spaces a final paragraph separator only if the selection is an insertion point at the end of the text.
    // We ask for rangeForUserTextChange and extend it to paragraph boundaries instead of asking rangeForUserParagraphAttributeChange because this is not an attribute change and we don't want it to be affected by the usesRuler setting.
    NSRange charRange = [[self string] lineRangeForRange:[self rangeForUserTextChange]];
    NSRange selRange = [self selectedRange];
    if (charRange.location != NSNotFound) {
        NSTextStorage *textStorage = [self textStorage];
        NSAttributedString *newText;
        unsigned tabWidth = 4;
        unsigned indentWidth = 4;
        BOOL usesTabs = NO;
        
        selRange.location -= charRange.location;
        newText = TE_attributedStringByIndentingParagraphs([textStorage attributedSubstringFromRange:charRange], levels,  &selRange, [self typingAttributes], tabWidth, indentWidth, usesTabs);
        
        selRange.location += charRange.location;
        if ([self shouldChangeTextInRange:charRange replacementString:[newText string]]) {
            [[textStorage mutableString] replaceCharactersInRange:charRange withString:[newText string]];
            //[textStorage replaceCharactersInRange:charRange withAttributedString:newText];
            [self setSelectedRange:selRange];
            [self didChangeText];
        }
    }
}


- (void)shiftLeft:(id)sender {
    [self TE_doUserIndentByNumberOfLevels:-1];
}

- (void)shiftRight:(id)sender {
    [self TE_doUserIndentByNumberOfLevels:1];
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {
    NSTextView *textView = [notification object];
    NSRange selRange = [textView selectedRange];
    //TEPreferencesController *prefs = [TEPreferencesController sharedPreferencesController];
    
    //if ([prefs selectToMatchingBrace]) {
    if (YES) {
        // The NSTextViewDidChangeSelectionNotification is sent before the selection granularity is set.  Therefore we can't tell a double-click by examining the granularity.  Fortunately there's another way.  The mouse-up event that ended the selection is still the current event for the app.  We'll check that instead.  Perhaps, in an ideal world, after checking the length we'd do this instead: ([textView selectionGranularity] == NSSelectByWord).
        if ((selRange.length == 1) && ([[NSApp currentEvent] type] == NSLeftMouseUp) && ([[NSApp currentEvent] clickCount] == 2)) {
            NSRange matchRange = TE_findMatchingBraceForRangeInString(selRange, [textView string]);
            
            if (matchRange.location != NSNotFound) {
                selRange = NSUnionRange(selRange, matchRange);
                [textView setSelectedRange:selRange];
                [textView scrollRangeToVisible:matchRange];
            }
        }
    }
    
    //if ([prefs showMatchingBrace]) {
    if (YES) {
        NSRange oldSelRangePtr;
        
        [[[notification userInfo] objectForKey:@"NSOldSelectedCharacterRange"] getValue:&oldSelRangePtr];
        
        // This test will catch typing sel changes, also it will catch right arrow sel changes, which I guess we can live with.  MF:??? Maybe we should catch left arrow changes too for consistency...
        if ((selRange.length == 0) && (selRange.location > 0) && ([[NSApp currentEvent] type] == NSKeyDown) && (oldSelRangePtr.location == selRange.location - 1)) {
            NSRange origRange = NSMakeRange(selRange.location - 1, 1);
            unichar origChar = [[textView string] characterAtIndex:origRange.location];
            
            if (TE_isClosingBrace(origChar)) {
                NSRange matchRange = TE_findMatchingBraceForRangeInString(origRange, [textView string]);
                if (matchRange.location != NSNotFound) {
                    
                    // do this with a delay, since for some reason it only works when we use the arrow keys otherwise.
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showFindIndicatorForRange:matchRange];
                        });
                    });
                }
            }
        }
    }
}



- (NSRange)selectionRangeForProposedRange:(NSRange)proposedSelRange granularity:(NSSelectionGranularity)granularity {
    
    // check for cases where we've got: [foo setValue:bar forKey:"x"]; and we double click on setValue.  The default way NSTextView does the selection
    // is to have it highlight all of setValue:bar, which isn't what we want.  So.. we mix it up a bit.
    // There's probably a better way to do this, but I don't currently know what it is.
    
    if (granularity == NSSelectByWord && ([[NSApp currentEvent] type] == NSLeftMouseUp || [[NSApp currentEvent] type] == NSLeftMouseDown) && [[NSApp currentEvent] clickCount] > 1) {
        
        NSRange r           = [super selectionRangeForProposedRange:proposedSelRange granularity:granularity];
        NSString *s         = [[[self textStorage] mutableString] substringWithRange:r];
        NSRange colLocation = [s rangeOfString:@":"];
        
        if (colLocation.location != NSNotFound) {
            
            if (proposedSelRange.location > (r.location + colLocation.location)) {
                r.location = r.location + colLocation.location + 1;
                r.length = [s length] - colLocation.location - 1;
            }
            else {
                r.length = colLocation.location;
            }
        }
        
        return r;
    }
    
    return [super selectionRangeForProposedRange:proposedSelRange granularity:granularity];
}

- (void)setInsertionPointFromDragOpertion:(id <NSDraggingInfo>)sender {
    
    NSLayoutManager *layoutManager = [self layoutManager];
    NSTextContainer *textContainer = [self textContainer];
    
    NSUInteger glyphIndex, charIndex, length = [[self textStorage] length];
    NSPoint point = [self convertPoint:[sender draggingLocation] fromView:nil];
    
    // Convert those coordinates to the nearest glyph index
    glyphIndex = [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];
    
    // Convert the glyph index to a character index
    charIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    
    // put the selection where we have the mouse.
    if (charIndex == (length - 1)) {
        [self setSelectedRange:NSMakeRange(charIndex+1, 0)];
        //[self setSelectedRange:NSMakeRange(charIndex, 0)];
    }
    else {
        [self setSelectedRange:NSMakeRange(charIndex, 0)];
    }
    
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    
    if (([NSEvent modifierFlags] & NSAlternateKeyMask) != 0) {
        
        [self setInsertionPointFromDragOpertion:sender];
        
        NSPasteboard *paste = [sender draggingPasteboard];
        NSArray *fileArray = [paste propertyListForType:NSFilenamesPboardType];
        
        for (NSString *path in fileArray) {
            
            [self insertText:[NSString stringWithFormat:@"[NSURL fileURLWithPath:\"%@\"]", path]];
            
            if ([fileArray count] > 1) {
                [self insertNewline:nil];
            }
        }
        
        return YES;
    }
    
    return [super performDragOperation:sender];
}


#pragma mark - NSResponder methods

- (void)mouseMoved:(NSEvent *)theEvent {
    
    // only do this if only the command key is down.
    if ((GetCurrentKeyModifiers() != cmdKey)) {
        [super mouseMoved:theEvent];
        return;
    }
    
    [[self textStorage] removeAttribute:NSBackgroundColorAttributeName range:self.currentlyHighlightedRange];
    NSUInteger character = [self characterIndexForPoint:[NSEvent mouseLocation]];
    
    NSRange range = [self numberStringRangeForCharacterIndex:character];
    if (range.location == NSNotFound) {
        if (_currentlyHighlightedRange.location != NSNotFound) {
            // Only change this when it's not already set... skip some work, I suppose.
            self.currentlyHighlightedRange = range;
        }
        [[NSCursor arrowCursor] set];
        return;
    }
    
    // Found a number under the cursor
    self.currentlyHighlightedRange = range;
    NSColor *fontColor = [NSColor colorWithCalibratedRed:0.742 green:0.898 blue:0.397 alpha:1.000];
    [[self textStorage] addAttribute:NSBackgroundColorAttributeName value:fontColor range:range];
    
    // Show we can drag the number
    [[NSCursor resizeLeftRightCursor] set];
}


- (void)mouseDown:(NSEvent *)theEvent {
    if (self.currentlyHighlightedRange.location == NSNotFound) {
        [super mouseDown:theEvent];
        return;
    }
    
    if ((GetCurrentKeyModifiers() != cmdKey)) {
        [super mouseDown:theEvent];
        return;
    }
    
    self.initialDragPoint = [NSEvent mouseLocation];
    NSString *initialString = [[self string] substringWithRange:self.currentlyHighlightedRange];
    self.initialNumber = [self numberFromString:initialString];
    
    NSString *wholeText = [self string];
    self.initialNumberRange = self.currentlyHighlightedRange;
    

    NSRange originalCommandRange = [wholeText lineRangeForRange:self.currentlyHighlightedRange];
    self.initialDragCommandRange = originalCommandRange;
}


- (void)mouseDragged:(NSEvent *)theEvent {
    
    // Skip it if we're not currently dragging a number
    if (self.currentlyHighlightedRange.location == NSNotFound) {
        [super mouseDragged:theEvent];
        return;
    }
    
    
    if ((GetCurrentKeyModifiers() != cmdKey)) {
        [super mouseDragged:theEvent];
        return;
    }
    
    NSRange numberRange = [self rangeForNumberNearestToIndex:self.currentlyHighlightedRange.location];
    NSString *numberString = [[self string] substringWithRange:numberRange];
    

    NSNumber *number = [self numberFromString:numberString];
    
    if (nil == number) {
        NSLog(@"Couldn't parse a number out of :%@", numberString);
        return;
    }
    
    CGPoint screenPoint = [NSEvent mouseLocation];
    CGFloat x = screenPoint.x - self.initialDragPoint.x;
    CGFloat y = screenPoint.y - self.initialDragPoint.y;
    CGSize offset = CGSizeMake(x, y);
    
    
    NSInteger offsetValue = [self.initialNumber integerValue] + (NSInteger)offset.width;
    NSNumber *updatedNumber = @(offsetValue);
    NSString *updatedNumberString = [updatedNumber stringValue];
    
    [[self textStorage] replaceCharactersInRange:self.currentlyHighlightedRange withString:updatedNumberString];
    
    
    self.currentlyHighlightedRange = NSMakeRange(self.currentlyHighlightedRange.location, [updatedNumberString length]);
    
    
    if (self.numberDragHandler) {
        self.numberDragHandler(self, [self currentLineForRange:self.currentlyHighlightedRange]);
    }
}


- (void)mouseUp:(NSEvent *)theEvent {
    // Skip it if we're not currently dragging a word
    if (self.currentlyHighlightedRange.location == NSNotFound) {
        [super mouseUp:theEvent];
        return;
    }
    
    if ((GetCurrentKeyModifiers() != cmdKey)) {
        [super mouseUp:theEvent];
        return;
    }
    
    // Triggers clearing out our number-dragging state.
    [self parseCode:nil];
    [self mouseMoved:theEvent];
    
    
    self.initialNumber = nil;
    self.initialDragCommandRange = NSMakeRange(NSNotFound, NSNotFound);
}


#pragma mark - Number dragging helpers

- (void)setNumberString:(NSString *)string forRange:(NSRange)numberRange {
    // Just store the start location of the number, because the length might change (if, say, number goes from 100 -> 99)
    self.numberRanges[NSStringFromRange(numberRange)] = string;
}

- (NSRange)numberStringRangeForCharacterIndex:(NSUInteger)character {
    for (NSString *rangeString in self.numberRanges) {
        NSRange range = NSRangeFromString(rangeString);
        if (NSLocationInRange(character, range)) {
            return range;
        }
        
    }
    return NSMakeRange(NSNotFound, 0);
}

- (NSNumber *)numberFromString:(NSString *)string {
    static NSNumberFormatter *formatter = nil;
    if (nil == formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setAllowsFloats:YES];
    }
    return [formatter numberFromString:string];
}


- (NSRange)rangeForNumberNearestToIndex:(NSUInteger)index {
    // parse this out right now...
    NSRange originalRange = self.initialDragCommandRange;
    
    // Gets the line in range as it is currently in the textview's string
    NSString *currentLine = [self currentLineForRange:originalRange];
    
    TDTokenizer *tokenizer = [TDTokenizer tokenizerWithString:currentLine];
    
    tokenizer.commentState.reportsCommentTokens = YES;
    tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
    
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *token = nil;
    
    
    NSUInteger currentLocation = 0; // in the command!
    
    while ((token = [tokenizer nextToken]) != eof) {
        
        NSRange numberRange = NSMakeRange(currentLocation + originalRange.location, [[token stringValue] length]);
        
        if ([token isNumber]) {
            if (NSLocationInRange(index, numberRange)) {
                return numberRange;
            }
        }
        
        
        currentLocation += [[token stringValue] length];
        
    }
    return NSMakeRange(NSNotFound, NSNotFound);
}


- (NSString *)currentLineForRange:(NSRange)originalRange {
    
    NSString *wholeString = [self string];
    
    NSRange lineRange = [wholeString lineRangeForRange:originalRange];
    return [wholeString substringWithRange:lineRange];
}


@end

// stolen from NSTextStorage_TETextExtras.m
@implementation NSTextStorage (TETextExtras)

- (BOOL)_usesProgrammingLanguageBreaks {
    return YES;
}
@end
