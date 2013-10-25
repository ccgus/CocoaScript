// TETextUtils.m
// TextExtras
//
// Copyright © 1996-2006, Mike Ferris.
// All rights reserved.

#import "TETextUtils.h"
#import <objc/objc-runtime.h>

// ********************** Identifying paragraph boundaries **********************

BOOL TE_IsParagraphSeparator(unichar uchar, NSString *str, unsigned index) {
    // This function redundantly takes both the character and the string and index.  This is because often we only have to look at that one character and usually we already have it when this is called (usually from a source cheaper than characterAtIndex: too.)
    // Returns yes if the unichar given is a hard line break, that is it will always cause a new line fragment to begin.
    // MF:??? Is this test complete?
    if ((uchar == (unichar)'\n') || (uchar == NSParagraphSeparatorCharacter)) {
        return YES;
    } else if ((uchar == (unichar)'\r') && ((index+1 >= [str length]) || ([str characterAtIndex:index+1] != (unichar)'\n'))) {
        return YES;
    }
    return NO;
}

BOOL TE_IsHardLineBreakUnichar(unichar uchar, NSString *str, unsigned index) {
    // This function redundantly takes both the character and the string and index.  This is because often we only have to look at that one character and usually we already have it when this is called (usually from a source cheaper than characterAtIndex: too.)
    // Returns yes if the unichar given is a hard line break, that is it will always cause a new line fragment to begin.
    // MF:??? Is this test complete?
    if ((uchar == (unichar)'\n') || (uchar == NSParagraphSeparatorCharacter) || (uchar == NSLineSeparatorCharacter)) {
        return YES;
    } else if ((uchar == (unichar)'\r') && ((index+1 >= [str length]) || ([str characterAtIndex:index+1] != (unichar)'\n'))) {
        return YES;
    }
    return NO;
}

// ********************** Space/Tab related utilities **********************

unsigned TE_numberOfLeadingSpacesFromRangeInString(NSString *string, NSRange *range, unsigned tabWidth) {
    // Returns number of spaces, accounting for expanding tabs.
    NSRange searchRange = (range ? *range : NSMakeRange(0, [string length]));
    unichar buff[100];
    unsigned i = 0;
    unsigned spaceCount = 0;
    BOOL done = NO;
    unsigned tabW = tabWidth;
    NSUInteger endOfWhiteSpaceIndex = NSNotFound;

    if (range->length == 0) {
        return 0;
    }
    
    while ((searchRange.length > 0) && !done) {
        [string getCharacters:buff range:NSMakeRange(searchRange.location, ((searchRange.length > 100) ? 100 : searchRange.length))];
        for (i=0; i < ((searchRange.length > 100) ? 100 : searchRange.length); i++) {
            if (buff[i] == (unichar)' ') {
                spaceCount++;
            } else if (buff[i] == (unichar)'\t') {
                // MF:!!! Perhaps this should account for the case of 2 spaces follwed by a tab really being visually equivalent to 8 spaces (for 8 space tabs) and not 10 spaces.
                spaceCount += tabW;
            } else {
                done = YES;
                endOfWhiteSpaceIndex = searchRange.location + i;
                break;
            }
        }
        searchRange.location += ((searchRange.length > 100) ? 100 : searchRange.length);
        searchRange.length -= ((searchRange.length > 100) ? 100 : searchRange.length);
    }
    if (range && (endOfWhiteSpaceIndex != NSNotFound)) {
        range->length = endOfWhiteSpaceIndex - range->location;
    }
    return spaceCount;
}

NSString *TE_tabbifiedStringWithNumberOfSpaces(unsigned origNumSpaces, unsigned tabWidth, BOOL usesTabs) {
    static NSMutableString *sharedString = nil;
    static unsigned numTabs = 0;
    static unsigned numSpaces = 0;

    int diffInTabs;
    int diffInSpaces;

    // TabWidth of 0 means don't use tabs!
    if (!usesTabs || (tabWidth == 0)) {
        diffInTabs = 0 - numTabs;
        diffInSpaces = origNumSpaces - numSpaces;
    } else {
        diffInTabs = (origNumSpaces / tabWidth) - numTabs;
        diffInSpaces = (origNumSpaces % tabWidth) - numSpaces;
    }
    
    if (!sharedString) {
        sharedString = [[NSMutableString alloc] init];
    }
    
    if (diffInTabs < 0) {
        [sharedString deleteCharactersInRange:NSMakeRange(0, -diffInTabs)];
    } else {
        unsigned numToInsert = diffInTabs;
        while (numToInsert > 0) {
            [sharedString replaceCharactersInRange:NSMakeRange(0, 0) withString:@"\t"];
            numToInsert--;
        }
    }
    numTabs += diffInTabs;

    if (diffInSpaces < 0) {
        [sharedString deleteCharactersInRange:NSMakeRange(numTabs, -diffInSpaces)];
    } else {
        unsigned numToInsert = diffInSpaces;
        while (numToInsert > 0) {
            [sharedString replaceCharactersInRange:NSMakeRange(numTabs, 0) withString:@" "];
            numToInsert--;
        }
    }
    numSpaces += diffInSpaces;

    return sharedString;
}

