// TETextUtils.h
// TextExtras
//
// Copyright © 1996-2006, Mike Ferris.
// All rights reserved.

#import <Cocoa/Cocoa.h>

// Identifying paragraph boundaries
extern BOOL TE_IsParagraphSeparator(unichar uchar, NSString *str, unsigned index);
extern BOOL TE_IsHardLineBreakUnichar(unichar uchar, NSString *str, unsigned index);

// Space/Tab utilities
extern unsigned TE_numberOfLeadingSpacesFromRangeInString(NSString *string, NSRange *range, unsigned tabWidth);
extern NSString *TE_tabbifiedStringWithNumberOfSpaces(unsigned origNumSpaces, unsigned tabWidth, BOOL usesTabs);
extern NSArray *TE_tabStopArrayForFontAndTabWidth(NSFont *font, unsigned tabWidth);

extern NSRange TE_rangeOfLineWithLeadingWhiteSpace(NSString *string, NSRange startRange, unsigned leadingSpaces, NSComparisonResult matchStyle, BOOL backwardFlag, unsigned tabWidth);
    // Starting at the given startRange in string, this function locates the next (or previous) line whose leading whitespace is either smaller than, equal to or greater than the given leadingSpaces.  NSOrderedAscending means greater than, NSOrderedDescending means smaller than.  Return value is the range of the line whose leading space staisfies the match.

// Nest/Unnest utilities
extern NSAttributedString *TE_attributedStringByIndentingParagraphs(NSAttributedString *origString, int levels,  NSRange *selRange, NSDictionary *defaultAttrs, unsigned tabWidth, unsigned indentWidth, BOOL usesTabs);

// Brace matching utilities
extern unichar TE_matchingDelimiter(unichar delimiter);
extern BOOL TE_isOpeningBrace(unichar delimiter);
extern BOOL TE_isClosingBrace(unichar delimiter);
extern NSRange TE_findMatchingBraceForRangeInString(NSRange origRange, NSString *string);

// Variable substitution

extern unsigned TE_expandVariablesInString(NSMutableString *input, NSString *variableStart, NSString *variableEnd, id modalDelegate, SEL callbackSelector, void *context);
    // Variable references must begin with variableStart and end with variableEnd.  There's no support for "escaping" the end string.
    // callbackSelector must have the following signature:
    //     - (NSString *)expansionForVariableName:(NSString *)name inputString:(NSString *)input variableNameRange:(NSRange)nameRange fullVariableRange:(NSRange)fullRange context:(void *)context;
    // The return value of the callback is the replacement for the whole variable reference, or nil if the reference should be left unreplaced.
    // The return value of the funtion is the number of variables found and replaced.