NSArray *TE_tabStopArrayForFontAndTabWidth(NSFont *font, unsigned tabWidth) {
    static NSMutableArray *array = nil;
    static float currentWidthOfTab = -1;
    float charWidth;
    float widthOfTab;
    unsigned i;
    
    /*
    if ([font glyphIsEncoded:(NSGlyph)' ']) {
        charWidth = [font advancementForGlyph:(NSGlyph)' '].width;
    } else {*/
        charWidth = [font maximumAdvancement].width;
    //}
    widthOfTab = (charWidth * tabWidth);
    
    if (!array) {
        array = [[NSMutableArray allocWithZone:NULL] initWithCapacity:100];
    }

    if (widthOfTab != currentWidthOfTab) {
        //NSLog(@"TextExtras: Calculating tabstops for font %@, tabWidth %u, real width %f.", font, tabWidth, widthOfTab);
        [array removeAllObjects];
        for (i = 1; i <= 100; i++) {
            NSTextTab *tab = [[NSTextTab alloc] initWithType:NSLeftTabStopType location:widthOfTab * i];
            [array addObject:tab];
        }
        currentWidthOfTab = widthOfTab;
    }
    
    return array;
}

extern NSRange TE_rangeOfLineWithLeadingWhiteSpace(NSString *string, NSRange startRange, unsigned leadingSpaces, NSComparisonResult matchStyle, BOOL backwardFlag, unsigned tabWidth) {
    NSRange searchRange;
    NSRange curRange, tempRange;
    NSUInteger len = [string length];
    unsigned curSpaces;
    
    // Expand startRange to paragraph boundaries
    startRange = [string lineRangeForRange:startRange];

    // Set up search range
    if (backwardFlag) {
        searchRange = NSMakeRange(0, startRange.location);
    } else {
        searchRange = NSMakeRange(NSMaxRange(startRange), len - NSMaxRange(startRange));
    }

    while (searchRange.length > 0) {
        // Get the next candidate line range.
        if (backwardFlag) {
            curRange = [string lineRangeForRange:NSMakeRange(NSMaxRange(searchRange) - 1, 1)];
        } else {
            curRange = [string lineRangeForRange:NSMakeRange(searchRange.location, 1)];
        }

        // See if curLine matches.
        tempRange = curRange;
        curSpaces = TE_numberOfLeadingSpacesFromRangeInString(string, &tempRange, tabWidth);
        if (matchStyle == NSOrderedDescending) {
            // Looking for a line with less than leadingSpaces spaces
            if (curSpaces < leadingSpaces) {
                return curRange;
            }
        } else if (matchStyle == NSOrderedSame) {
            // Looking for a line with exactly leadingSpaces spaces
            if (curSpaces == leadingSpaces) {
                return curRange;
            }
        } else {
            // Looking for a line with more than leadingSpaces spaces
            if (curSpaces > leadingSpaces) {
                return curRange;
            }
        }
        
        // Adjust search range.
        if (backwardFlag) {
            searchRange = NSMakeRange(0, curRange.location);
        } else {
            searchRange = NSMakeRange(NSMaxRange(curRange), len - NSMaxRange(curRange));
        }
    }
    // Found no match, return beginning or end of text
    if (backwardFlag) {
        return NSMakeRange(0, 0);
    } else {
        return NSMakeRange(len, 0);
    }
}

// ********************** Nest/Unnest feature support **********************

static void indentParagraphRangeInAttributedString(NSRange range, NSMutableAttributedString *attrString, int levels, NSRange *selRange, NSDictionary *defaultAttrs, unsigned tabWidth, unsigned indentWidth, BOOL usesTabs) {
    NSRange leadingSpaceRange = range;
    unsigned numSpaces = TE_numberOfLeadingSpacesFromRangeInString([attrString string], &leadingSpaceRange, tabWidth);
    NSString *newWhitespace;
    NSUInteger newWhitespaceLength;
    int curLevels;
    
    curLevels = numSpaces / indentWidth;
    if ((levels < 0) && (numSpaces % indentWidth != 0)) {
        curLevels++;
    }
    curLevels += levels;
    if (curLevels < 0) {
        curLevels = 0;
    }
    numSpaces = curLevels * indentWidth;

    newWhitespace = TE_tabbifiedStringWithNumberOfSpaces(numSpaces, tabWidth, usesTabs);
    newWhitespaceLength = [newWhitespace length];
    
    // Adjust the selection
    if (NSMaxRange(leadingSpaceRange) <= selRange->location) {
        // Change occurs entirely before selection.  Adjust selection location.
        selRange->location += (newWhitespaceLength - leadingSpaceRange.length);
    } else if (NSMaxRange(*selRange) > leadingSpaceRange.location) {
        // Change is not entirely before selection, and not entirely after.
        BOOL overlapBefore = ((leadingSpaceRange.location < selRange->location) ? YES : NO);
        BOOL overlapAfter = ((NSMaxRange(leadingSpaceRange) > NSMaxRange(*selRange)) ? YES : NO);
        if (!overlapBefore && !overlapAfter) {
            // Change is entirely within the selection.  Adjust selection length.
            selRange->length += (newWhitespaceLength - leadingSpaceRange.length);
        } else if (overlapBefore && overlapAfter) {
            // The range being changed completely encompasses the selection.  New selection is insertion point after change.
            *selRange = NSMakeRange(leadingSpaceRange.location + newWhitespaceLength, 0);
        } else if (overlapBefore) {
            // overlapBefore && !overlapAfter
            // Bring in the selection at the front to avoid the overlap.
            *selRange = NSMakeRange(leadingSpaceRange.location + newWhitespaceLength, NSMaxRange(*selRange) - NSMaxRange(leadingSpaceRange));
        } else {
            // overlapAfter && !overlapBefore
            // Push out the selection at the end to include the whole chage.
            *selRange = NSMakeRange(selRange->location, leadingSpaceRange.location + newWhitespaceLength - selRange->location);
        }
    } else {
        // Change occurs entirely after selection.  Do nothing unless selection is an insertion point immediately before the change.
        if ((selRange->length == 0) && (selRange->location == leadingSpaceRange.location)) {
            // An insertion point immediately prior to the change means it was at the beginning of the line that we're indenting.  It is usually desirable to have the insertion point end up after the modified leading whitespace in this case.
            *selRange = NSMakeRange(leadingSpaceRange.location + newWhitespaceLength, 0);
        }
    }
    [attrString replaceCharactersInRange:leadingSpaceRange withString:newWhitespace];
    [attrString setAttributes:defaultAttrs range:NSMakeRange(leadingSpaceRange.location, [newWhitespace length])];
}

NSAttributedString *TE_attributedStringByIndentingParagraphs(NSAttributedString *origString, int levels,  NSRange *selRange, NSDictionary *defaultAttrs, unsigned tabWidth, unsigned indentWidth, BOOL usesTabs) {
    NSMutableAttributedString *newString = [origString mutableCopy];
    NSRange paraRange;
    
    if ([newString length] == 0) {
        // This basically means the selection was at the end of a doc with an extra line frag.  In this special case where that's all that's selected, we'll add spaces to the extra line.
        paraRange = NSMakeRange(0, 0);
        indentParagraphRangeInAttributedString(paraRange, newString, levels, selRange, defaultAttrs, tabWidth, indentWidth, usesTabs);
    } else {
        // We'll run through the range by paragraphs, backwards, so we don't have to care about changes being made to each paragraph as we go.
        paraRange = [[newString string] lineRangeForRange:NSMakeRange([newString length] - 1, 1)];
        while (1) {
            indentParagraphRangeInAttributedString(paraRange, newString, levels, selRange, defaultAttrs, tabWidth, indentWidth, usesTabs);
            if (paraRange.location == 0) {
                // We're done
                break;
            } else {
                // Find range of previous paragraph
                paraRange = [[newString string] lineRangeForRange:NSMakeRange(paraRange.location - 1, 1)];
            }
        }
    }
    
    return newString;
}

// ********************** Brace matching utilities **********************

enum {
    OpeningLatinQuoteCharacter = 0x00AB,
    ClosingLatinQuoteCharacter = 0x00BB,
};

static NSString *defaultOpeningBraces = @"{[(";
static NSString *defaultClosingBraces = @"}])";

static NSString *openingBraces = nil;
static NSString *closingBraces = nil;

#define NUM_BRACE_PAIRS ([openingBraces length])

static void initBraces() {
    if (!openingBraces) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *defStr;

        defStr = [defaults objectForKey:@"TEOpeningBracesCharacters"];
        if (defStr) {
            openingBraces = defStr;
            defStr = [defaults objectForKey:@"TEClosingBracesCharacters"];
            closingBraces = defStr;
            if (!closingBraces || ([openingBraces length] != [closingBraces length])) {
                NSLog(@"TextExtras: Values for user defaults keys TEOpeningBracesCharacters and TEClosingBracesCharacters must both be present and the same length if either one is set.");
                openingBraces = nil;
                closingBraces = nil;
            }
        }

        if (!openingBraces) {
            unichar charBuf[100];
            NSUInteger defLen;

            defLen = [defaultOpeningBraces length];
            [defaultOpeningBraces getCharacters:charBuf];
            charBuf[defLen++] = OpeningLatinQuoteCharacter;
            openingBraces = [[NSMutableString allocWithZone:NULL] initWithCharacters:charBuf length:defLen];

            defLen = [defaultClosingBraces length];
            [defaultClosingBraces getCharacters:charBuf];
            charBuf[defLen++] = ClosingLatinQuoteCharacter;
            closingBraces = [[NSMutableString allocWithZone:NULL] initWithCharacters:charBuf length:defLen];
        }
    }
}

unichar TE_matchingDelimiter(unichar delimiter) {
    // This is not very efficient or anything, but the list of delimiters is expected to be quite short.
    NSUInteger i, c;

    initBraces();

    c = NUM_BRACE_PAIRS;
    for (i=0; i<c; i++) {
        if (delimiter == [openingBraces characterAtIndex:i]) {
            return [closingBraces characterAtIndex:i];
        }
        if (delimiter == [closingBraces characterAtIndex:i]) {
            return [openingBraces characterAtIndex:i];
        }
    }
    return (unichar)0;
}

BOOL TE_isOpeningBrace(unichar delimiter) {
    // This is not very efficient or anything, but the list of delimiters is expected to be quite short.
    NSUInteger i, c = NUM_BRACE_PAIRS;

    initBraces();

    for (i=0; i<c; i++) {
        if (delimiter == [openingBraces characterAtIndex:i]) {
            return YES;
        }
    }
    return NO;
}

BOOL TE_isClosingBrace(unichar delimiter) {
    // This is not very efficient or anything, but the list of delimiters is expected to be quite short.
    NSUInteger i, c = NUM_BRACE_PAIRS;

    initBraces();

    for (i=0; i<c; i++) {
        if (delimiter == [closingBraces characterAtIndex:i]) {
            return YES;
        }
    }
    return NO;
}

#define STACK_DEPTH 100
#define BUFF_SIZE 512

NSRange TE_findMatchingBraceForRangeInString(NSRange origRange, NSString *string) {
    // Note that this delimiter matching does not treat delimiters inside comments and quoted delimiters specially at all.
    NSRange matchRange = NSMakeRange(NSNotFound, 0);
    unichar selChar = [string characterAtIndex:origRange.location];
    BOOL backwards;

    // Figure out if we're doing anything and which direction to do it in...
    if (TE_isOpeningBrace(selChar)) {
        backwards = NO;
    } else if (TE_isClosingBrace(selChar)) {
        backwards = YES;
    } else {
        return matchRange;
    }

    {
        unichar delimiterStack[STACK_DEPTH];
        NSUInteger stackCount = 0;
        NSRange searchRange, buffRange;
        unichar buff[BUFF_SIZE];
        NSInteger i;
        BOOL done = NO;
        BOOL push = NO, pop = NO;

        delimiterStack[stackCount++] = selChar;

        if (backwards) {
            searchRange = NSMakeRange(0, origRange.location);
        } else {
            searchRange = NSMakeRange(NSMaxRange(origRange), [string length] - NSMaxRange(origRange));
        }
        // This loops over all the characters in searchRange, going either backwards or forwards.
        while ((searchRange.length > 0) && !done) {
            // Fill the buffer with a chunk of the searchRange
            if (searchRange.length <= BUFF_SIZE) {
                buffRange = searchRange;
            } else {
                if (backwards) {
                    buffRange = NSMakeRange(NSMaxRange(searchRange) - BUFF_SIZE, BUFF_SIZE);
                } else {
                    buffRange = NSMakeRange(searchRange.location, BUFF_SIZE);
                }
            }
            [string getCharacters:buff range:buffRange];
            
            // This loops over all the characters in buffRange, going either backwards or forwards.
            for (i = (backwards ? (buffRange.length - 1) : 0); (!done && (backwards ? (i >= 0) : (i < buffRange.length))); (backwards ? i-- : i++)) {
                // Figure out if we need to push or pop the stack.
                if (backwards) {
                    push = TE_isClosingBrace(buff[i]);
                    pop = TE_isOpeningBrace(buff[i]);
                } else {
                    push = TE_isOpeningBrace(buff[i]);
                    pop = TE_isClosingBrace(buff[i]);
                }

                // Now do the push or pop, if any
                if (pop) {
                    if (delimiterStack[--stackCount] != TE_matchingDelimiter(buff[i])) {
                        // Might want to beep here?
                        done = YES;
                    } else if (stackCount == 0) {
                        matchRange = NSMakeRange(buffRange.location + i, 1);
                        done = YES;
                    }
                } else if (push) {
                    if (stackCount < STACK_DEPTH) {
                        delimiterStack[stackCount++] = buff[i];
                    } else {
                        NSLog(@"TextExtras: Exhausted stack depth for delimiter matching.  Giving up.");
                        done = YES;
                    }
                }
            }
            
            // Remove the buffRange from the searchRange.
            if (!backwards) {
                searchRange.location += buffRange.length;
            }
            searchRange.length -= buffRange.length;
        }
    }

    return matchRange;
}

// Variable substitution

unsigned TE_expandVariablesInString(NSMutableString *input, NSString *variableStart, NSString *variableEnd, id modalDelegate, SEL callbackSelector, void *context) {
    // Variable references must begin with variableStart and end with variableEnd.  There's no support for "escaping" the end string.
    // callbackSelector must have the following signature:
    //     - (NSString *)expansionForVariableName:(NSString *)name inputString:(NSString *)input variableNameRange:(NSRange)nameRange fullVariableRange:(NSRange)fullRange context:(void *)context;
    // The return value is the replacement for the whole variable reference
    NSRange searchRange = NSMakeRange(0, [input length]);
    NSRange startRange;
    NSRange endRange;
    NSRange varRange;
    NSString *varName;
    unsigned count = 0;
    NSString *replacement;
    NSRange replacementRange;

#if 0
    NSMethodSignature *methodSig = nil;
    NSInvocation *invocation = nil;
#endif
    
    startRange = [input rangeOfString:variableStart options:NSLiteralSearch range:searchRange];
    while (startRange.length > 0) {
        searchRange = NSMakeRange(NSMaxRange(startRange), NSMaxRange(searchRange) - NSMaxRange(startRange));
        endRange = [input rangeOfString:variableEnd options:NSLiteralSearch range:searchRange];
        varRange = NSMakeRange(NSMaxRange(startRange), endRange.location - NSMaxRange(startRange));
        varName = [input substringWithRange:varRange];
        replacementRange = NSMakeRange(startRange.location, NSMaxRange(endRange) - startRange.location);

#if 0
        if (!invocation) {
            methodSig = [modalDelegate methodSignatureForSelector:callbackSelector];
            invocation = [NSInvocation invocationWithMethodSignature:methodSig];
            [invocation setTarget:modalDelegate];
            [invocation setSelector:callbackSelector];
            [invocation setArgument:&input atIndex:1];
            [invocation setArgument:&context atIndex:4];
        }
        
        [invocation setArgument:&varName atIndex:0];
        [invocation setArgument:&varRange atIndex:2];
        [invocation setArgument:&replacementRange atIndex:3];
        [invocation invoke];
        replacement = nil;
        [invocation getReturnValue:&replacement];
#else
        replacement = objc_msgSend(modalDelegate, callbackSelector, varName, input, varRange, replacementRange, context);
#endif
        
        if (replacement) {
            count++;
            [input replaceCharactersInRange:replacementRange withString:replacement];
            replacementRange.length = [replacement length];
        }
        searchRange = NSMakeRange(NSMaxRange(replacementRange), [input length] - NSMaxRange(replacementRange));
        startRange = [input rangeOfString:variableStart options:NSLiteralSearch range:searchRange];
    }

    return count;
}
