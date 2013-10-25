#ifndef debug
#define debug(...)
#endif
#define JSTPrefs [NSUserDefaults standardUserDefaults]
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
#pragma clang diagnostic ignored "-Wmissing-prototypes"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wshadow"
#ifndef __clang_analyzer__
//
//  JSTListener.h
//  jstalk
//
//  Created by August Mueller on 1/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JSTListener : NSObject {
    
    CFMessagePortRef messagePort;
    
    NSConnection *_conn;
    
    __unsafe_unretained id _rootObject;
    
}

@property (assign) id rootObject;

+ (JSTListener*)sharedListener;

+ (void)listen;
+ (void)listenWithRootObject:(id)rootObject;

@end
//
//  JSTPreprocessor.h
//  jstalk
//
//  Created by August Mueller on 2/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JSTPreprocessor : NSObject {

}

+ (NSString*)preprocessCode:(NSString*)sourceString;

@end



@interface JSTPSymbolGroup : NSObject {
    
    unichar _openSymbol;
    NSMutableArray *_args;
    JSTPSymbolGroup *_parent;
}

@property (retain) NSMutableArray *args;
@property (retain) JSTPSymbolGroup *parent;

- (void)addSymbol:(id)aSymbol;

@end


//
//  JSTTextView.h
//  jstalk
//
//  Created by August Mueller on 1/18/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NoodleLineNumberView;

@interface JSTTextView : NSTextView <NSTextStorageDelegate>{
    NSDictionary            *_keywords;
    
    NSString                *_lastAutoInsert;
}


@property (retain) NSDictionary *keywords;
@property (retain) NSString *lastAutoInsert;

- (void)parseCode:(id)sender;

@end
//
//  NoodleLineNumberView.h
//  Line View Test
//
//  Created by Paul Kim on 9/28/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Cocoa/Cocoa.h>

@class NoodleLineNumberMarker;

@interface NoodleLineNumberView : NSRulerView
{
    // Array of character indices for the beginning of each line
    NSMutableArray      *lineIndices;
	// Maps line numbers to markers
	NSMutableDictionary	*linesToMarkers;
	NSFont              *font;
	NSColor				*textColor;
	NSColor				*alternateTextColor;
	NSColor				*backgroundColor;
}

- (id)initWithScrollView:(NSScrollView *)aScrollView;

- (void)setFont:(NSFont *)aFont;
- (NSFont *)font;

- (void)setTextColor:(NSColor *)color;
- (NSColor *)textColor;

- (void)setAlternateTextColor:(NSColor *)color;
- (NSColor *)alternateTextColor;

- (void)setBackgroundColor:(NSColor *)color;
- (NSColor *)backgroundColor;

- (NSInteger)lineNumberForLocation:(CGFloat)location;
- (NoodleLineNumberMarker *)markerAtLine:(NSUInteger)line;

@end
//
//  MarkerTextView.h
//  Line View Test
//
//  Created by Paul Kim on 10/4/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Cocoa/Cocoa.h>


@interface MarkerLineNumberView : NoodleLineNumberView
{
	NSImage				*markerImage;
}

@end
//
//  NoodleLineNumberMarker.h
//  Line View Test
//
//  Created by Paul Kim on 9/30/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Cocoa/Cocoa.h>


@interface NoodleLineNumberMarker : NSRulerMarker
{
	NSUInteger		lineNumber;
}

- (id)initWithRulerView:(NSRulerView *)aRulerView lineNumber:(CGFloat)line image:(NSImage *)anImage imageOrigin:(NSPoint)imageOrigin;

- (void)setLineNumber:(NSUInteger)line;
- (NSUInteger)lineNumber;


@end
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
//
//  MOBridgeSupportController.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOBridgeSupportSymbol;


@interface MOBridgeSupportController : NSObject

+ (MOBridgeSupportController *)sharedController;

- (BOOL)isBridgeSupportLoadedForURL:(NSURL *)aURL;
- (BOOL)loadBridgeSupportAtURL:(NSURL *)aURL error:(NSError **)outError;

@property (copy, readonly) NSDictionary *symbols;
- (NSDictionary *)performQueryForSymbolsOfType:(NSArray *)classes;

- (id)performQueryForSymbolName:(NSString *)name;
- (id)performQueryForSymbolName:(NSString *)name ofType:(Class)klass;

@end
//
//  MOBridgeSupportLibrary.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOBridgeSupportSymbol;


@interface MOBridgeSupportLibrary : NSObject

@property (copy) NSString *name;
@property (copy) NSURL *URL;

@property (copy) NSArray *dependencies;
- (void)addDependency:(NSString *)dependency;
- (void)removeDependency:(NSString *)dependency;

@property (copy) NSDictionary *symbols;
- (MOBridgeSupportSymbol *)symbolWithName:(NSString *)name;
- (void)setSymbol:(MOBridgeSupportSymbol *)symbol forName:(NSString *)name;
- (void)removeSymbolForName:(NSString *)name;

@end
//
//  MOBridgeSupportParser.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOBridgeSupportLibrary;


@interface MOBridgeSupportParser : NSObject

- (MOBridgeSupportLibrary *)libraryWithBridgeSupportURL:(NSURL *)aURL error:(NSError **)outError;

@end
//
//  MOBridgeSupportSymbol.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOBridgeSupportArgument;


/*!
 * @class MOBridgeSupportSymbol
 * @abstract Abstract superclass of all symbols
 */
@interface MOBridgeSupportSymbol : NSObject

@property (copy) NSString *name;

@end


/*!
 * @class MOBridgeSupportStruct
 * @abstract Describes a C struct
 */
@interface MOBridgeSupportStruct : MOBridgeSupportSymbol

@property (copy) NSString *type;
@property (copy) NSString *type64;

@property (getter=isOpaque) BOOL opaque;

@end


/*!
 * @class MOBridgeSupportCFType
 * @abstract Describes a Core Foundation-based type
 */
@interface MOBridgeSupportCFType : MOBridgeSupportSymbol

@property (copy) NSString *type;
@property (copy) NSString *type64;

@property (copy) NSString *tollFreeBridgedClassName;
@property (copy) NSString *getTypeIDFunctionName;

@end


/*!
 * @class MOBridgeSupportOpaque
 * @abstract Describes an opaque type, most generally a C pointer to a C opaque structure
 */
@interface MOBridgeSupportOpaque : MOBridgeSupportSymbol

@property (copy) NSString *type;
@property (copy) NSString *type64;

@property BOOL hasMagicCookie;

@end


/*!
 * @class MOBridgeSupportConstant
 * @abstract Describes a C constant
 */
@interface MOBridgeSupportConstant : MOBridgeSupportSymbol

@property (copy) NSString *type;
@property (copy) NSString *type64;

@property BOOL hasMagicCookie;

@end


/*!
 * @class MOBridgeSupportStringConstant
 * @abstract Describes a string constant
 */
@interface MOBridgeSupportStringConstant : MOBridgeSupportSymbol

@property (copy) NSString *value;

@property BOOL hasNSString;

@end


/*!
 * @class MOBridgeSupportEnum
 * @abstract Describes a C enumeration
 */
@interface MOBridgeSupportEnum : MOBridgeSupportSymbol

@property (copy) NSNumber *value;
@property (copy) NSNumber *value64;

@property (getter=isIgnored) BOOL ignored;
@property (copy) NSString *suggestion;

@end


/*!
 * @class MOBridgeSupportFunction
 * @abstract Describes a C function
 */
@interface MOBridgeSupportFunction : MOBridgeSupportSymbol

@property (getter=isVariadic) BOOL variadic;
@property (copy) NSNumber *sentinel;
@property (getter=isInlineFunction) BOOL inlineFunction;

@property (copy) NSArray *arguments;
- (void)addArgument:(MOBridgeSupportArgument *)argument;
- (void)removeArgument:(MOBridgeSupportArgument *)argument;

@property (strong) MOBridgeSupportArgument *returnValue;

@end


/*!
 * @class MOBridgeSupportFunctionAlias
 * @abstract Describes an alias or shortcut to a C function
 */
@interface MOBridgeSupportFunctionAlias : MOBridgeSupportSymbol

@property (copy) NSString *original;

@end


@class MOBridgeSupportMethod;

/*!
 * @class MOBridgeSupportClass
 * @abstract Describes an Objective-C class
 */
@interface MOBridgeSupportClass : MOBridgeSupportSymbol

@property (copy) NSArray *methods;
- (void)addMethod:(MOBridgeSupportMethod *)method;
- (void)removeMethod:(MOBridgeSupportMethod *)method;

- (MOBridgeSupportMethod *)methodWithSelector:(SEL)selector;

@end


/*!
 * @class MOBridgeSupportInformalProtocol
 * @abstract Describes an Objective-C informal protocol
 */
@interface MOBridgeSupportInformalProtocol : MOBridgeSupportSymbol

@property (copy) NSArray *methods;
- (void)addMethod:(MOBridgeSupportMethod *)method;
- (void)removeMethod:(MOBridgeSupportMethod *)method;

- (MOBridgeSupportMethod *)methodWithSelector:(SEL)selector;

@end

/*!
 * @class MOBridgeSupportMethod
 * @abstract Describes an Objective-C method
 */
@interface MOBridgeSupportMethod : MOBridgeSupportSymbol

@property SEL selector;

@property (copy) NSString *type;
@property (copy) NSString *type64;

@property (copy) NSArray *arguments;
- (void)addArgument:(MOBridgeSupportArgument *)argument;
- (void)removeArgument:(MOBridgeSupportArgument *)argument;

@property (strong) MOBridgeSupportArgument *returnValue;

@property (getter=isClassMethod) BOOL classMethod;

@property (getter=isVariadic) BOOL variadic;
@property (copy) NSNumber *sentinel;

@property (getter=isIgnored) BOOL ignored;
@property (copy) NSString *suggestion;

@end


/*!
 * @class MOBridgeSupportArgument
 * @abstract Describes an argument or return value
 */
@interface MOBridgeSupportArgument : NSObject

@property (copy) NSString *type;
@property (copy) NSString *type64;

@property (copy) NSString *typeModifier;

@property (copy) NSString *signature;
@property (copy) NSString *signature64;

@property (copy) NSString *cArrayLengthInArg;
@property (getter=isCArrayOfFixedLength) BOOL cArrayOfFixedLength;
@property (getter=isCArrayDelimitedByNull) BOOL cArrayDelimitedByNull;
@property (getter=isCArrayOfVariableLength) BOOL cArrayOfVariableLength;
@property (getter=isCArrayLengthInReturnValue) BOOL cArrayLengthInReturnValue;

@property NSUInteger index;

@property BOOL acceptsNull;
@property BOOL acceptsPrintfFormat;

@property (getter=isAlreadyRetained) BOOL alreadyRetained;
@property (getter=isFunctionPointer) BOOL functionPointer;

@property (copy) NSArray *arguments;
- (void)addArgument:(MOBridgeSupportArgument *)argument;
- (void)removeArgument:(MOBridgeSupportArgument *)argument;

@property (strong) MOBridgeSupportArgument *returnValue;

@end

//
//  NSArray+MochaAdditions.h
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (MochaAdditions)

- (id)mo_objectForIndexedSubscript:(NSUInteger)idx;

@end


@interface NSMutableArray (MochaAdditions)

- (void)mo_setObject:(id)obj forIndexedSubscript:(NSUInteger)idx;

@end
//
//  NSDictionary+MochaAdditions.h
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (MochaAdditions)

- (id)mo_objectForKeyedSubscript:(id)key;

@end


@interface NSMutableDictionary (MochaAdditions)

- (void)mo_setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
//
//  NSObject+MochaAdditions.h
//  Mocha
//
//  Created by Logan Collins on 5/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOClassDescription;


@interface NSObject (MochaAdditions)

+ (void)mo_swizzleAdditions;

+ (MOClassDescription *)mo_mocha;

@end
//
//  NSOrderedSet+MochaAdditions.h
//  Mocha
//
//  Created by Logan Collins on 5/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSOrderedSet (MochaAdditions)

- (id)mo_objectForIndexedSubscript:(NSUInteger)idx;

@end


@interface NSMutableOrderedSet (MochaAdditions)

- (void)mo_setObject:(id)obj forIndexedSubscript:(NSUInteger)idx;

@end
//
//  Mocha.h
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//












//
//  MochaDefines.h
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//


#define MOCHA_EXTERN extern __attribute__((visibility("default")))
#define MOCHA_INLINE static inline __attribute__((visibility("default")))

#if (__has_feature(objc_fixed_enum))
#define MOCHA_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#define MOCHA_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#else
#define MOCHA_ENUM(_type, _name) _type _name; enum
#define MOCHA_OPTIONS(_type, _name) _type _name; enum
#endif
//
//  MochaRuntime.h
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>



@protocol MochaDelegate;


/*!
 * @class Mocha
 * @abstract The Mocha runtime interface
 */
@interface Mocha : NSObject

/*!
 * @method sharedRuntime
 * @abstract The shared runtime instance
 * 
 * @discussion
 * Additional runtimes can be created by calling -init
 * 
 * @result A Mocha object
 */
+ (Mocha *)sharedRuntime;


/*!
 * @property delegate
 * @abstract Gets the runtime delegate
 * 
 * @result An object conforming to the MochaDelegate protocol
 */
@property (unsafe_unretained) id <MochaDelegate> delegate;


/*!
 * @method evalString:
 * @abstract Evalutates the specified JavaScript expression, returning the result
 * 
 * @param string
 * The JavaScript expression to evaluate
 * 
 * @result An object, or nil
 */
- (id)evalString:(NSString *)string;


/*!
 * @method callFunctionWithName:
 * @abstract Calls a JavaScript function in the global context
 * 
 * @param functionName
 * The name of the function
 * 
 * @result An object, or nil
 */
- (id)callFunctionWithName:(NSString *)functionName;

/*!
 * @method callFunctionWithName:withArguments:
 * @abstract Calls a JavaScript function in the global context
 * 
 * @param functionName
 * The name of the function
 * 
 * @param firstArg
 * A variable-length list of arguments to pass to the function
 * 
 * @result An object, or nil
 */
- (id)callFunctionWithName:(NSString *)functionName withArguments:(id)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 * @method callFunctionWithName:withArgumentsInArray:
 * @abstract Calls a JavaScript function in the global context
 * 
 * @param functionName
 * The name of the function
 * 
 * @param arguments
 * An array of arguments to pass to the function
 * 
 * @result An object, or nil
 */
- (id)callFunctionWithName:(NSString *)functionName withArgumentsInArray:(NSArray *)arguments;


/*!
 * @method isSyntaxValidForString:
 * @abstract Validates the syntax of a JavaScript expression
 * 
 * @param string
 * The JavaScript expression to validate
 * 
 * @result A BOOL value
 */
- (BOOL)isSyntaxValidForString:(NSString *)string;


/*!
 * @method loadFrameworkWithName:
 * @abstract Loads BridgeSupport info and symbols for a specified framework
 * 
 * @param frameworkName
 * The name of the framework to load
 * 
 * @discussion
 * This method will attempt to load BridgeSupport info and symbols for the
 * framework via dyld. If the framework cannot be found, or fails to load,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)loadFrameworkWithName:(NSString *)frameworkName;

/*!
 * @method loadFrameworkWithName:inDirectory:
 * @abstract Loads BridgeSupport info and symbols for a specified framework
 * 
 * @param frameworkName
 * The name of the framework to load
 * 
 * @param directory
 * The directory in which to look for the framework
 * 
 * @discussion
 * This method will attempt to load BridgeSupport info and symbols for the
 * framework via dyld. If the framework cannot be found, or fails to load,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)loadFrameworkWithName:(NSString *)frameworkName inDirectory:(NSString *)directory;

/*!
 * @method loadBridgeSupportFilesAtPath:
 * @abstract Loads BridgeSupport info and symbols at a specified location
 *
 * @param path
 * The path to load
 *
 * @result A BOOL value
 */
- (BOOL)loadBridgeSupportFilesAtPath:(NSString *)path;

/*!
 * @property frameworkSearchPaths
 * @abstract Gets the array of search paths to check when loading a framework
 * 
 * @result An NSArray of NSString objects
 */
@property (copy) NSArray *frameworkSearchPaths;

/*!
 * @method addFrameworkSearchPath:
 * @abstract Adds a path to the array of framework search paths
 * 
 * @param path
 * The path to add
 */
- (void)addFrameworkSearchPath:(NSString *)path;

/*!
 * @method insertFrameworkSearchPath:atIndex:
 * @abstract Inserts a path into the array of framework search paths
 * 
 * @param path
 * The path to add
 * 
 * @param idx
 * The index at which to add the path
 */
- (void)insertFrameworkSearchPath:(NSString *)path atIndex:(NSUInteger)idx;

/*!
 * @method removeFrameworkSearchPathAtIndex:
 * @abstract Removes a path in the array of framework search paths
 *
 * @param idx
 * The index at which to remove the path
 */
- (void)removeFrameworkSearchPathAtIndex:(NSUInteger)idx;


/*!
 * @property globalSymbolNames
 * @abstract Gets all symbol names in the global Mocha namespace
 * 
 * @result An NSArray of NSString objects
 */
@property (copy, readonly) NSArray *globalSymbolNames;


/*!
 * @method garbageCollect
 * @abstract Instructs the JavaScript garbage collector to perform a collection
 */
- (void)garbageCollect;

- (JSGlobalContextRef)context;

@end


/*!
 * @protocol MochaDelegate
 * @abstract Implemented by objects acting as a runtime delegate
 */
@protocol MochaDelegate <NSObject>

@optional

@end


/*!
 * @category NSObject(MochaScripting)
 * @abstract Methods for customizing object behavior within the runtime
 */
@interface NSObject (MochaScripting)

/*!
 * @method isSelectorExcludedFromMochaScript:
 * @abstract Whether the specified selector is excluded from runtime access
 * 
 * @param selector
 * The selector to optionally exclude
 * 
 * @discussion
 * By default, this method returns NO, enabling access to all selectors for
 * an object. Returning YES from this method will prevent the given selector
 * from being called by the runtime.
 * 
 * @result A BOOL value
 */
+ (BOOL)isSelectorExcludedFromMochaScript:(SEL)selector;

/*!
 * @method selectorForMochaScriptPropertyName:
 * @abstract Gets the selector for a specified runtime property name
 * 
 * @result A SEL value
 */
+ (SEL)selectorForMochaPropertyName:(NSString *)propertyName;

/*!
 * @method finalizeForMochaScript
 * @abstract Invoked before the object is dereferenced in the runtime
 * 
 * @discussion
 * This method allows objects to clear internal caches and data tied to
 * other runtime information in preparation for being remove from the runtime.
 */
- (void)finalizeForMochaScript;

@end


/*!
 * @category NSObject(MochaObjectSubscripting)
 * @abstract Methods for enabling object subscripting within the runtime
 */
@interface NSObject (MochaObjectSubscripting)

/*!
 * @method objectForIndexedSubscript:
 * @abstract Gets the object for a given index
 * 
 * @param idx
 * The index for which to get an object
 * 
 * @result An object
 */
- (id)objectForIndexedSubscript:(NSUInteger)idx;

/*!
 * @method setObject:forIndexedSubscript:
 * @abstract Sets the object for a given index
 * 
 * @param obj
 * The object value to set
 * 
 * @param idx
 * The index for which to get an object
 */
- (void)setObject:(id)obj forIndexedSubscript:(NSUInteger)idx;


/*!
 * @method objectForKeyedSubscript:
 * @abstract Gets the object for a given key
 * 
 * @param key
 * The key for which to get an object
 * 
 * @result An object
 */
- (id)objectForKeyedSubscript:(NSString *)key;

/*!
 * @method setObject:forKeyedSubscript:
 * @abstract Sets the object for a given key
 * 
 * @param obj
 * The object value to set
 * 
 * @param key
 * The key for which to get an object
 */
- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key;

@end


/*!
 * @constant MORuntimeException
 * @abstract The name of exceptions raised within the runtime's internal implementation
 */
MOCHA_EXTERN NSString * const MORuntimeException;

/*!
 * @constant MOJavaScriptException
 * @abstract The name of exceptions raised within JavaScript code
 */
MOCHA_EXTERN NSString * const MOJavaScriptException;

//
//  MochaRuntime_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//





@interface Mocha ()

+ (Mocha *)runtimeWithContext:(JSContextRef)ctx;

- (id)initWithGlobalContext:(JSGlobalContextRef)ctx;

@property (readonly) JSGlobalContextRef context;

// JSValue <-> id
+ (JSValueRef)JSValueForObject:(id)object inContext:(JSContextRef)ctx;

+ (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx;
+ (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx unboxObjects:(BOOL)unboxObjects;

+ (NSArray *)arrayForJSArray:(JSObjectRef)arrayValue inContext:(JSContextRef)ctx;
+ (NSDictionary *)dictionaryForJSHash:(JSObjectRef)hashValue inContext:(JSContextRef)ctx;

- (JSValueRef)JSValueForObject:(id)object;

- (id)objectForJSValue:(JSValueRef)value;
- (id)objectForJSValue:(JSValueRef)value unboxObjects:(BOOL)unboxObjects;

// JSObject <-> id
- (JSObjectRef)boxedJSObjectForObject:(id)object;
- (id)unboxedObjectForJSObject:(JSObjectRef)jsObject;

// Object storage
- (id)objectWithName:(NSString *)name;
- (JSValueRef)setObject:(id)object withName:(NSString *)name;
- (JSValueRef)setObject:(id)object withName:(NSString *)name attributes:(JSPropertyAttributes)attributes;
- (BOOL)removeObjectWithName:(NSString *)name;

// Evaluation
- (JSValueRef)evalJSString:(NSString *)string;
- (JSValueRef)evalJSString:(NSString *)string scriptPath:(NSString *)scriptPath;

// Functions
- (JSObjectRef)JSFunctionWithName:(NSString *)functionName;
- (JSValueRef)callJSFunctionWithName:(NSString *)functionName withArgumentsInArray:(NSArray *)arguments;
- (JSValueRef)callJSFunction:(JSObjectRef)jsFunction withArgumentsInArray:(NSArray *)arguments;

// Exceptions
+ (NSException *)exceptionWithJSException:(JSValueRef)exception context:(JSContextRef)ctx;
- (NSException *)exceptionWithJSException:(JSValueRef)exception;
- (void)throwJSException:(JSValueRef)exception;

// Support
- (void)installBuiltins;
- (void)cleanUp;
//- (void)unlinkAllReferences;

@end
//
//  MOBox.h
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


@class Mocha;


/*!
 * @class MOBox
 * @abstract A boxed Objective-C object
 */
@interface MOBox : NSObject

/*!
 * @property representedObject
 * @abstract The boxed Objective-C object
 * 
 * @result An object
 */
@property (strong) id representedObject;

/*!
 * @property JSObject
 * @abstract The JSObject representation of the box
 * 
 * @result A JSObjectRef value
 */
@property JSObjectRef JSObject;

/*!
 * @property runtime
 * @abstract The runtime for the object
 * 
 * @result A Mocha object
 */
@property (weak) Mocha *runtime;

@end
//
//  MOClassDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOInstanceVariableDescription, MOMethodDescription, MOPropertyDescription, MOProtocolDescription;
@class MOJavaScriptObject;


/*!
 * @class MOClassDescription
 * @abstract A description of an Objective-C class
 */
@interface MOClassDescription : NSObject

/*!
 * @method descriptionForClassWithName:
 * @abstract Gets the class description for a specified class name
 * 
 * @param name
 * The name of the class
 * 
 * @discussion
 * If there is no class registered with that name, this method returns nil.
 * 
 * @result An MOClassDescription object, or nil
 */
+ (MOClassDescription *)descriptionForClassWithName:(NSString *)name;

/*!
 * @method descriptionForClass:
 * @abstract Gets the class description for a specified class
 * 
 * @param aClass
 * The class object
 * 
 * @discussion
 * If there is no class registered with that name, this method returns nil.
 * 
 * @result An MOClassDescription object, or nil
 */
+ (MOClassDescription *)descriptionForClass:(Class)aClass;

/*!
 * @method allocateDescriptionForClassWithName:
 * @abstract Creates a class description for a new class
 * 
 * @param name
 * The name of the class
 * 
 * @param superclass
 * The superclass of the new class. Pass Nil to create a new root class.
 * 
 * @discussion
 * If there is already a class registered with that name, this method returns nil.
 * 
 * Once this method has been called, and returned a non-nil value, the class
 * must be registered with -registerClass to be used. Failing to do so will prevent
 * another class to be created with the same name.
 * 
 * Despite it's name's connotations, this method returns an autoreleased object.
 * It is the class object itself which is being allocated.
 * 
 * @result An MOClassDescription object, or nil
 */
+ (MOClassDescription *)allocateDescriptionForClassWithName:(NSString *)name superclass:(Class)superclass;


/*!
 * @method registerClass
 * @abstract Registers the class with the runtime
 * 
 * @discussion
 * Before the class can be instantiated, you must call -registerClass.
 * 
 * If the class cannot be registered (for example, if the desired name is in use)
 * this method returns Nil. The result of attempting to register a class that
 * is already registered is undefined.
 * 
 * @result A Class object, or Nil
 */
- (Class)registerClass;


/*!
 * @property name
 * @abstract The name of the class
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *name;

/*!
 * @property descriptedClass
 * @abstract The class backing the description
 * 
 * @result A Class object, or Nil
 */
@property (unsafe_unretained, readonly) Class descriptedClass;

/*!
 * @property superclass
 * @abstract The description of the superclass of the class backing the description
 * 
 * @result An MOClassDescription object, or nil
 */
@property (weak, readonly) MOClassDescription *superclass;

/*!
 * @property ancestors
 * @abstract The description of each superclass in the class's superclass chain
 * 
 * @result An NSArray of MOClassDescription objects
 */
@property (copy, readonly) NSArray *ancestors;


/*!
 * @property instanceVariables
 * @abstract The array of instance variable descriptions
 * 
 * @result An NSArray of MOInstanceVariableDescription objects
 */
@property (copy, readonly) NSArray *instanceVariables;

/*!
 * @property instanceVariablesWithAncestors
 * @abstract The array of instance variable descriptions, including those of ancestors
 * 
 * @result An NSArray of MOInstanceVariableDescription objects
 */
@property (copy, readonly) NSArray *instanceVariablesWithAncestors;

/*!
 * @method addInstanceVariableWithName:typeEncoding:
 * @abstract Adds a new instance variable to the class
 * 
 * @param name
 * The name of the instance variable
 * 
 * @param typeEncoding
 * The type encoding of the instance variable
 * 
 * @discussion
 * If the class already contains an instance variable with that
 * name, this method returns NO.
 * 
 * Adding instance variables to an existing class is not supported.
 * If the class has already been registered with the runtime, calling
 * this method will raise an MORuntimeException.
 * 
 * @result A BOOL value
 */
- (BOOL)addInstanceVariableWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding;


/*!
 * @property classMethods
 * @abstract The array of class method descriptions
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *classMethods;

/*!
 * @property classMethodsWithAncestors
 * @abstract The array of class method descriptions, including those of ancestors
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *classMethodsWithAncestors;

/*!
 * @method addClassMethodWithSelector:typeEncoding:block:
 * @abstract Adds a new class method to the class
 * 
 * @param selector
 * The method selector
 * 
 * @param typeEncoding
 * The type encoding of the method
 * 
 * @param block
 * The block defining the method's implementation
 * 
 * @discussion
 * If the class already contains a class method with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addClassMethodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding block:(id)block;

/*!
 * @method addClassMethodWithSelector:JSFunction:
 * @abstract Adds a new class method to the class
 * 
 * @param selector
 * The method selector
 * 
 * @param function
 * The function object
 * 
 * @discussion
 * If the class already contains a class method with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addClassMethodWithSelector:(SEL)selector function:(MOJavaScriptObject *)function;


/*!
 * @property instanceMethods
 * @abstract The array of instance method descriptions
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *instanceMethods;

/*!
 * @property instanceMethodsWithAncestors
 * @abstract The array of instance method descriptions, including those of ancestors
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *instanceMethodsWithAncestors;

/*!
 * @method addInstanceMethodWithSelector:typeEncoding:block:
 * @abstract Adds a new instance method to the class
 * 
 * @param selector
 * The method selector
 * 
 * @param typeEncoding
 * The type encoding of the method
 * 
 * @param block
 * The block defining the method's implementation
 * 
 * @discussion
 * If the class already contains an instance method with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addInstanceMethodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding block:(id)block;

/*!
 * @method addInstanceMethodWithSelector:JSFunction:
 * @abstract Adds a new instance method to the class
 * 
 * @param selector
 * The method selector
 * 
 * @param function
 * The function object
 * 
 * @discussion
 * If the class already contains an instance method with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addInstanceMethodWithSelector:(SEL)selector function:(MOJavaScriptObject *)function;


/*!
 * @property properties
 * @abstract The array of property descriptions
 * 
 * @result An NSArray of MOPropertyDescription objects
 */
@property (copy, readonly) NSArray *properties;

/*!
 * @property propertiesWithAncestors
 * @abstract The array of property descriptions, including those of ancestors
 * 
 * @result An NSArray of MOPropertyDescription objects
 */
@property (copy, readonly) NSArray *propertiesWithAncestors;

/*!
 * @method addProperty:
 * @abstract Adds a new property to the class
 * 
 * @param property
 * The property to add
 * 
 * @param block
 * The block defining the method's implementation
 * 
 * @discussion
 * If the class already contains a property with that name,
 * this method returns NO.
 * 
 * @result A BOOL value
 */
- (BOOL)addProperty:(MOPropertyDescription *)property;


/*!
 * @property protocols
 * @abstract The array of adopted protocols
 * 
 * @result An NSArray of MOProtocolDescription objects
 */
@property (copy, readonly) NSArray *protocols;

/*!
 * @property protocols
 * @abstract The array of adopted protocols, including those of ancestors
 * 
 * @result An NSArray of MOProtocolDescription objects
 */
@property (copy, readonly) NSArray *protocolsWithAncestors;

/*!
 * @method addProtocol:
 * @abstract Adds a new conformed protocol to the class
 * 
 * @param protocol
 * The description of the protocol to add
 */
- (void)addProtocol:(MOProtocolDescription *)protocol;

@end
//
//  MOClosure.h
//  Mocha
//
//  Created by Logan Collins on 5/19/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOClosure
 * @abstract A thin wrapper around a block object
 */
@interface MOClosure : NSObject

/*!
 * @method closureWithBlock:
 * @abstract Creates a new closure
 * 
 * @param block
 * The block object
 *
 * @result An MOClosure object
 */
+ (MOClosure *)closureWithBlock:(id)block;

/*!
 * @method initWithBlock:
 * @abstract Creates a new closure
 *
 * @param block
 * The block object
 *
 * @result An MOClosure object
 */
- (id)initWithBlock:(id)block;


/*!
 * @property block
 * @abstract The block object
 * 
 * @result A block object
 */
@property (copy, readonly) id block;

/*!
 * @property callAddress
 * @abstract The address of the block's function pointer
 * 
 * @result A void pointer value
 */
@property (readonly) void * callAddress;

/*!
 * @property typeEncoding
 * @abstract The type encoding of the block
 * 
 * @result A const char * value
 */
@property (readonly) const char * typeEncoding;

@end
//
//  MOClosure_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/19/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@interface MOClosure ()

@end
//
//  MOInstanceVariableDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOInstanceVariableDescription
 * @abstract A description of an Objective-C instance variable
 */
@interface MOInstanceVariableDescription : NSObject

/*!
 * @method instanceVariableWithName:typeEncoding:
 * @abstract Creates a new instance variable
 * 
 * @param name
 * The name of the instance variable
 * 
 * @param typeEncoding
 * The type encoding of the instance variable
 * 
 * @result An MOInstanceVariableDescription object
 */
+ (MOInstanceVariableDescription *)instanceVariableWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding;


/*!
 * @property name
 * @abstract The name of the instance variable
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *name;

/*!
 * @property typeEncoding
 * @abstract The type encoding of the instance variable
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *typeEncoding;

@end
//
//  MOInstanceVariableDescription_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@interface MOInstanceVariableDescription ()

- (id)initWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding;

@property (copy, readwrite) NSString *name;
@property (copy, readwrite) NSString *typeEncoding;

@end
//
//  MOJavaScriptObject.h
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


/*!
 * @class MOJavaScriptObject
 * @abstract A thin wrapper around a pure JavaScript object
 */
@interface MOJavaScriptObject : NSObject

/*!
 * @method objectWithJSObject:context:
 * @abstract Creates a new JavaScript wrapper object
 * 
 * @param jsObject
 * @abstract The JavaScript object reference
 * 
 * @param context
 * The JavaScript context reference
 * 
 * @result An MOJavaScriptObject object
 */
+ (MOJavaScriptObject *)objectWithJSObject:(JSObjectRef)jsObject context:(JSContextRef)ctx;


/*!
 * @property JSObject
 * @abstract The JavaScript object reference
 * 
 * @result A JSObjectRef value
 */
@property (readonly) JSObjectRef JSObject;

/*!
 * @property JSContext
 * @abstract The JavaScript context reference
 * 
 * @result A JSContextRef value
 */
@property (readonly) JSContextRef JSContext;

@end
//
//  MOMethod.h
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOMethod
 * @abstract Represents a callable method
 */
@interface MOMethod : NSObject

/*!
 * @method methodWithTarget:selector:
 * @abstract Creates a new method object from a target and selector
 * 
 * @param target
 * The target of the method call
 * 
 * @param selector
 * The selector called on the method target
 * 
 * @result An MOMethod object
 */
+ (MOMethod *)methodWithTarget:(id)target selector:(SEL)selector;


/*!
 * @property target
 * @abstract The target of the method call
 * 
 * @result An object
 */
@property (strong, readonly) id target;

/*!
 * @property selector
 * @abstract The selector called on the method target
 * 
 * @result A SEL value
 */
@property (readonly) SEL selector;

@end
//
//  MOMethod_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@interface MOMethod ()

@property (strong, readwrite) id target;
@property (readwrite) SEL selector;

@property (copy, readwrite) id block;

@end
//
//  MOMethodDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOMethodDescription
 * @abstract A description of an Objective-C method
 */
@interface MOMethodDescription : NSObject

/*!
 * @method methodWithSelector:typeEncoding:
 * @abstract Creates a new method
 * 
 * @param selector
 * The selector of the method
 * 
 * @param typeEncoding
 * The type encoding of the method
 * 
 * @result An MOMethodDescription object
 */
+ (MOMethodDescription *)methodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding;

/*!
 * @property selector
 * @abstract The selector of the method
 * 
 * @result A SEL value
 */
@property (readonly) SEL selector;

/*!
 * @property typeEncoding
 * @abstract The type encoding of the method
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *typeEncoding;

@end
//
//  MOMethodDescription_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@interface MOMethodDescription ()

- (id)initWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding;

@property (readwrite) SEL selector;
@property (copy, readwrite) NSString *typeEncoding;

@end
//
//  MOObjCRuntime.h
//  Mocha
//
//  Created by Logan Collins on 5/16/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>



/*!
 * @enum MOObjcOwnershipRule
 * @abstract Objective-C ownership rules
 * 
 * @constant MOObjCOwnershipRuleAssign      Assigned (unretained)
 * @constant MOObjCOwnershipRuleRetain      Retained
 * @constant MOObjCOwnershipRuleCopy        Copied/retained
 */
typedef MOCHA_ENUM(NSUInteger, MOObjCOwnershipRule) {
    MOObjCOwnershipRuleAssign = 0,
    MOObjCOwnershipRuleRetain,
    MOObjCOwnershipRuleCopy,
};


/*!
 * @class MOObjCRuntime
 * @abstract Interface bridge to the Objective-C runtime
 */
@interface MOObjCRuntime : NSObject

/*!
 * @method sharedRuntime
 * @abstract Gets the shared runtime instance
 * 
 * @result An MOObjCRuntime object
 */
+ (MOObjCRuntime *)sharedRuntime;


/*!
 * @property classes
 * @abstract Gets the names of all classes registered with the runtime
 * 
 * @discussion
 * This method will ignore any classes that begin with an underscore, as
 * convention is that they are considered private.
 * 
 * @result An NSArray of NSString objects
 */
@property (copy, readonly) NSArray *classes;

/*!
 * @property protocols
 * @abstract Gets the names of all protocols registered with the runtime
 * 
 * @discussion
 * This method will ignore any protocols that begin with an underscore, as
 * convention is that they are considered private.
 * 
 * @result An NSArray of NSString objects
 */
@property (copy, readonly) NSArray *protocols;

@end
//
//  MOPropertyDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>



/*!
 * @class MOPropertyDescription
 * @abstract Description for an Objective-C class property
 */
@interface MOPropertyDescription : NSObject

/*!
 * @property name
 * @abstract The name of the property
 * 
 * @result An NSString object
 */
@property (copy) NSString *name;

/*!
 * @property typeEncoding
 * @abstract The type encoding of the property
 * 
 * @result An NSString object
 */
@property (copy) NSString *typeEncoding;


/*!
 * @property ivarName
 * @abstract The name of the backing instance variable
 * 
 * @result An NSString object
 */
@property (copy) NSString *ivarName;


/*!
 * @property getterSelector
 * @abstract The selector for the getter method
 * 
 * @result A SEL value
 */
@property SEL getterSelector;

/*!
 * @property setterSelector
 * @abstract The selector for the setter method
 * 
 * @result A SEL value
 */
@property SEL setterSelector;


/*!
 * @property ownershipRule
 * @abstract The ownership rule for the property
 * 
 * @result An MOObjCOwnershipRule value
 */
@property MOObjCOwnershipRule ownershipRule;


/*!
 * @property dynamic
 * @abstract Whether getter and setter methods are created at runtime
 * 
 * @result A BOOL value
 */
@property (getter=isDynamic) BOOL dynamic;

/*!
 * @property nonAtomic
 * @abstract Whether the property should work non-atomically (without synchronization code)
 * 
 * @result A BOOL value
 */
@property (getter=isNonAtomic) BOOL nonAtomic;

/*!
 * @property readOnly
 * @abstract Whether the property is read-only
 * 
 * @result A BOOL value
 */
@property (getter=isReadOnly) BOOL readOnly;

/*!
 * @property weak
 * @abstract Whether the property's value is weakly assigned
 * 
 * @result A BOOL value
 */
@property (getter=isWeak) BOOL weak;

@end
//
//  MOProtocolDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/18/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOMethodDescription, MOPropertyDescription;


/*!
 * @class MOProtocolDescription
 * @abstract A description of an Objective-C protocol
 */
@interface MOProtocolDescription : NSObject

/*!
 * @method descriptionForProtocol:
 * @abstract Gets the protocol description for a specified protocol
 * 
 * @param protocol
 * The protocol object
 * 
 * @result An MOProtocolDescription object
 */
+ (MOProtocolDescription *)descriptionForProtocol:(Protocol *)protocol;

/*!
 * @method descriptionForProtocolWithName:
 * @abstract Gets the protocol description for a specified protocol name
 * 
 * @param name
 * The name of the protocol
 * 
 * @result An MOProtocolDescription object
 */
+ (MOProtocolDescription *)descriptionForProtocolWithName:(NSString *)name;

/*!
 * @method allocateDescriptionForProtocolWithName:
 * @abstract Creates a protocol description for a new protocol
 * 
 * @param name
 * The name of the protocol
 * 
 * @discussion
 * If there is already a protocol registered with that name, this method returns nil.
 * 
 * Despite it's name's connotations, this method returns an autoreleased object.
 * It is the protocol object itself which is being allocated.
 * 
 * @result An MOProtocolDescription object, or nil
 */
+ (MOProtocolDescription *)allocateDescriptionForProtocolWithName:(NSString *)name;


/*!
 * @property name
 * @abstract The name of the class
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *name;


/*!
 * @property requiredClassMethods
 * @abstract The array of required class methods
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *requiredClassMethods;

/*!
 * @property optionalClassMethods
 * @abstract The array of optional class methods
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *optionalClassMethods;

/*!
 * @method addClassMethod:isRequired:
 * @abstract Adds a new class method to the protocol
 * 
 * @param method
 * The method to add
 * 
 * @param isRequired
 * Whether the method is required
 */
- (void)addClassMethod:(MOMethodDescription *)method required:(BOOL)isRequired;


/*!
 * @property requiredInstanceMethods
 * @abstract The array of required instance methods
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *requiredInstanceMethods;

/*!
 * @property optionalInstanceMethods
 * @abstract The array of optional instance methods
 * 
 * @result An NSArray of MOMethodDescription objects
 */
@property (copy, readonly) NSArray *optionalInstanceMethods;

/*!
 * @method addInstanceMethod:required:
 * @abstract Adds a new instance method to the protocol
 * 
 * @param method
 * The method to add
 * 
 * @param isRequired
 * Whether the method is required
 */
- (void)addInstanceMethod:(MOMethodDescription *)method required:(BOOL)isRequired;


/*!
 * @property properties
 * @abstract The array of properties
 * 
 * @result An NSArray of MOPropertyDescription objects
 */
@property (copy, readonly) NSArray *properties;

/*!
 * @method addProperty:
 * @abstract Adds a new property to the protocol
 * 
 * @param property
 * The property to add
 * 
 * @param isRequired
 * Whether the property is required
 */
- (void)addProperty:(MOPropertyDescription *)property required:(BOOL)isRequired;


/*!
 * @property protocols
 * @abstract The array of adopted protocols
 * 
 * @result An NSArray of MOProtocolDescription objects
 */
@property (copy, readonly) NSArray *protocols;

/*!
 * @method addProtocol:
 * @abstract Adds a new conformed protocol to the protocol
 * 
 * @param protocol
 * The description of the protocol to add
 */
- (void)addProtocol:(MOProtocolDescription *)protocol;

@end
//
//  MOProtocolDescription_Private.h
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@interface MOProtocolDescription ()

@property (unsafe_unretained, readonly) Protocol *protocol;

@end
//
//  MOStruct.h
//  Mocha
//
//  Created by Logan Collins on 5/15/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOStruct
 * @abstract An object representation of a C struct
 */
@interface MOStruct : NSObject

/*!
 * @method structureWithName:memberNames:
 * @abstract Creates a new structure
 * 
 * @param name
 * The name of the structure
 * 
 * @param memberNames
 * The ordered list of member names of the structure
 * 
 * @result An MOStruct object
 */
+ (MOStruct *)structureWithName:(NSString *)name memberNames:(NSArray *)memberNames;

/*!
 * @method initWithName:memberNames:
 * @abstract Creates a new structure
 * 
 * @param name
 * The name of the structure
 * 
 * @param memberNames
 * The ordered list of member names of the structure
 * 
 * @result An MOStruct object
 */
- (id)initWithName:(NSString *)name memberNames:(NSArray *)memberNames;


/*!
 * @property name
 * @abstract The name of the structure
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *name;

/*!
 * @property memberNames
 * @abstract The ordered list of member names of the structure
 * 
 * @result An NSArray of NSString objects
 */
@property (copy, readonly) NSArray *memberNames;


/*!
 * @method objectForMemberName:
 * @abstract Gets the value for a specified member name
 * 
 * @param memberName
 * The member name
 * 
 * @discussion
 * This method raises an MORuntime exception if the structure has
 * no member named name.
 * 
 * @result An object, or nil
 */
- (id)objectForMemberName:(NSString *)name;

/*!
 * @method setObject:forMemberName:
 * @abstract Sets the value for a specified member name
 * 
 * @param obj
 * The new value
 * 
 * @param name
 * The member name
 * 
 * @discussion
 * This method raises an MORuntime exception if the structure has
 * no member named name.
 */
- (void)setObject:(id)obj forMemberName:(NSString *)name;

@end
//
//  MOUndefined.h
//  Mocha
//
//  Created by Logan Collins on 5/15/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOUndefined
 * @abstract Represents an "undefined" value, as passed from JavaScript to Objective-C
 * 
 * @discussion
 * Syntactically, the undefined value represents the return value of a function that returns 'void' in C.
 */
@interface MOUndefined : NSObject

/*!
 * @method undefined
 * @abstract Gets the singleton undefined instance
 * 
 * @result An MOUndefined object
 */
+ (MOUndefined *)undefined;

@end
//
//  MOFunctionArgument.h
//  Mocha
//
//  Created by Logan Collins on 5/13/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

// 
// Note: A lot of this code is based on code from the PyObjC and JSCocoa projects.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

#if TARGET_OS_IPHONE
#import "ffi.h"
#else
#import <ffi/ffi.h>
#endif


@class MOPointer;


@interface MOFunctionArgument : NSObject

// Type encodings
@property char typeEncoding;
- (void)setTypeEncoding:(char)typeEncoding withCustomStorage:(void *)storagePtr;

@property (copy) NSString *pointerTypeEncoding;
- (void)setPointerTypeEncoding:(NSString *)pointerTypeEncoding withCustomStorage:(void *)storagePtr;

@property (copy) NSString *structureTypeEncoding;
- (void)setStructureTypeEncoding:(NSString *)structureTypeEncoding withCustomStorage:(void *)storagePtr;

@property (strong) MOPointer *pointer;
@property (getter=isReturnValue) BOOL returnValue;

// Storage
@property (readonly) ffi_type *ffiType;
@property (readonly) void** storage;
@property (copy, readonly) NSString *typeDescription;

// Values
- (JSValueRef)getValueAsJSValueInContext:(JSContextRef)ctx;
- (void)setValueAsJSValue:(JSValueRef)value context:(JSContextRef)ctx;

// Pointers
- (JSValueRef)getValueAsJSValueInContext:(JSContextRef)ctx dereference:(BOOL)dereference;
- (void)setValueAsJSValue:(JSValueRef)value context:(JSContextRef)ctx dereference:(BOOL)dereference;


// Support

+ (BOOL)getAlignment:(size_t *)alignment ofTypeEncoding:(char)encoding;
+ (BOOL)getSize:(size_t *)size ofTypeEncoding:(char)encoding;
+ (ffi_type *)ffiTypeForTypeEncoding:(char)encoding;

+ (NSString *)descriptionOfTypeEncoding:(char)encoding;
+ (NSString *)descriptionOfTypeEncoding:(char)typeEncoding fullTypeEncoding:(NSString *)fullTypeEncoding;

+ (size_t)sizeOfStructureTypeEncoding:(NSString *)encoding;
+ (NSString *)structureNameFromStructureTypeEncoding:(NSString *)encoding;
+ (NSString *)structureTypeEncodingDescription:(NSString *)structureTypeEncoding;
+ (NSString *)structureFullTypeEncodingFromStructureTypeEncoding:(NSString *)encoding;
+ (NSString *)structureFullTypeEncodingFromStructureName:(NSString *)structureName;

+ (NSArray *)typeEncodingsFromStructureTypeEncoding:(NSString *)structureTypeEncoding;
+ (NSArray *)typeEncodingsFromStructureTypeEncoding:(NSString *)structureTypeEncoding parsedCount:(NSInteger *)count;

+ (BOOL)fromJSValue:(JSValueRef)value inContext:(JSContextRef)ctx typeEncoding:(char)typeEncoding fullTypeEncoding:(NSString *)fullTypeEncoding storage:(void *)ptr;
+ (BOOL)toJSValue:(JSValueRef *)value inContext:(JSContextRef)ctx typeEncoding:(char)typeEncoding fullTypeEncoding:(NSString *)fullTypeEncoding storage:(void *)ptr;

+ (NSInteger)structureFromJSObject:(JSObjectRef)object inContext:(JSContextRef)ctx inParentJSValueRef:(JSValueRef)parentValue cString:(char *)c storage:(void **)ptr;
+ (NSInteger)structureToJSValue:(JSValueRef *)value inContext:(JSContextRef)ctx cString:(char *)c storage:(void **)ptr;
+ (NSInteger)structureToJSValue:(JSValueRef *)value inContext:(JSContextRef)ctx cString:(char *)c storage:(void **)ptr initialValues:(JSValueRef *)initialValues initialValueCount:(NSInteger)initialValueCount convertedValueCount:(NSInteger *)convertedValueCount;

@end
//
//  MOUtilities.h
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

#if TARGET_OS_IPHONE
#import "ffi.h"
#else
#import <ffi/ffi.h>
#endif


@class MOBridgeSupportFunction, MOFunctionArgument, MOJavaScriptObject;


JSValueRef MOJSValueToType(JSContextRef ctx, JSObjectRef objectJS, JSType type, JSValueRef *exception);
NSString * MOJSValueToString(JSContextRef ctx, JSValueRef value, JSValueRef *exception);

JSValueRef MOSelectorInvoke(id target, SEL selector, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception);
JSValueRef MOFunctionInvoke(id function, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception);

BOOL MOSelectorIsVariadic(Class klass, SEL selector);
void * MOInvocationGetObjCCallAddressForArguments(NSArray *arguments);

MOFunctionArgument * MOFunctionArgumentForTypeEncoding(NSString *typeEncoding);
NSArray * MOParseObjCMethodEncoding(const char *typeEncoding);

SEL MOSelectorFromPropertyName(NSString *propertyName);
NSString * MOSelectorToPropertyName(SEL selector);

NSString * MOPropertyNameToSetterName(NSString *propertyName);

id MOGetBlockForJavaScriptFunction(MOJavaScriptObject *function, NSUInteger *argCount);
//
//  MOPointer.h
//  Mocha
//
//  Created by Logan Collins on 7/31/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOPointer
 * @abstract A pointer to a value
 */
@interface MOPointer : NSObject

/*!
 * @method initWithValue:
 * @abstract Creates a new pointer
 * 
 * @param value
 * The value for the pointer
 * 
 * @result An MOPointer object
 */
- (id)initWithValue:(id)value;


/*!
 * @property value
 * @abstract The value of the pointer
 * 
 * @result An object, or nil
 */
@property (strong, readonly) id value;

@end
//
//  MOAllocator.h
//  Mocha
//
//  Created by Logan Collins on 7/25/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOAllocator
 * @abstract A proxy used to represent the result of -alloc.
 * 
 * @discussion
 * Some Cocoa classes do not play well when the result of -alloc
 * is sent messages other than an initializer. As such, this object
 * serves as a proxy to delay allocation of the object until it is sent
 * its initialization message.
 * 
 * Any unimplemented message sent to this class will be forwarded to
 * the target object class. This will always be something along the lines
 * of -init or -initWith*:
 */
@interface MOAllocator : NSObject

/*!
 * @method allocator
 * @abstract Creates a new allocator
 * 
 * @result An MOAllocator object
 */
+ (MOAllocator *)allocator;

/*!
 * @property objectClass
 * @abstract The target object class
 * 
 * @result A Class object
 */
@property (unsafe_unretained) Class objectClass;

@end
//
//  MOMapTable.h
//  Mocha
//
//  Created by Logan Collins on 8/6/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOMapTable
 * @abstract A lightweight object map table
 * 
 * @discussion
 * MOMapTable is useful in situations where object-to-object hashes are desired.
 * NSDictionary is not always sufficient due to the fact that keys must be copyable.
 * NSMapTable is not available on iOS 5 and earlier.
 * 
 * Note: MOMapTable is *not* a zeroing-weak collection.
 */
@interface MOMapTable : NSObject <NSFastEnumeration> {
    CFMutableDictionaryRef _dictionary;
}

/*!
 * @method mapTableWithStrongToStrongObjects
 * @abstract Creates a new map table that strongly retains both its keys and values
 * 
 * @result A MOMapTable object
 */
+ (MOMapTable *)mapTableWithStrongToStrongObjects;

/*!
 * @method mapTableWithStrongToUnretainedObjects
 * @abstract Creates a new map table that strongly retains its keys
 * 
 * @result A MOMapTable object
 */
+ (MOMapTable *)mapTableWithStrongToUnretainedObjects;

/*!
 * @method mapTableWithUnretainedToStrongObjects
 * @abstract Creates a new map table that strongly retains its values
 * 
 * @result A MOMapTable object
 */
+ (MOMapTable *)mapTableWithUnretainedToStrongObjects;

/*!
 * @method mapTableWithUnretainedToUnretainedObjects
 * @abstract Creates a new map table that does not strongly retains its keys or values
 * 
 * @result A MOMapTable object
 */
+ (MOMapTable *)mapTableWithUnretainedToUnretainedObjects;


/*!
 * @method keyEnumerator
 * @abstract Gets an enumerator for the collection's key values
 * 
 * @result An NSEnumerator object
 */
- (NSEnumerator *)keyEnumerator;

/*!
 * @method objectEnumerator
 * @abstract Gets an enumerator for the collection's object values
 * 
 * @result An NSEnumerator object
 */
- (NSEnumerator *)objectEnumerator;


/*!
 * @method count
 * @abstract The number of objects in the map table
 * 
 * @result An NSUInteger value
 */
- (NSUInteger)count;

/*!
 * @method allKeys
 * @abstract Gets all key objects
 * 
 * @result An NSArray object
 */
- (NSArray *)allKeys;

/*!
 * @method allValues
 * @abstract Gets all value objects
 * 
 * @result An NSArray object
 */
- (NSArray *)allObjects;


/*!
 * @method objectForKey:
 * @abstract Gets the object for a particular key
 * 
 * @discussion
 * If an object with the specified key is not in the collection
 * this method returns nil.
 * 
 * @result An object, or nil
 */
- (id)objectForKey:(id)key;

/*!
 * @method setObject:forKey:
 * @abstract Sets an object for a particular key
 * 
 * @param value
 * The value to set
 * 
 * @param key
 * The key to set
 * 
 * @discussion
 * If an object already exists for the specified key it is replaced.
 * If value or key is nil this method raises an NSInvalidArgumentException.
 */
- (void)setObject:(id)value forKey:(id)key;

/*!
 * @method removeObjectForKey:
 * @abstract Removes the object for a particular key
 * 
 * @param key
 * The key to set
 * 
 * @discussion
 * If no object exists for the specified key this method has no effect.
 * If key is nil this method raises an NSInvalidArgumentException.
 */
- (void)removeObjectForKey:(id)key;

/*!
 * @method removeAllObjects
 * @abstract Removes all objects from the collection
 */
- (void)removeAllObjects;

@end
//
//  TDParseKit.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDToken;
@class TDTokenizerState;
@class TDNumberState;
@class TDQuoteState;
@class TDSlashState;
@class TDCommentState;
@class TDSymbolState;
@class TDWhitespaceState;
@class TDWordState;
@class TDReader;

/*!
    @class      TDTokenizer
    @brief      A tokenizer divides a string into tokens.
    @details    <p>This class is highly customizable with regard to exactly how this division occurs, but it also has defaults that are suitable for many languages. This class assumes that the character values read from the string lie in the range <tt>0-MAXINT</tt>. For example, the Unicode value of a capital A is 65, so <tt>NSLog(@"%C", (unichar)65);</tt> prints out a capital A.</p>
                <p>The behavior of a tokenizer depends on its character state table. This table is an array of 256 <tt>TDTokenizerState</tt> states. The state table decides which state to enter upon reading a character from the input string.</p>
                <p>For example, by default, upon reading an 'A', a tokenizer will enter a "word" state. This means the tokenizer will ask a <tt>TDWordState</tt> object to consume the 'A', along with the characters after the 'A' that form a word. The state's responsibility is to consume characters and return a complete token.</p>
                <p>The default table sets a <tt>TDSymbolState</tt> for every character from 0 to 255, and then overrides this with:</p>
@code
     From     To    State
        0    ' '    whitespaceState
      'a'    'z'    wordState
      'A'    'Z'    wordState
      160    255    wordState
      '0'    '9'    numberState
      '-'    '-'    numberState
      '.'    '.'    numberState
      '"'    '"'    quoteState
     '\''   '\''    quoteState
      '/'    '/'    commentState
@endcode
                <p>In addition to allowing modification of the state table, this class makes each of the states above available. Some of these states are customizable. For example, wordState allows customization of what characters can be part of a word, after the first character.</p>
*/
@interface TDTokenizer : NSObject {
    NSString *string;
    TDReader *reader;
    
    NSMutableArray *tokenizerStates;
    
    TDNumberState *numberState;
    TDQuoteState *quoteState;
    TDCommentState *commentState;
    TDSymbolState *symbolState;
    TDWhitespaceState *whitespaceState;
    TDWordState *wordState;
}

/*!
    @brief      Convenience factory method. Sets string to read from to <tt>nil</tt>.
    @result     An initialized tokenizer.
*/
+ (id)tokenizer;

/*!
    @brief      Convenience factory method.
    @param      s string to read from.
    @result     An autoreleased initialized tokenizer.
*/
+ (id)tokenizerWithString:(NSString *)s;

/*!
    @brief      Designated Initializer. Constructs a tokenizer to read from the supplied string.
    @param      s string to read from.
    @result     An initialized tokenizer.
*/
- (id)initWithString:(NSString *)s;

/*!
    @brief      Returns the next token.
    @result     the next token.
*/
- (TDToken *)nextToken;

/*!
    @brief      Change the state the tokenizer will enter upon reading any character between "start" and "end".
    @param      state the state for this character range
    @param      start the "start" character. e.g. <tt>'a'</tt> or <tt>65</tt>.
    @param      end the "end" character. <tt>'z'</tt> or <tt>90</tt>.
*/
- (void)setTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end;

/*!
    @property   string
    @brief      The string to read from.
*/
@property (nonatomic, retain) NSString *string;

/*!
    @property    numberState
    @brief       The state this tokenizer uses to build numbers.
*/
@property (nonatomic, retain) TDNumberState *numberState;

/*!
    @property   quoteState
    @brief      The state this tokenizer uses to build quoted strings.
*/
@property (nonatomic, retain) TDQuoteState *quoteState;

/*!
    @property   commentState
    @brief      The state this tokenizer uses to recognize (and possibly ignore) comments.
*/
@property (nonatomic, retain) TDCommentState *commentState;

/*!
    @property   symbolState
    @brief      The state this tokenizer uses to recognize symbols.
*/
@property (nonatomic, retain) TDSymbolState *symbolState;

/*!
    @property   whitespaceState
    @brief      The state this tokenizer uses to recognize (and possibly ignore) whitespace.
*/
@property (nonatomic, retain) TDWhitespaceState *whitespaceState;

/*!
    @property   wordState
    @brief      The state this tokenizer uses to build words.
*/
@property (nonatomic, retain) TDWordState *wordState;
@end

//
//  TDReader.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @class      TDReader 
    @brief      A character-stream reader that allows characters to be pushed back into the stream.
*/
@interface TDReader : NSObject {
    NSString *string;
    NSUInteger cursor;
    NSUInteger length;
}

/*!
    @brief      Designated Initializer. Initializes a reader with a given string.
    @details    Designated Initializer.
    @param      s string from which to read
    @result     an initialized reader
*/
- (id)initWithString:(NSString *)s;

/*!
    @brief      Read a single character
    @result     The character read, or -1 if the end of the stream has been reached
*/
- (NSInteger)read;

/*!
    @brief      Push back a single character
    @details    moves the cursor back one position
*/
- (void)unread;

/*!
    @property   string
    @brief      This reader's string.
*/
@property (nonatomic, retain) NSString *string;
@end

//
//  TDParseKitState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TD_USE_MUTABLE_STRING_BUF 1

@class TDToken;
@class TDTokenizer;
@class TDReader;

/*!
    @class      TDTokenizerState 
    @brief      A <tt>TDTokenizerState</tt> returns a token, given a reader, an initial character read from the reader, and a tokenizer that is conducting an overall tokenization of the reader.
    @details    The tokenizer will typically have a character state table that decides which state to use, depending on an initial character. If a single character is insufficient, a state such as <tt>TDSlashState</tt> will read a second character, and may delegate to another state, such as <tt>TDSlashStarState</tt>. This prospect of delegation is the reason that the <tt>-nextToken</tt> method has a tokenizer argument.
*/
@interface TDTokenizerState : NSObject {
#if TD_USE_MUTABLE_STRING_BUF
    NSMutableString *stringbuf;
#else
    unichar *__strong charbuf;
    NSUInteger length;
    NSUInteger index;
#endif
}

/*!
    @brief      Return a token that represents a logical piece of a reader.
    @param      r the reader from which to read additional characters
    @param      cin the character that a tokenizer used to determine to use this state
    @param      t the tokenizer currently powering the tokenization
    @result     a token that represents a logical piece of the reader
*/
- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t;
@end

//
//  TDQuoteState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @class      TDQuoteState 
    @brief      A quote state returns a quoted string token from a reader
    @details    This state will collect characters until it sees a match to the character that the tokenizer used to switch to this state. For example, if a tokenizer uses a double- quote character to enter this state, then <tt>-nextToken</tt> will search for another double-quote until it finds one or finds the end of the reader.
*/
@interface TDQuoteState : TDTokenizerState {
    BOOL balancesEOFTerminatedQuotes;
}

/*!
    @property   balancesEOFTerminatedQuotes
    @brief      if true, this state will append a matching quote char (<tt>'</tt> or <tt>"</tt>) to quotes terminated by EOF. Default is NO.
*/
@property (nonatomic) BOOL balancesEOFTerminatedQuotes;
@end

//
//  TDMultiLineCommentState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMultiLineCommentState : TDTokenizerState {
    NSMutableArray *startSymbols;
    NSMutableArray *endSymbols;
    NSString *currentStartSymbol;
}

- (void)addStartSymbol:(NSString *)start endSymbol:(NSString *)end;
- (void)removeStartSymbol:(NSString *)start;
@property (nonatomic, retain) NSMutableArray *startSymbols;
@property (nonatomic, retain) NSMutableArray *endSymbols;
@property (nonatomic, copy) NSString *currentStartSymbol;
@end

//
//  TDCommentState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDSymbolRootNode;
@class TDSingleLineCommentState;
@class TDMultiLineCommentState;

/*!
    @class      TDCommentState
    @brief      This state will either delegate to a comment-handling state, or return a <tt>TDSymbol</tt> token with just the first char in it.
    @details    By default, C and C++ style comments. (<tt>//</tt> to end of line and <tt> &0x002A;/</tt>)
*/
@interface TDCommentState : TDTokenizerState {
    TDSymbolRootNode *rootNode;
    TDSingleLineCommentState *singleLineState;
    TDMultiLineCommentState *multiLineState;
    BOOL reportsCommentTokens;
    BOOL balancesEOFTerminatedComments;
}

/*!
    @brief      Adds the given string as a single-line comment start marker. may be multi-char.
    @details    single line comments begin with <tt>start</tt> and continue until the next new line character. e.g. C-style comments (<tt>// comment text</tt>)
    @param      start a single- or multi-character symbol that should be recognized as the start of a single-line comment
*/
- (void)addSingleLineStartSymbol:(NSString *)start;

/*!
    @brief      Removes the given string as a single-line comment start marker. may be multi-char.
    @details    If <tt>start</tt> was never added as a single-line comment start symbol, this has no effect.
    @param      start a single- or multi-character symbol that should no longer be recognized as the start of a single-line comment
*/
- (void)removeSingleLineStartSymbol:(NSString *)start;

/*!
    @brief      Adds the given strings as a multi-line comment start and end markers. both may be multi-char
    @details    <tt>start</tt> and <tt>end</tt> may be different strings. e.g. <tt></tt> and <tt>&0x002A;/</tt>. Also, the actual comment may or may not be multi-line.
    @param      start a single- or multi-character symbol that should be recognized as the start of a multi-line comment
    @param      end a single- or multi-character symbol that should be recognized as the end of a multi-line comment that began with <tt>start</tt>
*/
- (void)addMultiLineStartSymbol:(NSString *)start endSymbol:(NSString *)end;

/*!
    @brief      Removes <tt>start</tt> and its orignall <tt>end</tt> counterpart as a multi-line comment start and end markers.
    @details    If <tt>start</tt> was never added as a multi-line comment start symbol, this has no effect.
    @param      start a single- or multi-character symbol that should no longer be recognized as the start of a multi-line comment
*/
- (void)removeMultiLineStartSymbol:(NSString *)start;

/*!
    @property   reportsCommentTokens
    @brief      if true, the tokenizer associated with this state will report comment tokens, otherwise it silently consumes comments
    @details    if true, this state will return <tt>TDToken</tt>s of type <tt>TDTokenTypeComment</tt>.
                Otherwise, it will silently consume comment text and return the next token from another of the tokenizer's states
*/
@property (nonatomic) BOOL reportsCommentTokens;

/*!
    @property   balancesEOFTerminatedComments
    @brief      if true, this state will append a matching comment string (<tt>&0x002A;/</tt> [C++] or <tt>:)</tt> [XQuery]) to quotes terminated by EOF. Default is NO.
*/
@property (nonatomic) BOOL balancesEOFTerminatedComments;
@property (nonatomic, retain) TDSymbolRootNode *rootNode;
@property (nonatomic, retain) TDSingleLineCommentState *singleLineState;
@property (nonatomic, retain) TDMultiLineCommentState *multiLineState;
@end

//
//  TDSymbolState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDSymbolRootNode;

/*!
    @class      TDSymbolState 
    @brief      The idea of a symbol is a character that stands on its own, such as an ampersand or a parenthesis.
    @details    <p>The idea of a symbol is a character that stands on its own, such as an ampersand or a parenthesis. For example, when tokenizing the expression (isReady)& (isWilling) , a typical tokenizer would return 7 tokens, including one for each parenthesis and one for the ampersand. Thus a series of symbols such as )&( becomes three tokens, while a series of letters such as isReady becomes a single word token.</p>
                <p>Multi-character symbols are an exception to the rule that a symbol is a standalone character. For example, a tokenizer may want less-than-or-equals to tokenize as a single token. This class provides a method for establishing which multi-character symbols an object of this class should treat as single symbols. This allows, for example, "cat <= dog" to tokenize as three tokens, rather than splitting the less-than and equals symbols into separate tokens.</p>
                <p>By default, this state recognizes the following multi- character symbols: <tt>!=</tt>, <tt>:-</tt>, <tt><=</tt>, <tt>>=</tt></p>
*/
@interface TDSymbolState : TDTokenizerState {
    TDSymbolRootNode *rootNode;
    NSMutableArray *addedSymbols;
}

/*!
    @brief      Adds the given string as a multi-character symbol.
    @param      s a multi-character symbol that should be recognized as a single symbol token by this state
*/
- (void)add:(NSString *)s;

/*!
    @brief      Removes the given string as a multi-character symbol.
    @details    If <tt>s</tt> was never added as a multi-character symbol, this has no effect.
    @param      s a multi-character symbol that should no longer be recognized as a single symbol token by this state
*/
- (void)remove:(NSString *)s;
@end

//
//  TDNumberState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @class      TDNumberState 
    @brief      A number state returns a number from a reader.
    @details    This state's idea of a number allows an optional, initial minus sign, followed by one or more digits. A decimal point and another string of digits may follow these digits.
*/
@interface TDNumberState : TDTokenizerState {
    BOOL allowsTrailingDot;
    BOOL gotADigit;
    BOOL negative;
    NSInteger c;
    CGFloat floatValue;
}

/*!
    @property   allowsTrailingDot
    @brief      If true, numbers are allowed to end with a trialing dot, e.g. <tt>42.<tt>
    @details    false by default.
*/
@property (nonatomic) BOOL allowsTrailingDot;
@end

//
//  TDWhitespaceState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @class      TDWhitespaceState
    @brief      A whitespace state ignores whitespace (such as blanks and tabs), and returns the tokenizer's next token.
    @details    By default, all characters from 0 to 32 are whitespace.
*/
@interface TDWhitespaceState : TDTokenizerState {
    NSMutableArray *whitespaceChars;
    BOOL reportsWhitespaceTokens;
}

/*!
    @brief      Informs whether the given character is recognized as whitespace (and therefore ignored) by this state.
    @param      cin the character to check
    @result     true if the given chracter is recognized as whitespace
*/
- (BOOL)isWhitespaceChar:(NSInteger)cin;

/*!
    @brief      Establish the given character range as whitespace to ignore.
    @param      yn true if the given character range is whitespace
    @param      start the "start" character. e.g. <tt>'a'</tt> or <tt>65</tt>.
    @param      end the "end" character. <tt>'z'</tt> or <tt>90</tt>.
*/
- (void)setWhitespaceChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end;

/*!
    @property   reportsWhitespaceTokens
    @brief      determines whether a <tt>TDTokenizer</tt> associated with this state reports or silently consumes whitespace tokens. default is <tt>NO</tt> which causes silent consumption of whitespace chars
*/
@property (nonatomic) BOOL reportsWhitespaceTokens;
@end

//
//  TDWordState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @class      TDWordState 
    @brief      A word state returns a word from a reader.
    @details    <p>Like other states, a tokenizer transfers the job of reading to this state, depending on an initial character. Thus, the tokenizer decides which characters may begin a word, and this state determines which characters may appear as a second or later character in a word. These are typically different sets of characters; in particular, it is typical for digits to appear as parts of a word, but not as the initial character of a word.</p>
                <p>By default, the following characters may appear in a word. The method setWordChars() allows customizing this.</p>
@code
     From     To
      'a'    'z'
      'A'    'Z'
      '0'    '9'
@endcode
                <p>as well as: minus sign <tt>-</tt>, underscore <tt>_</tt>, and apostrophe <tt>'</tt>.</p>
*/
@interface TDWordState : TDTokenizerState {
    NSMutableArray *wordChars;
}

/*!
    @brief      Establish characters in the given range as valid characters for part of a word after the first character. Note that the tokenizer must determine which characters are valid as the beginning character of a word.
    @param      yn true if characters in the given range are word characters
    @param      start the "start" character. e.g. <tt>'a'</tt> or <tt>65</tt>.
    @param      end the "end" character. <tt>'z'</tt> or <tt>90</tt>.
*/
- (void)setWordChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end;

/*!
    @brief      Informs whether the given character is recognized as a word character by this state.
    @param      cin the character to check
    @result     true if the given chracter is recognized as a word character
*/
- (BOOL)isWordChar:(NSInteger)c;
@end

//
//  TDSingleLineCommentState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDSingleLineCommentState : TDTokenizerState {
    NSMutableArray *startSymbols;
    NSString *currentStartSymbol;
}

@end

//
//  TDToken.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @typedef    enum TDTokenType
    @brief      Indicates the type of a <tt>TDToken</tt>
    @var        TDTokenTypeEOF A constant indicating that the endo fo the stream has been read.
    @var        TDTokenTypeNumber A constant indicating that a token is a number, like <tt>3.14</tt>.
    @var        TDTokenTypeQuotedString A constant indicating that a token is a quoted string, like <tt>"Launch Mi"</tt>.
    @var        TDTokenTypeSymbol A constant indicating that a token is a symbol, like <tt>"&lt;="</tt>.
    @var        TDTokenTypeWord A constant indicating that a token is a word, like <tt>cat</tt>.
*/
typedef enum {
    TDTokenTypeEOF,
    TDTokenTypeNumber,
    TDTokenTypeQuotedString,
    TDTokenTypeSymbol,
    TDTokenTypeWord,
    TDTokenTypeWhitespace,
    TDTokenTypeComment
} TDTokenType;

/*!
    @class      TDToken
    @brief      A token represents a logical chunk of a string.
    @details    For example, a typical tokenizer would break the string <tt>"1.23 &lt;= 12.3"</tt> into three tokens: the number <tt>1.23</tt>, a less-than-or-equal symbol, and the number <tt>12.3</tt>. A token is a receptacle, and relies on a tokenizer to decide precisely how to divide a string into tokens.
*/
@interface TDToken : NSObject {
    CGFloat floatValue;
    NSString *stringValue;
    TDTokenType tokenType;
    
    BOOL number;
    BOOL quotedString;
    BOOL symbol;
    BOOL word;
    BOOL whitespace;
    BOOL comment;
    
    id value;
}

/*!
    @brief      Factory method for creating a singleton <tt>TDToken</tt> used to indicate that there are no more tokens.
    @result     A singleton used to indicate that there are no more tokens.
*/
+ (TDToken *)EOFToken;

/*!
    @brief      Factory convenience method for creating an autoreleased token.
    @param      t the type of this token.
    @param      s the string value of this token.
    @param      n the number falue of this token.
    @result     an autoreleased initialized token.
*/
+ (id)tokenWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n;

/*!
    @brief      Designated initializer. Constructs a token of the indicated type and associated string or numeric values.
    @param      t the type of this token.
    @param      s the string value of this token.
    @param      n the number falue of this token.
    @result     an autoreleased initialized token.
*/
- (id)initWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n;

/*!
    @brief      Returns true if the supplied object is an equivalent <tt>TDToken</tt>, ignoring differences in case.
    @param      obj the object to compare this token to.
    @result     true if <tt>obj</tt> is an equivalent <tt>TDToken</tt>, ignoring differences in case.
*/
- (BOOL)isEqualIgnoringCase:(id)obj;

/*!
    @brief      Returns more descriptive textual representation than <tt>-description</tt> which may be useful for debugging puposes only.
    @details    Usually of format similar to: <tt>&lt;QuotedString "Launch Mi"></tt>, <tt>&lt;Word cat></tt>, or <tt>&lt;Num 3.14></tt>
    @result     A textual representation including more descriptive information than <tt>-description</tt>.
*/
- (NSString *)debugDescription;

/*!
    @property   number
    @brief      True if this token is a number. getter=isNumber
*/
@property (nonatomic, readonly, getter=isNumber) BOOL number;

/*!
    @property   quotedString
    @brief      True if this token is a quoted string. getter=isQuotedString
*/
@property (nonatomic, readonly, getter=isQuotedString) BOOL quotedString;

/*!
    @property   symbol
    @brief      True if this token is a symbol. getter=isSymbol
*/
@property (nonatomic, readonly, getter=isSymbol) BOOL symbol;

/*!
    @property   word
    @brief      True if this token is a word. getter=isWord
*/
@property (nonatomic, readonly, getter=isWord) BOOL word;

/*!
    @property   whitespace
    @brief      True if this token is whitespace. getter=isWhitespace
*/
@property (nonatomic, readonly, getter=isWhitespace) BOOL whitespace;

/*!
    @property   comment
    @brief      True if this token is a comment. getter=isComment
*/
@property (nonatomic, readonly, getter=isComment) BOOL comment;

/*!
    @property   tokenType
    @brief      The type of this token.
*/
@property (nonatomic, readonly) TDTokenType tokenType;

/*!
    @property   floatValue
    @brief      The numeric value of this token.
*/
@property (nonatomic, readonly) CGFloat floatValue;

/*!
    @property   stringValue
    @brief      The string value of this token.
*/
@property (nonatomic, readonly, copy) NSString *stringValue;

/*!
    @property   value
    @brief      Returns an object that represents the value of this token.
*/
@property (nonatomic, readonly, copy) id value;
@end

//
//  TDSymbolNode.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @class      TDSymbolNode 
    @brief      A <tt>TDSymbolNode</tt> object is a member of a tree that contains all possible prefixes of allowable symbols.
    @details    A <tt>TDSymbolNode</tt> object is a member of a tree that contains all possible prefixes of allowable symbols. Multi-character symbols appear in a <tt>TDSymbolNode</tt> tree with one node for each character. For example, the symbol <tt>=:~</tt> will appear in a tree as three nodes. The first node contains an equals sign, and has a child; that child contains a colon and has a child; this third child contains a tilde, and has no children of its own. If the colon node had another child for a dollar sign character, then the tree would contain the symbol <tt>=:$</tt>. A tree of <tt>TDSymbolNode</tt> objects collaborate to read a (potentially multi-character) symbol from an input stream. A root node with no character of its own finds an initial node that represents the first character in the input. This node looks to see if the next character in the stream matches one of its children. If so, the node delegates its reading task to its child. This approach walks down the tree, pulling symbols from the input that match the path down the tree. When a node does not have a child that matches the next character, we will have read the longest possible symbol prefix. This prefix may or may not be a valid symbol. Consider a tree that has had <tt>=:~</tt> added and has not had <tt>=:</tt> added. In this tree, of the three nodes that contain =:~, only the first and third contain complete symbols. If, say, the input contains <tt>=:a</tt>, the colon node will not have a child that matches the <tt>'a'</tt> and so it will stop reading. The colon node has to "unread": it must push back its character, and ask its parent to unread. Unreading continues until it reaches an ancestor that represents a valid symbol.
*/
@interface TDSymbolNode : NSObject {
    NSString *ancestry;
    TDSymbolNode *parent;
    NSMutableDictionary *children;
    NSInteger character;
    NSString *string;
}

/*!
    @brief      Initializes a <tt>TDSymbolNode</tt> with the given parent, representing the given character.
    @param      p the parent of this node
    @param      c the character for this node
    @result     An initialized <tt>TDSymbolNode</tt>
*/
- (id)initWithParent:(TDSymbolNode *)p character:(NSInteger)c;

/*!
    @property   ancestry
    @brief      The string of the mulit-character symbol this node represents.
*/
@property (nonatomic, readonly, retain) NSString *ancestry;
@end

//
//  TDSymbolRootNode.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDReader;

/*!
    @class      TDSymbolRootNode 
    @brief      This class is a special case of a <tt>TDSymbolNode</tt>.
    @details    This class is a special case of a <tt>TDSymbolNode</tt>. A <tt>TDSymbolRootNode</tt> object has no symbol of its own, but has children that represent all possible symbols.
*/
@interface TDSymbolRootNode : TDSymbolNode {
}

/*!
    @brief      Adds the given string as a multi-character symbol.
    @param      s a multi-character symbol that should be recognized as a single symbol token by this state
*/
- (void)add:(NSString *)s;

/*!
    @brief      Removes the given string as a multi-character symbol.
    @param      s a multi-character symbol that should no longer be recognized as a single symbol token by this state
    @details    if <tt>s</tt> was never added as a multi-character symbol, this has no effect
*/
- (void)remove:(NSString *)s;

/*!
    @brief      Return a symbol string from a reader.
    @param      r the reader from which to read
    @param      cin the character from witch to start
    @result     a symbol string from a reader
*/
- (NSString *)nextSymbol:(TDReader *)r startingWith:(NSInteger)cin;
@end

//
//  TDParseKit.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//


@interface TDTokenizer ()
- (void)addTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end;
- (TDTokenizerState *)tokenizerStateFor:(NSInteger)c;
@property (nonatomic, retain) TDReader *reader;
@property (nonatomic, retain) NSMutableArray *tokenizerStates;
@end

@implementation TDTokenizer

+ (id)tokenizer {
    return [self tokenizerWithString:nil];
}


+ (id)tokenizerWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    self = [super init];
    if (self) {
        self.string = s;
        self.reader = [[[TDReader alloc] init] autorelease];
        
        numberState = [[TDNumberState alloc] init];
        quoteState = [[TDQuoteState alloc] init];
        commentState = [[TDCommentState alloc] init];
        symbolState = [[TDSymbolState alloc] init];
        whitespaceState = [[TDWhitespaceState alloc] init];
        wordState = [[TDWordState alloc] init];
        
        [symbolState add:@"<="];
        [symbolState add:@">="];
        [symbolState add:@"!="];
        [symbolState add:@"=="];
        
        [commentState addSingleLineStartSymbol:@"//"];
        [commentState addMultiLineStartSymbol:@"/*" endSymbol:@"*/"];
        
        tokenizerStates = [[NSMutableArray alloc] initWithCapacity:256];
        
        [self addTokenizerState:whitespaceState from:   0 to: ' ']; // From:  0 to: 32    From:0x00 to:0x20
        [self addTokenizerState:symbolState     from:  33 to:  33];
        [self addTokenizerState:quoteState      from: '"' to: '"']; // From: 34 to: 34    From:0x22 to:0x22
        [self addTokenizerState:symbolState     from:  35 to:  38];
        [self addTokenizerState:quoteState      from:'\'' to:'\'']; // From: 39 to: 39    From:0x27 to:0x27
        [self addTokenizerState:symbolState     from:  40 to:  42];
        [self addTokenizerState:symbolState     from: '+' to: '+']; // From: 43 to: 43    From:0x2B to:0x2B
        [self addTokenizerState:symbolState     from:  44 to:  44];
        [self addTokenizerState:numberState     from: '-' to: '-']; // From: 45 to: 45    From:0x2D to:0x2D
        [self addTokenizerState:numberState     from: '.' to: '.']; // From: 46 to: 46    From:0x2E to:0x2E
        [self addTokenizerState:commentState    from: '/' to: '/']; // From: 47 to: 47    From:0x2F to:0x2F
        [self addTokenizerState:numberState     from: '0' to: '9']; // From: 48 to: 57    From:0x30 to:0x39
        [self addTokenizerState:symbolState     from:  58 to:  64];
        [self addTokenizerState:wordState       from: 'A' to: 'Z']; // From: 65 to: 90    From:0x41 to:0x5A
        [self addTokenizerState:symbolState     from:  91 to:  96];
        [self addTokenizerState:wordState       from: 'a' to: 'z']; // From: 97 to:122    From:0x61 to:0x7A
        [self addTokenizerState:symbolState     from: 123 to: 191];
        [self addTokenizerState:wordState       from:0xC0 to:0xFF]; // From:192 to:255    From:0xC0 to:0xFF
    }
    return self;
}


- (void)dealloc {
    self.string = nil;
    self.reader = nil;
    self.tokenizerStates = nil;
    self.numberState = nil;
    self.quoteState = nil;
    self.commentState = nil;
    self.symbolState = nil;
    self.whitespaceState = nil;
    self.wordState = nil;
    [super dealloc];
}


- (TDToken *)nextToken {
    NSInteger c = [reader read];
    
    TDToken *result = nil;
    
    if (-1 == c) {
        result = [TDToken EOFToken];
    } else {
        TDTokenizerState *state = [self tokenizerStateFor:c];
        if (state) {
            result = [state nextTokenFromReader:reader startingWith:c tokenizer:self];
        } else {
            result = [TDToken EOFToken];
        }
    }
    
    return result;
}


- (void)addTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end {
    NSParameterAssert(state);
    
    //void (*addObject)(id, SEL, id);
    //addObject = (void (*)(id, SEL, id))[tokenizerStates methodForSelector:@selector(addObject:)];
    
    NSInteger i = start;
    for ( ; i <= end; i++) {
        [tokenizerStates addObject:state];
        //addObject(tokenizerStates, @selector(addObject:), state);
    }
}


- (void)setTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end {
    NSParameterAssert(state);

    //void (*relaceObject)(id, SEL, NSUInteger, id);
    //relaceObject = (void (*)(id, SEL, NSUInteger, id))[tokenizerStates methodForSelector:@selector(replaceObjectAtIndex:withObject:)];

    NSInteger i = start;
    for ( ; i <= end; i++) {
        [tokenizerStates replaceObjectAtIndex:i withObject:state];
        //relaceObject(tokenizerStates, @selector(replaceObjectAtIndex:withObject:), i, state);
    }
}


- (TDReader *)reader {
    return reader;
}


- (void)setReader:(TDReader *)r {
    if (reader != r) {
        [reader release];
        reader = [r retain];
        reader.string = string;
    }
}


- (NSString *)string {
    return string;
}


- (void)setString:(NSString *)s {
    if (string != s) {
        [string retain];
        string = [s retain];
    }
    reader.string = string;
}


#pragma mark -

- (TDTokenizerState *)tokenizerStateFor:(NSInteger)c {
    if (c < 0 || c > 255) {
        if (c >= 0x19E0 && c <= 0x19FF) { // khmer symbols
            return symbolState;
        } else if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
            return symbolState;
        } else if (c >= 0x2E00 && c <= 0x2E7F) { // supplemental punctuation
            return symbolState;
        } else if (c >= 0x3000 && c <= 0x303F) { // cjk symbols & punctuation
            return symbolState;
        } else if (c >= 0x3200 && c <= 0x33FF) { // enclosed cjk letters and months, cjk compatibility
            return symbolState;
        } else if (c >= 0x4DC0 && c <= 0x4DFF) { // yijing hexagram symbols
            return symbolState;
        } else if (c >= 0xFE30 && c <= 0xFE6F) { // cjk compatibility forms, small form variants
            return symbolState;
        } else if (c >= 0xFF00 && c <= 0xFFFF) { // hiragana & katakana halfwitdh & fullwidth forms, Specials
            return symbolState;
        } else {
            return wordState;
        }
    }
    return [tokenizerStates objectAtIndex:c];
}

@synthesize numberState;
@synthesize quoteState;
@synthesize commentState;
@synthesize symbolState;
@synthesize whitespaceState;
@synthesize wordState;
@synthesize string;
@synthesize tokenizerStates;
@end

//
//  TDReader.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//


@implementation TDReader

- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    self = [super init];
    if (self) {
        self.string = s;
    }
    return self;
}


- (void)dealloc {
    self.string = nil;
    [super dealloc];
}


- (NSString *)string {
    return string;
}


- (void)setString:(NSString *)s {
    if (string != s) {
        [string release];
        string = [s retain];
        length = string.length;
    }
    // reset cursor
    cursor = 0;
}


- (NSInteger)read {
    if (0 == length || cursor > length - 1) {
        return -1;
    }
    return [string characterAtIndex:cursor++];
}


- (void)unread {
    cursor = (0 == cursor) ? 0 : cursor - 1;
}

@end

//
//  TDParseKitState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//


@interface TDTokenizerState ()
- (void)reset;
- (void)append:(NSInteger)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;

#if TD_USE_MUTABLE_STRING_BUF
@property (nonatomic, retain) NSMutableString *stringbuf;
#else
- (void)checkBufLength;
- (unichar *)mallocCharbuf:(NSUInteger)size;
#endif
@end

@implementation TDTokenizerState

- (void)dealloc {
#if TD_USE_MUTABLE_STRING_BUF
    self.stringbuf = nil;
#else
    if (charbuf && ![[NSGarbageCollector defaultCollector] isEnabled]) {
        free(charbuf);
        charbuf = NULL;
    }
#endif
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSAssert(0, @"TDTokenizerState is an Abstract Classs. nextTokenFromStream:at:tokenizer: must be overriden");
    return nil;
}


- (void)reset {
#if TD_USE_MUTABLE_STRING_BUF
    self.stringbuf = [NSMutableString string];
#else
    if (charbuf && ![[NSGarbageCollector defaultCollector] isEnabled]) {
        free(charbuf);
        charbuf = NULL;
    }
    index = 0;
    length = 16;
    charbuf = [self mallocCharbuf:length];
#endif
}


- (void)append:(NSInteger)c {
#if TD_USE_MUTABLE_STRING_BUF
    [stringbuf appendFormat:@"%C", (unsigned short)c];
#else 
    [self checkBufLength];
    charbuf[index++] = c;
#endif
}


- (void)appendString:(NSString *)s {
#if TD_USE_MUTABLE_STRING_BUF
    [stringbuf appendString:s];
#else 
    // TODO
    NSAssert1(0, @"-[TDTokenizerState %s] not impl for charbuf", _cmd);
#endif
}


- (NSString *)bufferedString {
#if TD_USE_MUTABLE_STRING_BUF
    return [[stringbuf copy] autorelease];
#else
    return [[[NSString alloc] initWithCharacters:(const unichar *)charbuf length:index] autorelease];
//    return [[[NSString alloc] initWithBytes:charbuf length:index encoding:NSUTF8StringEncoding] autorelease];
#endif
}


#if TD_USE_MUTABLE_STRING_BUF
#else
- (void)checkBufLength {
    if (index >= length) {
        unichar *nb = [self mallocCharbuf:length * 2];
        
        NSInteger j = 0;
        for ( ; j < length; j++) {
            nb[j] = charbuf[j];
        }
        if (![[NSGarbageCollector defaultCollector] isEnabled]) {
            free(charbuf);
            charbuf = NULL;
        }
        charbuf = nb;
        
        length = length * 2;
    }
}


- (unichar *)mallocCharbuf:(NSUInteger)size {
    unichar *result = NULL;
    if ((result = (unichar *)NSAllocateCollectable(size, 0)) == NULL) {
        [NSException raise:@"Out of memory" format:nil];
    }
    return result;
}
#endif

#if TD_USE_MUTABLE_STRING_BUF
@synthesize stringbuf;
#endif
@end

//
//  TDQuoteState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//




@implementation TDQuoteState

- (void)dealloc {
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    [self reset];
    
    [self append:cin];
    NSInteger c;
    do {
        c = [r read];
        if (-1 == c) {
            c = cin;
            if (balancesEOFTerminatedQuotes) {
                [self append:c];
            }
        } else {
            [self append:c];
        }
        
    } while (c != cin);
    
    return [TDToken tokenWithTokenType:TDTokenTypeQuotedString stringValue:[self bufferedString] floatValue:0.0];
}

@synthesize balancesEOFTerminatedQuotes;
@end

//
//  TDMultiLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//








@implementation TDMultiLineCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.startSymbols = [NSMutableArray array];
        self.endSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startSymbols = nil;
    self.endSymbols = nil;
    self.currentStartSymbol = nil;
    [super dealloc];
}


- (void)addStartSymbol:(NSString *)start endSymbol:(NSString *)end {
    NSParameterAssert(start.length);
    NSParameterAssert(end.length);
    [startSymbols addObject:start];
    [endSymbols addObject:end];
}


- (void)removeStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    NSInteger i = [startSymbols indexOfObject:start];
    if (NSNotFound != i) {
        [startSymbols removeObject:start];
        [endSymbols removeObjectAtIndex:i]; // this should always be in range.
    }
}


- (void)unreadSymbol:(NSString *)s fromReader:(TDReader *)r {
    NSInteger len = s.length;
    NSInteger i = 0;
    for ( ; i < len - 1; i++) {
        [r unread];
    }
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    BOOL balanceEOF = t.commentState.balancesEOFTerminatedComments;
    BOOL reportTokens = t.commentState.reportsCommentTokens;
    if (reportTokens) {
        [self reset];
        [self appendString:currentStartSymbol];
    }
    
    NSInteger i = [startSymbols indexOfObject:currentStartSymbol];
    NSString *currentEndSymbol = [endSymbols objectAtIndex:i];
    NSInteger e = [currentEndSymbol characterAtIndex:0];
    
    // get the definitions of all multi-char comment start and end symbols from the commentState
    TDSymbolRootNode *rootNode = t.commentState.rootNode;
        
    NSInteger c;
    while (1) {
        c = [r read];
        if (-1 == c) {
            if (balanceEOF) {
                [self appendString:currentEndSymbol];
            }
            break;
        }
        
        if (e == c) {
            NSString *peek = [rootNode nextSymbol:r startingWith:e];
            if ([currentEndSymbol isEqualToString:peek]) {
                if (reportTokens) {
                    [self appendString:currentEndSymbol];
                }
                c = [r read];
                break;
            } else {
                [self unreadSymbol:peek fromReader:r];
                if (e != [peek characterAtIndex:0]) {
                    if (reportTokens) {
                        [self append:c];
                    }
                    c = [r read];
                }
            }
        }
        if (reportTokens) {
            [self append:c];
        }
    }
    
    if (-1 != c) {
        [r unread];
    }
    
    self.currentStartSymbol = nil;

    if (reportTokens) {
        return [TDToken tokenWithTokenType:TDTokenTypeComment stringValue:[self bufferedString] floatValue:0.0];
    } else {
        return [t nextToken];
    }
}

@synthesize startSymbols;
@synthesize endSymbols;
@synthesize currentStartSymbol;
@end

//
//  TDCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//




@interface TDSingleLineCommentState ()
- (void)addStartSymbol:(NSString *)start;
- (void)removeStartSymbol:(NSString *)start;
@property (nonatomic, retain) NSMutableArray *startSymbols;
@property (nonatomic, retain) NSString *currentStartSymbol;
@end



@implementation TDCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.rootNode = [[[TDSymbolRootNode alloc] init] autorelease];
        self.singleLineState = [[[TDSingleLineCommentState alloc] init] autorelease];
        self.multiLineState = [[[TDMultiLineCommentState alloc] init] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    self.singleLineState = nil;
    self.multiLineState = nil;
    [super dealloc];
}


- (void)addSingleLineStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode add:start];
    [singleLineState addStartSymbol:start];
}


- (void)removeSingleLineStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode remove:start];
    [singleLineState removeStartSymbol:start];
}


- (void)addMultiLineStartSymbol:(NSString *)start endSymbol:(NSString *)end {
    NSParameterAssert(start.length);
    NSParameterAssert(end.length);
    [rootNode add:start];
    [rootNode add:end];
    [multiLineState addStartSymbol:start endSymbol:end];
}


- (void)removeMultiLineStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode remove:start];
    [multiLineState removeStartSymbol:start];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);

    NSString *symbol = [rootNode nextSymbol:r startingWith:cin];

    if ([multiLineState.startSymbols containsObject:symbol]) {
        multiLineState.currentStartSymbol = symbol;
        return [multiLineState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else if ([singleLineState.startSymbols containsObject:symbol]) {
        singleLineState.currentStartSymbol = symbol;
        return [singleLineState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else {
        NSInteger i = 0;
        for ( ; i < symbol.length - 1; i++) {
            [r unread];
        }
        return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:[NSString stringWithFormat:@"%C", (unsigned short)cin] floatValue:0.0];
    }
}

@synthesize rootNode;
@synthesize singleLineState;
@synthesize multiLineState;
@synthesize reportsCommentTokens;
@synthesize balancesEOFTerminatedComments;
@end

//
//  TDSymbolState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//


@interface TDSymbolState ()
@property (nonatomic, retain) TDSymbolRootNode *rootNode;
@property (nonatomic, retain) NSMutableArray *addedSymbols;
@end

@implementation TDSymbolState

- (id)init {
    self = [super init];
    if (self) {
        self.rootNode = [[[TDSymbolRootNode alloc] init] autorelease];
        self.addedSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    self.addedSymbols = nil;
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSString *symbol = [rootNode nextSymbol:r startingWith:cin];
    NSInteger len = symbol.length;

    if (0 == len || (len > 1 && [addedSymbols containsObject:symbol])) {
        return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:symbol floatValue:0.0];
    } else {
        NSInteger i = 0;
        for ( ; i < len - 1; i++) {
            [r unread];
        }
        return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:[NSString stringWithFormat:@"%C", (unsigned short)cin] floatValue:0.0];
    }
}


- (void)add:(NSString *)s {
    NSParameterAssert(s);
    [rootNode add:s];
    [addedSymbols addObject:s];
}


- (void)remove:(NSString *)s {
    NSParameterAssert(s);
    [rootNode remove:s];
    [addedSymbols removeObject:s];
}

@synthesize rootNode;
@synthesize addedSymbols;
@end

//
//  TDNumberState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//




@interface TDNumberState ()
- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)fraction;
- (CGFloat)value;
- (void)parseLeftSideFromReader:(TDReader *)r;
- (void)parseRightSideFromReader:(TDReader *)r;
- (void)reset:(NSInteger)cin;
@end

@implementation TDNumberState

- (void)dealloc {
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);

    [self reset];
    negative = NO;
    NSInteger originalCin = cin;
    
    if ('-' == cin) {
        negative = YES;
        cin = [r read];
        [self append:'-'];
    } else if ('+' == cin) {
        cin = [r read];
        [self append:'+'];
    }
    
    [self reset:cin];
    if ('.' == c) {
        [self parseRightSideFromReader:r];
    } else {
        [self parseLeftSideFromReader:r];
        [self parseRightSideFromReader:r];
    }
    
    // erroneous ., +, or -
    if (!gotADigit) {
        if (negative && -1 != c) { // ??
            [r unread];
        }
        return [t.symbolState nextTokenFromReader:r startingWith:originalCin tokenizer:t];
    }
    
    if (-1 != c) {
        [r unread];
    }

    if (negative) {
        floatValue = -floatValue;
    }
    
    return [TDToken tokenWithTokenType:TDTokenTypeNumber stringValue:[self bufferedString] floatValue:[self value]];
}


- (CGFloat)value {
    return floatValue;
}


- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)isFraction {
    CGFloat divideBy = 1.0;
    CGFloat v = 0.0;
    
    while (1) {
        if (isdigit((int)c)) {
            [self append:c];
            gotADigit = YES;
            v = v * 10.0 + (c - '0');
            c = [r read];
            if (isFraction) {
                divideBy *= 10.0;
            }
        } else {
            break;
        }
    }
    
    if (isFraction) {
        v = v / divideBy;
    }

    return (CGFloat)v;
}


- (void)parseLeftSideFromReader:(TDReader *)r {
    floatValue = [self absorbDigitsFromReader:r isFraction:NO];
}


- (void)parseRightSideFromReader:(TDReader *)r {
    if ('.' == c) {
        NSInteger n = [r read];
        BOOL nextIsDigit = isdigit((int)n);
        if (-1 != n) {
            [r unread];
        }

        if (nextIsDigit || allowsTrailingDot) {
            [self append:'.'];
            if (nextIsDigit) {
                c = [r read];
                floatValue += [self absorbDigitsFromReader:r isFraction:YES];
            }
        }
    }
}


- (void)reset:(NSInteger)cin {
    gotADigit = NO;
    floatValue = 0.0;
    c = cin;
}

@synthesize allowsTrailingDot;
@end

//
//  TDWhitespaceState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//


#define TDTRUE (id)kCFBooleanTrue
#define TDFALSE (id)kCFBooleanFalse



@interface TDWhitespaceState ()
@property (nonatomic, retain) NSMutableArray *whitespaceChars;
@end

@implementation TDWhitespaceState

- (id)init {
    self = [super init];
    if (self) {
        const NSUInteger len = 255;
        self.whitespaceChars = [NSMutableArray arrayWithCapacity:len];
        NSUInteger i = 0;
        for ( ; i <= len; i++) {
            [whitespaceChars addObject:TDFALSE];
        }
        
        [self setWhitespaceChars:YES from:0 to:' '];
    }
    return self;
}


- (void)dealloc {
    self.whitespaceChars = nil;
    [super dealloc];
}


- (void)setWhitespaceChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end {
    NSUInteger len = whitespaceChars.count;
    if (start > len || end > len || start < 0 || end < 0) {
        [NSException raise:@"TDWhitespaceStateNotSupportedException" format:@"TDWhitespaceState only supports setting word chars for chars in the latin1 set (under 256)"];
    }

    id obj = yn ? TDTRUE : TDFALSE;
    NSUInteger i = start;
    for ( ; i <= end; i++) {
        [whitespaceChars replaceObjectAtIndex:i withObject:obj];
    }
}


- (BOOL)isWhitespaceChar:(NSInteger)cin {
    if (cin < 0 || cin > whitespaceChars.count - 1) {
        return NO;
    }
    return TDTRUE == [whitespaceChars objectAtIndex:cin];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    if (reportsWhitespaceTokens) {
        [self reset];
    }
    
    NSInteger c = cin;
    while ([self isWhitespaceChar:c]) {
        if (reportsWhitespaceTokens) {
            [self append:c];
        }
        c = [r read];
    }
    if (-1 != c) {
        [r unread];
    }
    
    if (reportsWhitespaceTokens) {
        return [TDToken tokenWithTokenType:TDTokenTypeWhitespace stringValue:[self bufferedString] floatValue:0.0];
    } else {
        return [t nextToken];
    }
}

@synthesize whitespaceChars;
@synthesize reportsWhitespaceTokens;
@end


//
//  TDWordState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//


#define TDTRUE (id)kCFBooleanTrue
#define TDFALSE (id)kCFBooleanFalse



@interface TDWordState () 
- (BOOL)isWordChar:(NSInteger)c;

@property (nonatomic, retain) NSMutableArray *wordChars;
@end

@implementation TDWordState

- (id)init {
    self = [super init];
    if (self) {
        const NSUInteger len = 255;
        self.wordChars = [NSMutableArray arrayWithCapacity:len];
        NSInteger i = 0;
        for ( ; i <= len; i++) {
            [wordChars addObject:TDFALSE];
        }
        
        [self setWordChars:YES from: 'a' to: 'z'];
        [self setWordChars:YES from: 'A' to: 'Z'];
        [self setWordChars:YES from: '0' to: '9'];
        [self setWordChars:YES from: '-' to: '-'];
        [self setWordChars:YES from: '_' to: '_'];
        [self setWordChars:YES from:'\'' to:'\''];
        [self setWordChars:YES from:0xC0 to:0xFF];
    }
    return self;
}


- (void)dealloc {
    self.wordChars = nil;
    [super dealloc];
}


- (void)setWordChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end {
    NSInteger len = wordChars.count;
    if (start > len || end > len || start < 0 || end < 0) {
        [NSException raise:@"TDWordStateNotSupportedException" format:@"TDWordState only supports setting word chars for chars in the latin1 set (under 256)"];
    }
    
    id obj = yn ? TDTRUE : TDFALSE;
    NSInteger i = start;
    for ( ; i <= end; i++) {
        [wordChars replaceObjectAtIndex:i withObject:obj];
    }
}


- (BOOL)isWordChar:(NSInteger)c {    
    if (c > -1 && c < wordChars.count - 1) {
        return (TDTRUE == [wordChars objectAtIndex:c]);
    }

    if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
        return NO;
    } else if (c >= 0xFE30 && c <= 0xFE6F) { // general punctuation
        return NO;
    } else if (c >= 0xFE30 && c <= 0xFE6F) { // western musical symbols
        return NO;
    } else if (c >= 0xFF00 && c <= 0xFF65) { // symbols within Hiragana & Katakana
        return NO;            
    } else if (c >= 0xFFF0 && c <= 0xFFFF) { // specials
        return NO;            
    } else if (c < 0) {
        return NO;
    } else {
        return YES;
    }
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    [self reset];
    
    NSInteger c = cin;
    do {
        [self append:c];
        c = [r read];
    } while ([self isWordChar:c]);
    
    if (-1 != c) {
        [r unread];
    }
    
    return [TDToken tokenWithTokenType:TDTokenTypeWord stringValue:[self bufferedString] floatValue:0.0];
}


@synthesize wordChars;
@end

//
//  TDSingleLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//





@implementation TDSingleLineCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.startSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startSymbols = nil;
    self.currentStartSymbol = nil;
    [super dealloc];
}


- (void)addStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [startSymbols addObject:start];
}


- (void)removeStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [startSymbols removeObject:start];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    BOOL reportTokens = t.commentState.reportsCommentTokens;
    if (reportTokens) {
        [self reset];
        if (currentStartSymbol.length > 1) {
            [self appendString:currentStartSymbol];
        }
    }
    
    NSInteger c;
    while (1) {
        c = [r read];
        if ('\n' == c || '\r' == c || -1 == c) {
            break;
        }
        if (reportTokens) {
            [self append:c];
        }
    }
    
    if (-1 != c) {
        [r unread];
    }
    
    self.currentStartSymbol = nil;
    
    if (reportTokens) {
        return [TDToken tokenWithTokenType:TDTokenTypeComment stringValue:[self bufferedString] floatValue:0.0];
    } else {
        return [t nextToken];
    }
}

@synthesize startSymbols;
@synthesize currentStartSymbol;
@end

//
//  TDToken.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//


@interface TDTokenEOF : TDToken {}
+ (TDTokenEOF *)instance;
@end

@implementation TDTokenEOF

static TDTokenEOF *EOFToken = nil;

+ (TDTokenEOF *)instance {
    @synchronized(self) {
        if (!EOFToken) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return EOFToken;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (!EOFToken) {
            EOFToken = [super allocWithZone:zone];
            return EOFToken;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (id)retain {
    return self;
}


- (oneway void)release {
    // do nothing
}


- (id)autorelease {
    return self;
}


- (NSUInteger)retainCount {
    return UINT_MAX; // denotes an object that cannot be released
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<TDTokenEOF %p>", self];
}


- (NSString *)debugDescription {
    return [self description];
}

@end

@interface TDToken ()
- (BOOL)isEqual:(id)rhv ignoringCase:(BOOL)ignoringCase;

@property (nonatomic, readwrite, getter=isNumber) BOOL number;
@property (nonatomic, readwrite, getter=isQuotedString) BOOL quotedString;
@property (nonatomic, readwrite, getter=isSymbol) BOOL symbol;
@property (nonatomic, readwrite, getter=isWord) BOOL word;
@property (nonatomic, readwrite, getter=isWhitespace) BOOL whitespace;
@property (nonatomic, readwrite, getter=isComment) BOOL comment;

@property (nonatomic, readwrite) CGFloat floatValue;
@property (nonatomic, readwrite, copy) NSString *stringValue;
@property (nonatomic, readwrite) TDTokenType tokenType;
@property (nonatomic, readwrite, copy) id value;
@end

@implementation TDToken

+ (TDToken *)EOFToken {
    return [TDTokenEOF instance];
}


+ (id)tokenWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n {
    return [[[self alloc] initWithTokenType:t stringValue:s floatValue:n] autorelease];
}


// designated initializer
- (id)initWithTokenType:(TDTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n {
    //NSParameterAssert(s);
    self = [super init];
    if (self) {
        self.tokenType = t;
        self.stringValue = s;
        self.floatValue = n;
        
        self.number = (TDTokenTypeNumber == t);
        self.quotedString = (TDTokenTypeQuotedString == t);
        self.symbol = (TDTokenTypeSymbol == t);
        self.word = (TDTokenTypeWord == t);
        self.whitespace = (TDTokenTypeWhitespace == t);
        self.comment = (TDTokenTypeComment == t);
    }
    return self;
}


- (void)dealloc {
    self.stringValue = nil;
    self.value = nil;
    [super dealloc];
}


- (NSUInteger)hash {
    return [stringValue hash];
}


- (BOOL)isEqual:(id)rhv {
    return [self isEqual:rhv ignoringCase:NO];
}


- (BOOL)isEqualIgnoringCase:(id)rhv {
    return [self isEqual:rhv ignoringCase:YES];
}


- (BOOL)isEqual:(id)rhv ignoringCase:(BOOL)ignoringCase {
    if (![rhv isMemberOfClass:[TDToken class]]) {
        return NO;
    }
    
    TDToken *tok = (TDToken *)rhv;
    if (tokenType != tok.tokenType) {
        return NO;
    }
    
    if (self.isNumber) {
        return floatValue == tok.floatValue;
    } else {
        if (ignoringCase) {
            return (NSOrderedSame == [stringValue caseInsensitiveCompare:tok.stringValue]);
        } else {
            return [stringValue isEqualToString:tok.stringValue];
        }
    }
}


- (id)value {
    if (!value) {
        id v = nil;
        if (self.isNumber) {
            v = [NSNumber numberWithFloat:floatValue];
        } else if (self.isQuotedString) {
            v = stringValue;
        } else if (self.isSymbol) {
            v = stringValue;
        } else if (self.isWord) {
            v = stringValue;
        } else if (self.isWhitespace) {
            v = stringValue;
        } else { // support for token type extensions
            v = stringValue;
        }
        self.value = v;
    }
    return value;
}


- (NSString *)debugDescription {
    NSString *typeString = nil;
    if (self.isNumber) {
        typeString = @"Number";
    } else if (self.isQuotedString) {
        typeString = @"Quoted String";
    } else if (self.isSymbol) {
        typeString = @"Symbol";
    } else if (self.isWord) {
        typeString = @"Word";
    } else if (self.isWhitespace) {
        typeString = @"Whitespace";
    } else if (self.isComment) {
        typeString = @"Comment";
    }
    return [NSString stringWithFormat:@"<%@ %C%@%C>", typeString, (unsigned short)0x00AB, self.value, (unsigned short)0x00BB];
}


- (NSString *)description {
    return stringValue;
}

@synthesize number;
@synthesize quotedString;
@synthesize symbol;
@synthesize word;
@synthesize whitespace;
@synthesize comment;
@synthesize floatValue;
@synthesize stringValue;
@synthesize tokenType;
@synthesize value;
@end

//
//  TDSymbolNode.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//


@interface TDSymbolNode ()
@property (nonatomic, readwrite, retain) NSString *ancestry;
@property (nonatomic, assign) TDSymbolNode *parent;  // this must be 'assign' to avoid retain loop leak
@property (nonatomic, retain) NSMutableDictionary *children;
@property (nonatomic) NSInteger character;
@property (nonatomic, retain) NSString *string;

- (void)determineAncestry;
@end

@implementation TDSymbolNode

- (id)initWithParent:(TDSymbolNode *)p character:(NSInteger)c {
    self = [super init];
    if (self) {
        self.parent = p;
        self.character = c;
        self.children = [NSMutableDictionary dictionary];

        // this private property is an optimization. 
        // cache the NSString for the char to prevent it being constantly recreated in -determinAncestry
        self.string = [NSString stringWithFormat:@"%C", (unsigned short)character];

        [self determineAncestry];
    }
    return self;
}


- (void)dealloc {
    parent = nil; // makes clang static analyzer happy
    self.ancestry = nil;
    self.string = nil;
    self.children = nil;
    [super dealloc];
}


- (void)determineAncestry {
    if (-1 == parent.character) { // optimization for sinlge-char symbol (parent is symbol root node)
        self.ancestry = string;
    } else {
        NSMutableString *result = [NSMutableString string];
        
        TDSymbolNode *n = self;
        while (-1 != n.character) {
            [result insertString:n.string atIndex:0];
            n = n.parent;
        }
        
        self.ancestry = [[result copy] autorelease]; // assign an immutable copy
    }
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<TDSymbolNode %@>", self.ancestry];
}

@synthesize ancestry;
@synthesize parent;
@synthesize character;
@synthesize string;
@synthesize children;
@end

//
//  TDSymbolRootNode.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//




@interface TDSymbolRootNode ()
- (void)addWithFirst:(NSInteger)c rest:(NSString *)s parent:(TDSymbolNode *)p;
- (void)removeWithFirst:(NSInteger)c rest:(NSString *)s parent:(TDSymbolNode *)p;
- (NSString *)nextWithFirst:(NSInteger)c rest:(TDReader *)r parent:(TDSymbolNode *)p;
@end

@implementation TDSymbolRootNode

- (id)init {
    self = [super initWithParent:nil character:-1];
    if (self) {
        
    }
    return self;
}


- (void)add:(NSString *)s {
    NSParameterAssert(s);
    if (s.length < 2) return;
    
    [self addWithFirst:[s characterAtIndex:0] rest:[s substringFromIndex:1] parent:self];
}


- (void)remove:(NSString *)s {
    NSParameterAssert(s);
    if (s.length < 2) return;
    
    [self removeWithFirst:[s characterAtIndex:0] rest:[s substringFromIndex:1] parent:self];
}


- (void)addWithFirst:(NSInteger)c rest:(NSString *)s parent:(TDSymbolNode *)p {
    NSParameterAssert(p);
    NSNumber *key = [NSNumber numberWithInteger:c];
    TDSymbolNode *child = [p.children objectForKey:key];
    if (!child) {
        child = [[TDSymbolNode alloc] initWithParent:p character:c];
        [p.children setObject:child forKey:key];
        [child release];
    }

    NSString *rest = nil;
    
    if (0 == s.length) {
        return;
    } else if (s.length > 1) {
        rest = [s substringFromIndex:1];
    }
    
    [self addWithFirst:[s characterAtIndex:0] rest:rest parent:child];
}


- (void)removeWithFirst:(NSInteger)c rest:(NSString *)s parent:(TDSymbolNode *)p {
    NSParameterAssert(p);
    NSNumber *key = [NSNumber numberWithInteger:c];
    TDSymbolNode *child = [p.children objectForKey:key];
    if (child) {
        NSString *rest = nil;
        
        if (0 == s.length) {
            return;
        } else if (s.length > 1) {
            rest = [s substringFromIndex:1];
            [self removeWithFirst:[s characterAtIndex:0] rest:rest parent:child];
        }
        
        [p.children removeObjectForKey:key];
    }
}


- (NSString *)nextSymbol:(TDReader *)r startingWith:(NSInteger)cin {
    NSParameterAssert(r);
    return [self nextWithFirst:cin rest:r parent:self];
}


- (NSString *)nextWithFirst:(NSInteger)c rest:(TDReader *)r parent:(TDSymbolNode *)p {
    NSParameterAssert(p);
    NSString *result = [NSString stringWithFormat:@"%C", (unsigned short)c];

    // this also works.
//    NSString *result = [[[NSString alloc] initWithCharacters:(const unichar *)&c length:1] autorelease];
    
    // none of these work.
    //NSString *result = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding] autorelease];

//    NSLog(@"c: %d", c);
//    NSLog(@"string for c: %@", result);
//    NSString *chars = [[[NSString alloc] initWithCharacters:(const unichar *)&c length:1] autorelease];
//    NSString *utfs  = [[[NSString alloc] initWithUTF8String:(const char *)&c] autorelease];
//    NSString *utf8  = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF8StringEncoding] autorelease];
//    NSString *utf16 = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSUTF16StringEncoding] autorelease];
//    NSString *ascii = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSASCIIStringEncoding] autorelease];
//    NSString *iso   = [[[NSString alloc] initWithBytes:&c length:1 encoding:NSISOLatin1StringEncoding] autorelease];
//
//    NSLog(@"chars: '%@'", chars);
//    NSLog(@"utfs: '%@'", utfs);
//    NSLog(@"utf8: '%@'", utf8);
//    NSLog(@"utf16: '%@'", utf16);
//    NSLog(@"ascii: '%@'", ascii);
//    NSLog(@"iso: '%@'", iso);
    
    NSNumber *key = [NSNumber numberWithInteger:c];
    TDSymbolNode *child = [p.children objectForKey:key];
    
    if (!child) {
        if (p == self) {
            return result;
        } else {
            [r unread];
            return @"";
        }
    } 
    
    c = [r read];
    if (-1 == c) {
        return result;
    }
    
    return [result stringByAppendingString:[self nextWithFirst:c rest:r parent:child]];
}


- (NSString *)description {
    return @"<TDSymbolRootNode>";
}

@end


//
//  MOBridgeSupportController.m
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//









@implementation MOBridgeSupportController {
    NSMutableArray *_loadedURLs;
    NSMutableArray *_loadedLibraries;
    NSMutableDictionary *_symbols;
    MOBridgeSupportParser *_parser;
}

+ (MOBridgeSupportController *)sharedController {
    static MOBridgeSupportController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

- (id)init {
    self = [super init];
    if (self) {
        _loadedURLs = [[NSMutableArray alloc] init];
        _loadedLibraries = [[NSMutableArray alloc] init];
        _symbols = [[NSMutableDictionary alloc] init];
        _parser = [[MOBridgeSupportParser alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Loading

- (BOOL)isBridgeSupportLoadedForURL:(NSURL *)aURL {
    return [_loadedURLs containsObject:aURL];
}

- (BOOL)loadBridgeSupportAtURL:(NSURL *)aURL error:(NSError **)outError {
    if ([self isBridgeSupportLoadedForURL:aURL]) {
        return YES;
    }
    
    MOBridgeSupportLibrary *library = [_parser libraryWithBridgeSupportURL:aURL error:outError];
    if (library == nil) {
        return NO;
    }
    
    [_loadedURLs addObject:aURL];
    [_loadedLibraries addObject:library];
    
    for (NSString *name in library.symbols) {
        MOBridgeSupportSymbol *symbol = [library.symbols objectForKey:name];
        if ([_symbols objectForKey:name] == nil) {
            [_symbols setObject:symbol forKey:name];
        }
        else {
            //NSLog(@"Symbol with name \"%@\" is already loaded.", name);
        }
    }
    
    return YES;
}


#pragma mark -
#pragma mark Queries

- (NSDictionary *)symbols {
    return _symbols;
}

- (NSDictionary *)performQueryForSymbolsOfType:(NSArray *)classes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[_symbols count]];
    for (NSString *key in _symbols) {
        MOBridgeSupportSymbol *symbol = [_symbols objectForKey:key];
        for (Class klass in classes) {
            if ([symbol isKindOfClass:klass]) {
                [dictionary setObject:symbol forKey:[symbol name]];
            }
        }
    }
    return dictionary;
}

- (id)performQueryForSymbolName:(NSString *)name {
    return [_symbols objectForKey:name];
}

- (id)performQueryForSymbolName:(NSString *)name ofType:(Class)klass {
    id symbol = [self performQueryForSymbolName:name];
    if ([symbol isKindOfClass:klass]) {
        return symbol;
    }
    return nil;
}

@end
//
//  MOBridgeSupportLibrary.m
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation MOBridgeSupportLibrary {
    NSMutableArray *_dependencies;
    NSMutableDictionary *_symbols;
}

@synthesize name=_name;
@synthesize URL=_URL;

- (id)init {
    self = [super init];
    if (self) {
        _dependencies = [[NSMutableArray alloc] init];
        _symbols = [[NSMutableDictionary alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Dependencies

- (NSArray *)dependencies {
    return _dependencies;
}

- (void)setDependencies:(NSArray *)dependencies {
    [_dependencies setArray:dependencies];
}

- (void)addDependency:(NSString *)dependency {
    if (![_dependencies containsObject:dependency]) {
        [_dependencies addObject:dependency];
    }
}

- (void)removeDependency:(NSString *)dependency {
    if ([_dependencies containsObject:dependency]) {
        [_dependencies removeObject:dependency];
    }
}


#pragma mark -
#pragma mark Symbols

- (NSDictionary *)symbols {
    return _symbols;
}

- (void)setSymbols:(NSDictionary *)symbols {
    [_symbols setDictionary:symbols];
}

- (MOBridgeSupportSymbol *)symbolWithName:(NSString *)name {
    return [_symbols objectForKey:name];
}

- (void)setSymbol:(MOBridgeSupportSymbol *)symbol forName:(NSString *)name {
    [_symbols setObject:symbol forKey:name];
}

- (void)removeSymbolForName:(NSString *)name {
    [_symbols removeObjectForKey:name];
}

@end
//
//  MOBridgeSupportParser.m
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//






#define PARSER_DEBUG 0


@interface MOBridgeSupportParser () <NSXMLParserDelegate>

@end


@implementation MOBridgeSupportParser {
    NSXMLParser *_parser;
    MOBridgeSupportLibrary *_library;
    NSMutableArray *_symbolStack;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    _parser = nil;
    _library = nil;
    _symbolStack = nil;
}

- (MOBridgeSupportLibrary *)libraryWithBridgeSupportURL:(NSURL *)aURL error:(NSError **)outError {
    _parser = [[NSXMLParser alloc] initWithContentsOfURL:aURL];
    [_parser setDelegate:self];
    
    BOOL success = [_parser parse];
    if (!success) {
        _library = nil;
    }
    
    NSError *error = [_parser parserError];
    if (outError != NULL) {
        *outError = error;
    }
    
    _parser = nil;
    
    return _library;
}


#pragma mark -
#pragma mark XML Parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
#if PARSER_DEBUG
    NSLog(@"Parser didStartDocument");
#endif
    
    _library = [[MOBridgeSupportLibrary alloc] init];
    _symbolStack = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
#if PARSER_DEBUG
    NSLog(@"Parser didEndDocument");
#endif
    
    _symbolStack = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
#if PARSER_DEBUG
    NSLog(@"Parser didStartElement: %@, attributes=%@", elementName, attributeDict);
#endif
    
    if ([elementName isEqualToString:@"signatures"]) {
        // Signatures
        
    }
    else if ([elementName isEqualToString:@"depends_on"]) {
        // Dependency
        NSString *path = [attributeDict objectForKey:@"path"];
        [_library addDependency:path];
    }
    else if ([elementName isEqualToString:@"struct"]) {
        // Struct
        MOBridgeSupportStruct *symbol = [[MOBridgeSupportStruct alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        symbol.opaque = [[attributeDict objectForKey:@"opaque"] isEqualToString:@"true"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"cftype"]) {
        // CFType
        MOBridgeSupportCFType *symbol = [[MOBridgeSupportCFType alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        symbol.tollFreeBridgedClassName = [attributeDict objectForKey:@"tollfree"];
        symbol.getTypeIDFunctionName = [attributeDict objectForKey:@"gettypeid_func"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"opaque"]) {
        // Opaque
        MOBridgeSupportOpaque *symbol = [[MOBridgeSupportOpaque alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"constant"]) {
        // Constant
        MOBridgeSupportConstant *symbol = [[MOBridgeSupportConstant alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        symbol.hasMagicCookie = [[attributeDict objectForKey:@"magic_cookie"] isEqualToString:@"true"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"string_constant"]) {
        // String constant
        MOBridgeSupportStringConstant *symbol = [[MOBridgeSupportStringConstant alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.value = [attributeDict objectForKey:@"value"];
        symbol.hasNSString = [[attributeDict objectForKey:@"nsstring"] isEqualToString:@"true"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"enum"]) {
        // Enum
        MOBridgeSupportEnum *symbol = [[MOBridgeSupportEnum alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        if ([attributeDict objectForKey:@"value"]) {
            symbol.value = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"value"] integerValue]];
        }
        if ([attributeDict objectForKey:@"value64"]) {
            symbol.value64 = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"value64"] integerValue]];
        }
        symbol.ignored = [[attributeDict objectForKey:@"ignore"] isEqualToString:@"true"];
        symbol.suggestion = [attributeDict objectForKey:@"suggestion"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"function"]) {
        // Function
        MOBridgeSupportFunction *symbol = [[MOBridgeSupportFunction alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.variadic = [[attributeDict objectForKey:@"variadic"] isEqualToString:@"true"];
        if ([attributeDict objectForKey:@"sentinel"]) {
            symbol.sentinel = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"sentinel"] integerValue]];
        }
        symbol.inlineFunction = [[attributeDict objectForKey:@"inline"] isEqualToString:@"true"];
        [_library setSymbol:symbol forName:symbol.name];
        
        [_symbolStack addObject:symbol];
    }
    else if ([elementName isEqualToString:@"function_alias"]) {
        // Function alias
        MOBridgeSupportFunctionAlias *symbol = [[MOBridgeSupportFunctionAlias alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.original = [attributeDict objectForKey:@"original"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"class"]) {
        // Class
        MOBridgeSupportClass *symbol = [[MOBridgeSupportClass alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        [_library setSymbol:symbol forName:symbol.name];
        [_symbolStack addObject:symbol];
    }
    else if ([elementName isEqualToString:@"informal_protocol"]) {
        // Informal protocol
        MOBridgeSupportInformalProtocol *symbol = [[MOBridgeSupportInformalProtocol alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        [_library setSymbol:symbol forName:symbol.name];
        [_symbolStack addObject:symbol];
    }
    else if ([elementName isEqualToString:@"method"]) {
        // Method
        MOBridgeSupportMethod *symbol = [[MOBridgeSupportMethod alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        if ([attributeDict objectForKey:@"selector"]) {
            symbol.selector = NSSelectorFromString([attributeDict objectForKey:@"selector"]);
        }
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        symbol.classMethod = [[attributeDict objectForKey:@"class_method"] isEqualToString:@"true"];
        symbol.variadic = [[attributeDict objectForKey:@"variadic"] isEqualToString:@"true"];
        if ([attributeDict objectForKey:@"sentinel"]) {
            symbol.sentinel = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"sentinel"] integerValue]];
        }
        symbol.ignored = [[attributeDict objectForKey:@"ignore"] isEqualToString:@"true"];
        symbol.suggestion = [attributeDict objectForKey:@"suggestion"];
        
        MOBridgeSupportSymbol *currentSymbol = [_symbolStack lastObject];
        if ([currentSymbol isKindOfClass:[MOBridgeSupportClass class]]
            || [currentSymbol isKindOfClass:[MOBridgeSupportInformalProtocol class]]) {
            [(MOBridgeSupportClass *)currentSymbol addMethod:symbol];
        }
        
        [_symbolStack addObject:symbol];
    }
    else if ([elementName isEqualToString:@"arg"]) {
        // Argument
        MOBridgeSupportArgument *argument = [[MOBridgeSupportArgument alloc] init];
        argument.cArrayLengthInArg = [attributeDict objectForKey:@"c_array_length_in_arg"];
        argument.cArrayOfFixedLength = [[attributeDict objectForKey:@"c_array_of_fixed_length"] isEqualToString:@"true"];
        argument.cArrayDelimitedByNull = [[attributeDict objectForKey:@"c_array_delimited_by_null"] isEqualToString:@"true"];
        argument.cArrayOfVariableLength = [[attributeDict objectForKey:@"c_array_of_variable_length"] isEqualToString:@"true"];
        argument.functionPointer = [[attributeDict objectForKey:@"function_pointer"] isEqualToString:@"true"];
        argument.signature = [attributeDict objectForKey:@"sel_of_type"];
        argument.signature64 = [attributeDict objectForKey:@"sel_of_type64"];
        argument.cArrayLengthInReturnValue = [[attributeDict objectForKey:@"c_array_length_in_retval"] isEqualToString:@"true"];
        argument.acceptsNull = ![[attributeDict objectForKey:@"null_accepted"] isEqualToString:@"false"];
        argument.acceptsPrintfFormat = [[attributeDict objectForKey:@"printf_format"] isEqualToString:@"true"];
        argument.alreadyRetained = [[attributeDict objectForKey:@"already_retained"] isEqualToString:@"true"];
        argument.type = [attributeDict objectForKey:@"type"];
        argument.type64 = [attributeDict objectForKey:@"type64"];
        argument.index = [[attributeDict objectForKey:@"index"] integerValue];
        
        id currentSymbol = [_symbolStack lastObject];
        if ([currentSymbol isKindOfClass:[MOBridgeSupportMethod class]]) {
            [(MOBridgeSupportMethod *)currentSymbol addArgument:argument];
        }
        else if ([currentSymbol isKindOfClass:[MOBridgeSupportFunction class]]) {
            [(MOBridgeSupportFunction *)currentSymbol addArgument:argument];
        }
        else if ([currentSymbol isKindOfClass:[MOBridgeSupportArgument class]]) {
            [(MOBridgeSupportArgument *)currentSymbol addArgument:argument];
        }
        
        [_symbolStack addObject:argument];
    }
    else if ([elementName isEqualToString:@"retval"]) {
        // Return value
        MOBridgeSupportArgument *argument = [[MOBridgeSupportArgument alloc] init];
        argument.cArrayLengthInArg = [attributeDict objectForKey:@"c_array_length_in_arg"];
        argument.cArrayOfFixedLength = [[attributeDict objectForKey:@"c_array_of_fixed_length"] isEqualToString:@"true"];
        argument.cArrayDelimitedByNull = [[attributeDict objectForKey:@"c_array_delimited_by_null"] isEqualToString:@"true"];
        argument.cArrayOfVariableLength = [[attributeDict objectForKey:@"c_array_of_variable_length"] isEqualToString:@"true"];
        argument.functionPointer = [[attributeDict objectForKey:@"function_pointer"] isEqualToString:@"true"];
        argument.signature = [attributeDict objectForKey:@"sel_of_type"];
        argument.signature64 = [attributeDict objectForKey:@"sel_of_type64"];
        argument.cArrayLengthInReturnValue = [[attributeDict objectForKey:@"c_array_length_in_retval"] isEqualToString:@"true"];
        argument.acceptsNull = ![[attributeDict objectForKey:@"null_accepted"] isEqualToString:@"false"];
        argument.acceptsPrintfFormat = [[attributeDict objectForKey:@"printf_format"] isEqualToString:@"true"];
        argument.alreadyRetained = [[attributeDict objectForKey:@"already_retained"] isEqualToString:@"true"];
        argument.type = [attributeDict objectForKey:@"type"];
        argument.type64 = [attributeDict objectForKey:@"type64"];
        argument.index = [[attributeDict objectForKey:@"index"] integerValue];
        
        id currentSymbol = [_symbolStack lastObject];
        if ([currentSymbol isKindOfClass:[MOBridgeSupportMethod class]]) {
            [(MOBridgeSupportMethod *)currentSymbol setReturnValue:argument];
        }
        else if ([currentSymbol isKindOfClass:[MOBridgeSupportFunction class]]) {
            [(MOBridgeSupportFunction *)currentSymbol setReturnValue:argument];
        }
        else if ([currentSymbol isKindOfClass:[MOBridgeSupportArgument class]]) {
            [(MOBridgeSupportArgument *)currentSymbol setReturnValue:argument];
        }
        
        [_symbolStack addObject:argument];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
#if PARSER_DEBUG
    NSLog(@"Parser didEndElement: %@", elementName);
#endif
    
    MOBridgeSupportSymbol *currentSymbol = [_symbolStack lastObject];
    if ([elementName isEqualToString:@"class"]) {
        // Class
        if ([currentSymbol isKindOfClass:[MOBridgeSupportClass class]]) {
            [_symbolStack removeLastObject];
        }
    }
    else if ([elementName isEqualToString:@"informal_protocol"]) {
        // Informal protocol
        if ([currentSymbol isKindOfClass:[MOBridgeSupportInformalProtocol class]]) {
            [_symbolStack removeLastObject];
        }
    }
    else if ([elementName isEqualToString:@"method"]) {
        // Method
        if ([currentSymbol isKindOfClass:[MOBridgeSupportMethod class]]) {
            [_symbolStack removeLastObject];
        }
    }
    else if ([elementName isEqualToString:@"function"]) {
        // Function
        if ([currentSymbol isKindOfClass:[MOBridgeSupportFunction class]]) {
            [_symbolStack removeLastObject];
        }
    }
    else if ([elementName isEqualToString:@"arg"]
             || [elementName isEqualToString:@"retval"]) {
        // Argument
        if ([currentSymbol isKindOfClass:[MOBridgeSupportArgument class]]) {
            [_symbolStack removeLastObject];
        }
    }
}

@end
//
//  MOBridgeSupportSymbol.m
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation MOBridgeSupportSymbol

@synthesize name=_name;

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : name=%@>", [self class], self, self.name];
}

@end


@implementation MOBridgeSupportStruct

@synthesize type=_type;
@synthesize type64=_type64;
@synthesize opaque=_opaque;

@end


@implementation MOBridgeSupportCFType

@synthesize type=_type;
@synthesize type64=_type64;

@synthesize tollFreeBridgedClassName=_tollFreeBridgedClassName;
@synthesize getTypeIDFunctionName=_getTypeIDFunctionName;

@end


@implementation MOBridgeSupportOpaque

@synthesize type=_type;
@synthesize type64=_type64;

@synthesize hasMagicCookie=_hasMagicCookie;

@end


@implementation MOBridgeSupportConstant

@synthesize type=_type;
@synthesize type64=_type64;

@synthesize hasMagicCookie=_hasMagicCookie;

@end


@implementation MOBridgeSupportStringConstant

@synthesize value=_value;
@synthesize hasNSString=_hasNSString;

@end


@implementation MOBridgeSupportEnum

@synthesize value=_value;
@synthesize value64=_value64;

@synthesize ignored=_ignored;
@synthesize suggestion=_suggestion;

@end


@implementation MOBridgeSupportFunction {
    NSMutableArray *_arguments;
}

@synthesize variadic=_variadic;
@synthesize sentinel=_sentinel;
@synthesize inlineFunction=_inlineFunction;

@synthesize returnValue=_returnValue;

- (id)init {
    self = [super init];
    if (self) {
        _arguments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)description {
    NSString *returnEncoding = nil;
    if (self.returnValue != nil) {
#if __LP64__
        returnEncoding = (self.returnValue.type64 ? self.returnValue.type64 : self.returnValue.type);
#else
        returnEncoding = self.returnValue.type;
#endif
        if (returnEncoding == nil) {
            returnEncoding = @"?";
        }
    }
    else {
        returnEncoding = @"v";
    }
    
    NSMutableArray *argumentEncodings = [NSMutableArray arrayWithCapacity:[[self arguments] count]];
    for (MOBridgeSupportArgument *arg in self.arguments) {
#if __LP64__
        NSString *encoding = (arg.type64 ? arg.type64 : arg.type);
#else
        NSString *encoding = arg.type;
#endif
        [argumentEncodings addObject:(encoding ? encoding : @"?")];
    }
    
    return [NSString stringWithFormat:@"<%@: %p : name=%@, variadic=%@, argTypes=%@, returnType=%@>", [self class], self, self.name, (self.variadic ? @"YES" : @"NO"), [argumentEncodings componentsJoinedByString:@","], returnEncoding];
}


#pragma mark -
#pragma mark Arguments

- (NSArray *)arguments {
    return [_arguments copy];
}

- (void)setArguments:(NSArray *)arguments {
    [_arguments setArray:arguments];
}

- (void)addArgument:(MOBridgeSupportArgument *)argument {
    if (![_arguments containsObject:argument]) {
        [_arguments addObject:argument];
    }
}

- (void)removeArgument:(MOBridgeSupportArgument *)argument {
    if ([_arguments containsObject:argument]) {
        [_arguments removeObject:argument];
    }
}

@end


@implementation MOBridgeSupportFunctionAlias

@synthesize original=_original;

@end


@implementation MOBridgeSupportClass {
    NSMutableArray *_methods;
}

- (id)init {
    self = [super init];
    if (self) {
        _methods = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Methods

- (NSArray *)methods {
    return _methods;
}

- (void)setMethods:(NSArray *)methods {
    [_methods setArray:methods];
}

- (void)addMethod:(MOBridgeSupportMethod *)method {
    if (![_methods containsObject:method]) {
        [_methods addObject:method];
    }
}

- (void)removeMethod:(MOBridgeSupportMethod *)method {
    if ([_methods containsObject:method]) {
        [_methods removeObject:method];
    }
}

- (MOBridgeSupportMethod *)methodWithSelector:(SEL)selector {
    NSUInteger index = [_methods indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ([obj selector] == selector);
    }];
    if (index != NSNotFound) {
        return [_methods objectAtIndex:index];
    }
    return nil;
}

@end


@implementation MOBridgeSupportInformalProtocol {
    NSMutableArray *_methods;
}

- (id)init {
    self = [super init];
    if (self) {
        _methods = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Methods

- (NSArray *)methods {
    return _methods;
}

- (void)setMethods:(NSArray *)methods {
    [_methods setArray:methods];
}

- (void)addMethod:(MOBridgeSupportMethod *)method {
    if (![_methods containsObject:method]) {
        [_methods addObject:method];
    }
}

- (void)removeMethod:(MOBridgeSupportMethod *)method {
    if ([_methods containsObject:method]) {
        [_methods removeObject:method];
    }
}

- (MOBridgeSupportMethod *)methodWithSelector:(SEL)selector {
    NSUInteger index = [_methods indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ([obj selector] == selector);
    }];
    if (index != NSNotFound) {
        return [_methods objectAtIndex:index];
    }
    return nil;
}

@end


@implementation MOBridgeSupportMethod {
    NSMutableArray *_arguments;
}

@synthesize selector=_selector;

@synthesize type=_type;
@synthesize type64=_type64;

@synthesize returnValue=_returnValue;

@synthesize classMethod=_classMethod;

@synthesize variadic=_variadic;
@synthesize sentinel=_sentinel;

@synthesize ignored=_ignored;
@synthesize suggestion=_suggestion;

- (id)init {
    self = [super init];
    if (self) {
        _arguments = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark -
#pragma mark Arguments

- (NSArray *)arguments {
    return [_arguments copy];
}

- (void)setArguments:(NSArray *)arguments {
    [_arguments setArray:arguments];
}

- (void)addArgument:(MOBridgeSupportArgument *)argument {
    if (![_arguments containsObject:argument]) {
        [_arguments addObject:argument];
    }
}

- (void)removeArgument:(MOBridgeSupportArgument *)argument {
    if ([_arguments containsObject:argument]) {
        [_arguments removeObject:argument];
    }
}

@end


@implementation MOBridgeSupportArgument {
    NSMutableArray *_arguments;
}

@synthesize type=_type;
@synthesize type64=_type64;

@synthesize typeModifier=_typeModifier;

@synthesize signature=_signature;
@synthesize signature64=_signature64;

@synthesize cArrayLengthInArg=_cArrayLengthInArg;
@synthesize cArrayOfFixedLength=_cArrayOfFixedLength;
@synthesize cArrayDelimitedByNull=_cArrayDelimitedByNull;
@synthesize cArrayOfVariableLength=_cArrayOfVariableLength;
@synthesize cArrayLengthInReturnValue=_cArrayLengthInReturnValue;

@synthesize index=_index;

@synthesize acceptsNull=_acceptsNull;
@synthesize acceptsPrintfFormat=_acceptsPrintfFormat;

@synthesize alreadyRetained=_alreadyRetained;
@synthesize functionPointer=_functionPointer;

@synthesize returnValue=_returnValue;

- (id)init {
    self = [super init];
    if (self) {
        _arguments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)description {
    if (self.typeModifier != nil) {
        return [NSString stringWithFormat:@"<%@: %p : type=%@, typeModifier=%@>", [self class], self, (self.type64 ? self.type64 : self.type), self.typeModifier];
    }
    else {
        return [NSString stringWithFormat:@"<%@: %p : type=%@>", [self class], self, (self.type64 ? self.type64 : self.type)];
    }
}


#pragma mark -
#pragma mark Arguments

- (NSArray *)arguments {
    return [_arguments copy];
}

- (void)setArguments:(NSArray *)arguments {
    [_arguments setArray:arguments];
}

- (void)addArgument:(MOBridgeSupportArgument *)argument {
    if (![_arguments containsObject:argument]) {
        [_arguments addObject:argument];
    }
}

- (void)removeArgument:(MOBridgeSupportArgument *)argument {
    if ([_arguments containsObject:argument]) {
        [_arguments removeObject:argument];
    }
}

@end


//
//  NSArray+MochaAdditions.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation NSArray (MochaAdditions)

- (id)mo_objectForIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}

@end


@implementation NSMutableArray (MochaAdditions)

- (void)mo_setObject:(id)obj forIndexedSubscript:(NSUInteger)idx {
    if ([self count] > idx && obj != nil) {
        [self replaceObjectAtIndex:idx withObject:obj];
    }
    else if ([self count] == idx && obj != nil) {
        [self addObject:obj];
    }
    else if (obj == nil) {
        [self removeObjectAtIndex:idx];
    }
}

@end
//
//  NSDictionary+MochaAdditions.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation NSDictionary (MochaAdditions)

- (id)mo_objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

@end


@implementation NSMutableDictionary (MochaAdditions)

- (void)mo_setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    if (obj != nil) {
        [self setObject:obj forKey:key];
    }
    else {
        [self removeObjectForKey:key];
    }
}

@end
//
//  NSObject+MochaAdditions.m
//  Mocha
//
//  Created by Logan Collins on 5/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//





#import <objc/runtime.h>


@implementation NSObject (MochaAdditions)

+ (void)mo_swizzleAdditions {
    Class metaClass = object_getClass(self);
    
    SEL classDescriptionSelector = @selector(mocha);
    if (!class_respondsToSelector(self, classDescriptionSelector)) {
        IMP imp = class_getMethodImplementation(metaClass, @selector(mo_mocha));
        class_addMethod(metaClass, classDescriptionSelector, imp, "@@:");
    }
}

+ (MOClassDescription *)mo_mocha {
    return [MOClassDescription descriptionForClass:self];
}

@end
//
//  NSOrderedSet+MochaAdditions.m
//  Mocha
//
//  Created by Logan Collins on 5/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation NSOrderedSet (MochaAdditions)

- (id)mo_objectForIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}

@end


@implementation NSMutableOrderedSet (MochaAdditions)

- (void)mo_setObject:(id)obj forIndexedSubscript:(NSUInteger)idx {
    if ([self count] > idx && obj != nil) {
        [self replaceObjectAtIndex:idx withObject:obj];
    }
    else if ([self count] == idx && obj != nil) {
        [self addObject:obj];
    }
    else if (obj == nil) {
        [self removeObjectAtIndex:idx];
    }
}

@end
//
//  Mocha.m
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//



//
//  MochaRuntime.m
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

























#import <objc/runtime.h>
#import <dlfcn.h>


// Class types
static JSClassRef MochaClass = NULL;
static JSClassRef MOObjectClass = NULL;
static JSClassRef MOBoxedObjectClass = NULL;
static JSClassRef MOConstructorClass = NULL;
static JSClassRef MOFunctionClass = NULL;


// Global object
static JSValueRef   Mocha_getProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef *exception);

// Private Cocoa object callbacks
static void         MOObject_initialize(JSContextRef ctx, JSObjectRef object);
static void         MOObject_finalize(JSObjectRef object);

static bool         MOBoxedObject_hasProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName);
static JSValueRef   MOBoxedObject_getProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef *exception);
static bool         MOBoxedObject_setProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef value, JSValueRef *exception);
static bool         MOBoxedObject_deleteProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyName, JSValueRef *exception);
static void         MOBoxedObject_getPropertyNames(JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames);
static JSValueRef   MOBoxedObject_convertToType(JSContextRef ctx, JSObjectRef object, JSType type, JSValueRef *exception);
static bool         MOBoxedObject_hasInstance(JSContextRef ctx, JSObjectRef constructor, JSValueRef possibleInstance, JSValueRef *exception);

static JSObjectRef  MOConstructor_callAsConstructor(JSContextRef ctx, JSObjectRef object, size_t argumentsCount, const JSValueRef arguments[], JSValueRef *exception);

static JSValueRef   MOFunction_callAsFunction(JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception);

static JSValueRef MOStringPrototypeFunction(JSContextRef ctx, NSString *name);

NSString * const MORuntimeException = @"MORuntimeException";
NSString * const MOJavaScriptException = @"MOJavaScriptException";


#pragma mark -
#pragma mark Runtime


@implementation Mocha {
    JSGlobalContextRef _ctx;
    BOOL _ownsContext;
    NSMutableDictionary *_exportedObjects;
    MOMapTable *_objectsToBoxes;
    NSMutableArray *_frameworkSearchPaths;
}

@synthesize delegate=_delegate;

+ (void)initialize {
    if (self == [Mocha class]) {
        // Mocha global object
        JSClassDefinition MochaClassDefinition      = kJSClassDefinitionEmpty;
        MochaClassDefinition.className              = "Mocha";
        MochaClassDefinition.getProperty            = Mocha_getProperty;
        MochaClass                                  = JSClassCreate(&MochaClassDefinition);
        
        // Mocha object
        JSClassDefinition MOObjectDefinition        = kJSClassDefinitionEmpty;
        MOObjectDefinition.className                = "MOObject";
        MOObjectDefinition.initialize               = MOObject_initialize;
        MOObjectDefinition.finalize                 = MOObject_finalize;
        MOObjectClass                               = JSClassCreate(&MOObjectDefinition);
        
        // Boxed Cocoa object
        JSClassDefinition MOBoxedObjectDefinition  = kJSClassDefinitionEmpty;
        MOBoxedObjectDefinition.className          = "MOBoxedObject";
        MOBoxedObjectDefinition.parentClass        = MOObjectClass;
        MOBoxedObjectDefinition.hasProperty        = MOBoxedObject_hasProperty;
        MOBoxedObjectDefinition.getProperty        = MOBoxedObject_getProperty;
        MOBoxedObjectDefinition.setProperty        = MOBoxedObject_setProperty;
        MOBoxedObjectDefinition.deleteProperty     = MOBoxedObject_deleteProperty;
        MOBoxedObjectDefinition.getPropertyNames   = MOBoxedObject_getPropertyNames;
        MOBoxedObjectDefinition.hasInstance        = MOBoxedObject_hasInstance;
        MOBoxedObjectDefinition.convertToType      = MOBoxedObject_convertToType;
        MOBoxedObjectClass                         = JSClassCreate(&MOBoxedObjectDefinition);
        
        // Constructor object
        JSClassDefinition MOConstructorDefinition  = kJSClassDefinitionEmpty;
        MOConstructorDefinition.className          = "MOConstructor";
        MOConstructorDefinition.parentClass        = MOObjectClass;
        MOConstructorDefinition.callAsConstructor  = MOConstructor_callAsConstructor;
        MOConstructorDefinition.convertToType      = MOBoxedObject_convertToType;
        MOConstructorClass                         = JSClassCreate(&MOConstructorDefinition);
        
        // Function object
        JSClassDefinition MOFunctionDefinition     = kJSClassDefinitionEmpty;
        MOFunctionDefinition.className             = "MOFunction";
        MOFunctionDefinition.parentClass           = MOObjectClass;
        MOFunctionDefinition.callAsFunction        = MOFunction_callAsFunction;
        MOFunctionDefinition.convertToType         = MOBoxedObject_convertToType;
        MOFunctionClass                            = JSClassCreate(&MOFunctionDefinition);
        
        
        // Swizzle indexed subscripting support for NSArray
        SEL indexedSubscriptSelector = @selector(objectForIndexedSubscript:);
        if (![NSArray instancesRespondToSelector:indexedSubscriptSelector]) {
            IMP imp = class_getMethodImplementation([NSArray class], @selector(mo_objectForIndexedSubscript:));
            class_addMethod([NSArray class], @selector(objectForIndexedSubscript:), imp, "@@:l");
            
            imp = class_getMethodImplementation([NSMutableArray class], @selector(mo_setObject:forIndexedSubscript:));
            class_addMethod([NSMutableArray class], @selector(setObject:forIndexedSubscript:), imp, "@@:@l");
        }
        
        // Swizzle indexed subscripting support for NSOrderedSet
        if (![NSOrderedSet instancesRespondToSelector:indexedSubscriptSelector]) {
            IMP imp = class_getMethodImplementation([NSOrderedSet class], @selector(mo_objectForIndexedSubscript:));
            class_addMethod([NSOrderedSet class], @selector(objectForIndexedSubscript:), imp, "@@:l");
            
            imp = class_getMethodImplementation([NSMutableOrderedSet class], @selector(mo_setObject:forIndexedSubscript:));
            class_addMethod([NSMutableOrderedSet class], @selector(setObject:forIndexedSubscript:), imp, "@@:@l");
        }
        
        // Swizzle keyed subscripting support for NSDictionary
        SEL keyedSubscriptSelector = @selector(objectForKeyedSubscript:);
        if (![NSDictionary instancesRespondToSelector:keyedSubscriptSelector]) {
            IMP imp = class_getMethodImplementation([NSDictionary class], @selector(mo_objectForKeyedSubscript:));
            class_addMethod([NSDictionary class], @selector(objectForKeyedSubscript:), imp, "@@:@");
            
            imp = class_getMethodImplementation([NSMutableDictionary class], @selector(mo_setObject:forKeyedSubscript:));
            class_addMethod([NSMutableDictionary class], @selector(setObject:forKeyedSubscript:), imp, "@@:@@");
        }
        
        // Swizzle in NSObject additions
        [NSObject mo_swizzleAdditions];
    }
}

+ (Mocha *)sharedRuntime {
    static Mocha *sharedRuntime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRuntime = [[self alloc] init];
    });
    return sharedRuntime;
}

+ (Mocha *)runtimeWithContext:(JSContextRef)ctx {
    JSStringRef jsName = JSStringCreateWithUTF8CString("__mocha__");
    JSValueRef jsValue = JSObjectGetProperty(ctx, JSContextGetGlobalObject(ctx), jsName, NULL);
    JSStringRelease(jsName);
    return [self objectForJSValue:jsValue inContext:ctx];
}

- (id)init {
    return [self initWithGlobalContext:NULL];
}

- (id)initWithGlobalContext:(JSGlobalContextRef)ctx {
    if (ctx == NULL) {
        ctx = JSGlobalContextCreate(MochaClass);
        _ownsContext = YES;
    }
    else {
        JSGlobalContextRetain(ctx);
        _ownsContext = NO;
        
        // Create the global "Mocha" object
        JSObjectRef o = JSObjectMake(ctx, MochaClass, NULL);
        JSStringRef jsName = JSStringCreateWithUTF8CString("Mocha");
        JSObjectSetProperty(ctx, JSContextGetGlobalObject(ctx), jsName, o, kJSPropertyAttributeDontDelete, NULL);
        JSStringRelease(jsName);
    }
    
    self = [super init];
    if (self) {
        _ctx = ctx;
        _exportedObjects = [[NSMutableDictionary alloc] init];
        _objectsToBoxes = [MOMapTable mapTableWithStrongToStrongObjects];
        _frameworkSearchPaths = [[NSMutableArray alloc] initWithObjects:
                                 @"/System/Library/Frameworks",
                                 @"/Library/Frameworks",
                                 nil];
        
        // Add the runtime as a property of the context
        [self setObject:self withName:@"__mocha__" attributes:(kJSPropertyAttributeReadOnly|kJSPropertyAttributeDontEnum|kJSPropertyAttributeDontDelete)];
        
        // Load builtins
        [self installBuiltins];
        
        // Load base frameworks
#if !TARGET_OS_IPHONE
        [self loadFrameworkWithName:@"Foundation"];
        if (![self loadFrameworkWithName:@"CoreGraphics"]) {
            [self loadFrameworkWithName:@"CoreGraphics" inDirectory:@"/System/Library/Frameworks/ApplicationServices.framework/Frameworks"];
        }
#endif
    }
    return self;
}

- (void)dealloc {
    [self cleanUp];
    
    JSGlobalContextRelease(_ctx);
}

- (JSGlobalContextRef)context {
    return _ctx;
}


#pragma mark -
#pragma mark Key-Value Coding

- (id)valueForUndefinedKey:(NSString *)key {
    return [_exportedObjects objectForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [_exportedObjects setObject:value forKey:key];
}

- (void)setNilValueForKey:(NSString *)key {
    [_exportedObjects removeObjectForKey:key];
}


#pragma mark -
#pragma mark Object Conversion

+ (JSValueRef)JSValueForObject:(id)object inContext:(JSContextRef)ctx {
    return [[Mocha runtimeWithContext:ctx] JSValueForObject:object];
}

+ (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx {
    return [self objectForJSValue:value inContext:ctx unboxObjects:YES];
}

+ (id)objectForJSValue:(JSValueRef)value inContext:(JSContextRef)ctx unboxObjects:(BOOL)unboxObjects {
    if (value == NULL || JSValueIsUndefined(ctx, value)) {
        return [MOUndefined undefined];
    }
    
    if (JSValueIsNull(ctx, value)) {
        return nil;
    }
    
    if (JSValueIsString(ctx, value)) {
        JSStringRef resultStringJS = JSValueToStringCopy(ctx, value, NULL);
        NSString *resultString = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, resultStringJS));
        JSStringRelease(resultStringJS);
        return resultString;
    }
    
    if (JSValueIsNumber(ctx, value)) {
        double v = JSValueToNumber(ctx, value, NULL);
        return [NSNumber numberWithDouble:v];
    }
    
    if (JSValueIsBoolean(ctx, value)) {
        bool v = JSValueToBoolean(ctx, value);
        return [NSNumber numberWithBool:v];
    }
    
    if (!JSValueIsObject(ctx, value)) {
        return nil;
    }
    
    JSObjectRef jsObject = JSValueToObject(ctx, value, NULL);
    id private = (__bridge id)JSObjectGetPrivate(jsObject);
    
    if (private != nil) {
        if ([private isKindOfClass:[MOBox class]]) {
            if (unboxObjects == YES) {
                // Boxed ObjC object
                id object = [private representedObject];
                if ([object isKindOfClass:[MOClosure class]]) {
                    // Auto-unbox closures
                    return [object block];
                }
                else {
                    return object;
                }
            }
            else {
                return private;
            }
        }
        else {
            return private;
        }
    }
    else {
        BOOL isFunction = JSObjectIsFunction(ctx, jsObject);
        if (isFunction) {
            // Function
            return [MOJavaScriptObject objectWithJSObject:jsObject context:ctx];
        }
        
        // Normal JS object
        JSStringRef scriptJS = JSStringCreateWithUTF8CString("return arguments[0].constructor == Array.prototype.constructor");
        JSObjectRef fn = JSObjectMakeFunction(ctx, NULL, 0, NULL, scriptJS, NULL, 1, NULL);
        JSValueRef result = JSObjectCallAsFunction(ctx, fn, NULL, 1, (JSValueRef *)&jsObject, NULL);
        JSStringRelease(scriptJS);
        
        BOOL isArray = JSValueToBoolean(ctx, result);
        if (isArray) {
            // Array
            return [self arrayForJSArray:jsObject inContext:ctx];
        }
        else {
            // Object
            return [self dictionaryForJSHash:jsObject inContext:ctx];
        }
    }
    
    return nil;
}

+ (NSArray *)arrayForJSArray:(JSObjectRef)arrayValue inContext:(JSContextRef)ctx {
    JSValueRef exception = NULL;
    JSStringRef lengthJS = JSStringCreateWithUTF8CString("length");
    NSUInteger length = JSValueToNumber(ctx, JSObjectGetProperty(ctx, arrayValue, lengthJS, NULL), &exception);
    JSStringRelease(lengthJS);
    
    if (exception != NULL) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:length];

    for (NSUInteger i=0; i<length; i++) {
        id obj = nil;
        JSValueRef jsValue = JSObjectGetPropertyAtIndex(ctx, arrayValue, (unsigned int)i, &exception);
        if (exception != NULL) {
            return nil;
        }
        
        obj = [self objectForJSValue:jsValue inContext:ctx unboxObjects:YES];
        if (obj == nil) {
            obj = [NSNull null];
        }
        
        [array addObject:obj];
    }
    
    return [array copy];
}

+ (NSDictionary *)dictionaryForJSHash:(JSObjectRef)hashValue inContext:(JSContextRef)ctx {
    JSPropertyNameArrayRef names = JSObjectCopyPropertyNames(ctx, hashValue);
    NSUInteger length = JSPropertyNameArrayGetCount(names);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:length];
    JSValueRef exception = NULL;
    
    for (NSUInteger i=0; i<length; i++) {
        id obj = nil;
        JSStringRef name = JSPropertyNameArrayGetNameAtIndex(names, i);
        JSValueRef jsValue = JSObjectGetProperty(ctx, hashValue, name, &exception);
        
        if (exception != NULL) {
            return NO;
        }
        
        obj = [self objectForJSValue:jsValue inContext:ctx unboxObjects:YES];
        if (obj == nil) {
            obj = [NSNull null];
        }
        
        NSString *key = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, name));
        [dictionary setObject:obj forKey:key];
    }
    
    JSPropertyNameArrayRelease(names);
    
    return [dictionary copy];
}

- (JSValueRef)JSValueForObject:(id)object {
    JSValueRef value = NULL;
    
    if ([object isKindOfClass:[MOBox class]]) {
        value = [object JSObject];
    }
    else if ([object isKindOfClass:[MOJavaScriptObject class]]) {
        return [object JSObject];
    }
    /*else if ([object isKindOfClass:[NSString class]]) {
        JSStringRef string = JSStringCreateWithCFString((CFStringRef)object);
        value = JSValueMakeString(_ctx, string);
        JSStringRelease(string);
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        double doubleValue = [object doubleValue];
        value = JSValueMakeNumber(_ctx, doubleValue);
    }*/
    else if ([object isKindOfClass:NSClassFromString(@"NSBlock")]) {
        // Auto-box blocks inside of a closure object
        MOClosure *closure = [MOClosure closureWithBlock:object];
        value = [self boxedJSObjectForObject:closure];
    }
    else if (object == nil/* || [object isKindOfClass:[NSNull class]]*/) {
        value = JSValueMakeNull(_ctx);
    }
    else if (object == [MOUndefined undefined]) {
        value = JSValueMakeUndefined(_ctx);
    }
    
    if (value == NULL) {
        value = [self boxedJSObjectForObject:object];
    }
    
    return value;
}

- (id)objectForJSValue:(JSValueRef)value {
    return [self objectForJSValue:value unboxObjects:YES];
}

- (id)objectForJSValue:(JSValueRef)value unboxObjects:(BOOL)unboxObjects {
    return [Mocha objectForJSValue:value inContext:_ctx unboxObjects:unboxObjects];
}

- (JSObjectRef)boxedJSObjectForObject:(id)object {
    if (object == nil) {
        return NULL;
    }
    
    MOBox *box = [_objectsToBoxes objectForKey:object];
    if (box != nil) {
        return [box JSObject];
    }
    
    box = [[MOBox alloc] init];
    box.runtime = self;
    box.representedObject = object;
    
    JSObjectRef jsObject = NULL;
    
    if ([object isKindOfClass:[MOMethod class]]
        || [object isKindOfClass:[MOClosure class]]
        || [object isKindOfClass:[MOBridgeSupportFunction class]]) {
        jsObject = JSObjectMake(_ctx, MOFunctionClass, (__bridge void *)(box));
    }
    else {
        jsObject = JSObjectMake(_ctx, MOBoxedObjectClass, (__bridge void *)(box));
    }
    
    box.JSObject = jsObject;
    
    [_objectsToBoxes setObject:box forKey:object];
    
    return jsObject;
}

- (id)unboxedObjectForJSObject:(JSObjectRef)jsObject {
    id private = (__bridge id)(JSObjectGetPrivate(jsObject));
    if ([private isKindOfClass:[MOBox class]]) {
        return [private representedObject];
    }
    return nil;
}

- (void)removeBoxAssociationForObject:(id)object {
    if (object != nil) {
        [_objectsToBoxes removeObjectForKey:object];
    }
}


#pragma mark -
#pragma mark Object Storage

- (id)objectWithName:(NSString *)name {
    JSValueRef exception = NULL;
    
    JSStringRef jsName = JSStringCreateWithUTF8CString([name UTF8String]);
    JSValueRef jsValue = JSObjectGetProperty(_ctx, JSContextGetGlobalObject(_ctx), jsName, &exception);
    JSStringRelease(jsName);
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return [self objectForJSValue:jsValue];
}

- (JSValueRef)setObject:(id)object withName:(NSString *)name {
    return [self setObject:object withName:name attributes:(kJSPropertyAttributeNone)];
}

- (JSValueRef)setObject:(id)object withName:(NSString *)name attributes:(JSPropertyAttributes)attributes {
    JSValueRef jsValue = [self JSValueForObject:object];
    
    // Set
    JSValueRef exception = NULL;
    JSStringRef jsName = JSStringCreateWithUTF8CString([name UTF8String]);
    JSObjectSetProperty(_ctx, JSContextGetGlobalObject(_ctx), jsName, jsValue, attributes, &exception);
    JSStringRelease(jsName);
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return jsValue;
}

- (BOOL)removeObjectWithName:(NSString *)name {
    JSValueRef exception = NULL;
    
    // Delete
    JSStringRef jsName = JSStringCreateWithUTF8CString([name UTF8String]);
    JSObjectDeleteProperty(_ctx, JSContextGetGlobalObject(_ctx), jsName, &exception);
    JSStringRelease(jsName);
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NO;
    }
    
    return YES;
}


#pragma mark -
#pragma mark Evaluation

- (id)evalString:(NSString *)string {
    JSValueRef jsValue = [self evalJSString:string];
    return [self objectForJSValue:jsValue];
}

- (JSValueRef)evalJSString:(NSString *)string {
    return [self evalJSString:string scriptPath:nil];
}

- (JSValueRef)evalJSString:(NSString *)string scriptPath:(NSString *)scriptPath {
    if (string == nil) {
        return NULL;
    }
    
    JSStringRef jsString = JSStringCreateWithCFString((__bridge CFStringRef)string);
    JSStringRef jsScriptPath = (scriptPath != nil ? JSStringCreateWithUTF8CString([scriptPath UTF8String]) : NULL);
    JSValueRef exception = NULL;
    
    JSValueRef result = JSEvaluateScript(_ctx, jsString, NULL, jsScriptPath, 1, &exception);
    
    if (jsString != NULL) {
        JSStringRelease(jsString);
    }
    if (jsScriptPath != NULL) {
        JSStringRelease(jsScriptPath);
    }
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return result;
}


#pragma mark -
#pragma mark Functions

- (id)callFunctionWithName:(NSString *)functionName {
    return [self callFunctionWithName:functionName withArguments:nil];
}

- (id)callFunctionWithName:(NSString *)functionName withArguments:(id)firstArg, ... {
    NSMutableArray *arguments = [NSMutableArray array];
    
    va_list args;
    va_start(args, firstArg);
    for (id arg = firstArg; arg != nil; arg = va_arg(args, id)) {
        [arguments addObject:arg];
    }
    va_end(args);
    
    return [self callFunctionWithName:functionName withArgumentsInArray:arguments];
}

- (id)callFunctionWithName:(NSString *)functionName withArgumentsInArray:(NSArray *)arguments {
    JSValueRef value = [self callJSFunctionWithName:functionName withArgumentsInArray:arguments];
    return [self objectForJSValue:value];
}

- (JSObjectRef)JSFunctionWithName:(NSString *)functionName {
    JSValueRef exception = NULL;
    
    // Get function as property of global object
    JSStringRef jsFunctionName = JSStringCreateWithUTF8CString([functionName UTF8String]);
    JSValueRef jsFunctionValue = JSObjectGetProperty(_ctx, JSContextGetGlobalObject(_ctx), jsFunctionName, &exception);
    JSStringRelease(jsFunctionName);
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return JSValueToObject(_ctx, jsFunctionValue, NULL);
}

- (JSValueRef)callJSFunctionWithName:(NSString *)functionName withArgumentsInArray:(NSArray *)arguments {
    JSObjectRef jsFunction = [self JSFunctionWithName:functionName];
    if (jsFunction == NULL) {
        return NULL;
    }
    return [self callJSFunction:jsFunction withArgumentsInArray:arguments];
}

- (JSValueRef)callJSFunction:(JSObjectRef)jsFunction withArgumentsInArray:(NSArray *)arguments {
    JSValueRef *jsArguments = NULL;
    NSUInteger argumentsCount = [arguments count];
    if (argumentsCount > 0) {
        jsArguments = malloc(sizeof(JSValueRef) * argumentsCount);
        for (NSUInteger i=0; i<argumentsCount; i++) {
            id argument = [arguments objectAtIndex:i];
            JSValueRef value = [self JSValueForObject:argument];
            jsArguments[i] = value;
        }
    }
    
    JSValueRef exception = NULL;
    JSValueRef returnValue = JSObjectCallAsFunction(_ctx, jsFunction, NULL, argumentsCount, jsArguments, &exception);
    
    if (jsArguments != NULL) {
        free(jsArguments);
    }
    
    if (exception != NULL) {
        [self throwJSException:exception];
        return NULL;
    }
    
    return returnValue;
}


#pragma mark -
#pragma mark Syntax Validation

- (BOOL)isSyntaxValidForString:(NSString *)string {
    JSStringRef jsScript = JSStringCreateWithUTF8CString([string UTF8String]);
    JSValueRef exception = NULL;
    bool success = JSCheckScriptSyntax(_ctx, jsScript, NULL, 1, &exception);
    
    if (jsScript != NULL) {
        JSStringRelease(jsScript);
    }
    
    if (exception != NULL) {
        [self throwJSException:exception];
    }
    
    return success;
}


#pragma mark -
#pragma mark Exceptions

+ (NSException *)exceptionWithJSException:(JSValueRef)exception context:(JSContextRef)ctx {
    NSString *error = nil;
    JSStringRef resultStringJS = JSValueToStringCopy(ctx, exception, NULL);
    if (resultStringJS != NULL) {
        error = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, resultStringJS));
        JSStringRelease(resultStringJS);
    }
    
    if (JSValueGetType(ctx, exception) != kJSTypeObject) {
        NSException *mochaException = [NSException exceptionWithName:MOJavaScriptException reason:error userInfo:nil];
        return mochaException;
    }
    else {
        // Iterate over all properties of the exception
        JSObjectRef jsObject = JSValueToObject(ctx, exception, NULL);
        JSPropertyNameArrayRef jsNames = JSObjectCopyPropertyNames(ctx, jsObject);
        size_t count = JSPropertyNameArrayGetCount(jsNames);
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:count];
        
        for (size_t i = 0; i < count; i++) {
            JSStringRef jsName = JSPropertyNameArrayGetNameAtIndex(jsNames, i);
            NSString *name = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, jsName));
            
            JSValueRef jsValueRef = JSObjectGetProperty(ctx, jsObject, jsName, NULL);
            JSStringRef valueJS = JSValueToStringCopy(ctx, jsValueRef, NULL);
            NSString *value = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, valueJS));
            JSStringRelease(valueJS);
            
            [userInfo setObject:value forKey:name];
        }
        
        JSPropertyNameArrayRelease(jsNames);
        
        NSException *mochaException = [NSException exceptionWithName:MOJavaScriptException reason:error userInfo:userInfo];
        return mochaException;
    }
}

- (NSException *)exceptionWithJSException:(JSValueRef)exception {
    return [Mocha exceptionWithJSException:exception context:_ctx];
}

- (void)throwJSException:(JSValueRef)exceptionJS {
    id object = [self objectForJSValue:exceptionJS];
    if ([object isKindOfClass:[NSException class]]) {
        // Rethrow ObjC exceptions that were boxed within the runtime
        @throw object;
    }
    else {
        // Throw all other types of exceptions as an NSException
        NSException *exception = [self exceptionWithJSException:exceptionJS];
        if (exception != nil) {
            @throw exception;
        }
    }
}


#pragma mark -
#pragma mark BridgeSupport Metadata

- (BOOL)loadFrameworkWithName:(NSString *)frameworkName {
    BOOL success = NO;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    for (NSString *path in _frameworkSearchPaths) {
        NSString *frameworkPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.framework", frameworkName]];
        if ([fileManager fileExistsAtPath:frameworkPath]) {
            success = [self loadFrameworkWithName:frameworkName inDirectory:path];
            if (success) {
                break;
            }
        }
    }
    
    return success;
}

- (BOOL)loadFrameworkWithName:(NSString *)frameworkName inDirectory:(NSString *)directory {
    NSString *frameworkPath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.framework", frameworkName]];
    
    // Load the framework
    NSString *libPath = [frameworkPath stringByAppendingPathComponent:frameworkName];
    void *address = dlopen([libPath UTF8String], RTLD_LAZY);
    if (!address) {
        //NSLog(@"ERROR: Could not load framework dylib: %@, %@", frameworkName, libPath);
        return NO;
    }
    
    // Load the BridgeSupport data
    NSString *bridgeSupportPath = [frameworkPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Resources/BridgeSupport"]];
    [self loadBridgeSupportFilesAtPath:bridgeSupportPath];
    
    return YES;
}

- (BOOL)loadBridgeSupportFilesAtPath:(NSString *)path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        NSMutableArray *filesToLoad = [NSMutableArray array];
        if (isDirectory) {
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:nil];
            for (NSString *filePathComponent in contents) {
                NSString *filePath = [path stringByAppendingPathComponent:filePathComponent];
                if ([[filePath pathExtension] isEqualToString:@"bridgesupport"]
                    || [[filePathComponent pathExtension] isEqualToString:@"dylib"]) {
                    [filesToLoad addObject:filePath];
                }
            }
        }
        else {
            if ([[path pathExtension] isEqualToString:@"bridgesupport"]
                || [[path pathExtension] isEqualToString:@"dylib"]) {
                [filesToLoad addObject:path];
            }
            else {
                return NO;
            }
        }
        
        // Load files
        for (NSString *filePath in filesToLoad) {
            if ([[filePath pathExtension] isEqualToString:@"bridgesupport"]) {
                // BridgeSupport
                NSError *error = nil;
                if (![[MOBridgeSupportController sharedController] loadBridgeSupportAtURL:[NSURL fileURLWithPath:filePath] error:&error]) {
                    return NO;
                }
            }
#if !TARGET_OS_IPHONE
            else if ([[filePath pathExtension] isEqualToString:@"dylib"]) {
                // dylib
                dlopen([filePath UTF8String], RTLD_LAZY);
            }
#endif
        }
        
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray *)frameworkSearchPaths {
    return _frameworkSearchPaths;
}

- (void)setFrameworkSearchPaths:(NSArray *)frameworkSearchPaths {
    [_frameworkSearchPaths setArray:frameworkSearchPaths];
}

- (void)addFrameworkSearchPath:(NSString *)path {
    [self insertFrameworkSearchPath:path atIndex:[_frameworkSearchPaths count]];
}

- (void)insertFrameworkSearchPath:(NSString *)path atIndex:(NSUInteger)idx {
    [_frameworkSearchPaths insertObject:path atIndex:idx];
}

- (void)removeFrameworkSearchPathAtIndex:(NSUInteger)idx {
    [_frameworkSearchPaths removeObjectAtIndex:idx];
}


#pragma mark -
#pragma mark Garbage Collection

- (void)garbageCollect {
    JSGarbageCollect(_ctx);
}


#pragma mark -
#pragma mark Support

- (void)installBuiltins {
    MOMethod *loadFramework = [MOMethod methodWithTarget:self selector:@selector(loadFrameworkWithName:)];
    [self setValue:loadFramework forKey:@"framework"];
    
    MOMethod *addFrameworkSearchPath = [MOMethod methodWithTarget:self selector:@selector(addFrameworkSearchPath:)];
    [self setValue:addFrameworkSearchPath forKey:@"addFrameworkSearchPath"];
    
    MOMethod *print = [MOMethod methodWithTarget:self selector:@selector(print:)];
    [self setValue:print forKey:@"print"];
    
    [self setValue:[MOObjCRuntime sharedRuntime] forKey:@"objc"];
}

- (void)print:(id)o {
    if (!o) {
        printf("null\n");
        return;
    }
    printf("%s\n", [[o description] UTF8String]);
}

- (void)cleanUp {
    // Cleanup if we created the JavaScriptCore context
    if (_ownsContext) {
//        [self unlinkAllReferences];
        [self garbageCollect];
    }
}

//- (void)unlinkAllReferences {
//    // Null and delete every reference to every live object
//    [self evalJSString:@"for (var i in this) { this[i] = null; delete this[i]; }"];
//}


#pragma mark -
#pragma mark Symbols

- (NSArray *)globalSymbolNames {
    NSMutableArray *symbols = [NSMutableArray array];
    
    // Exported objects
    [symbols addObjectsFromArray:[_exportedObjects allKeys]];
    
    // ObjC runtime
    [symbols addObjectsFromArray:[[MOObjCRuntime sharedRuntime] classes]];
    [symbols addObjectsFromArray:[[MOObjCRuntime sharedRuntime] protocols]];
    
    // BridgeSupport
    NSDictionary *bridgeSupportSymbols = [[MOBridgeSupportController sharedController] performQueryForSymbolsOfType:[NSArray arrayWithObjects:
                                                                                                                     [MOBridgeSupportFunction class],
                                                                                                                     [MOBridgeSupportConstant class],
                                                                                                                     [MOBridgeSupportEnum class],
                                                                                                                     nil]];
    [symbols addObjectsFromArray:[bridgeSupportSymbols allKeys]];
    
    return symbols;
}

@end


#pragma mark -
#pragma mark Mocha Scripting

@implementation NSObject (MochaScripting)

+ (BOOL)isSelectorExcludedFromMochaScript:(SEL)selector {
    return NO;
}

+ (SEL)selectorForMochaPropertyName:(NSString *)propertyName {
    return MOSelectorFromPropertyName(propertyName);
}

- (void)finalizeForMochaScript {
    // no-op
}

@end


#pragma mark -
#pragma mark Global Object

JSValueRef Mocha_getProperty(JSContextRef ctx, JSObjectRef object, JSStringRef propertyNameJS, JSValueRef *exception) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, propertyNameJS));
    
    if ([propertyName isEqualToString:@"__mocha__"]) {
        return NULL;
    }
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    //
    // Exported objects
    //
    id exportedObj = [runtime valueForKey:propertyName];
    if (exportedObj != nil) {
        JSValueRef ret = [runtime JSValueForObject:exportedObj];
        return ret;
    }
    
    //
    // ObjC class
    //
    Class objCClass = NSClassFromString(propertyName);
    if (objCClass != Nil && ![propertyName isEqualToString:@"Object"]) {
        JSValueRef ret = [runtime JSValueForObject:objCClass];
        return ret;
    }
    
    //
    // Query BridgeSupport for property
    //
    MOBridgeSupportSymbol *symbol = [[MOBridgeSupportController sharedController] performQueryForSymbolName:propertyName];
    if (symbol != nil) {
        // Functions
        if ([symbol isKindOfClass:[MOBridgeSupportFunction class]]) {
            return [runtime JSValueForObject:symbol];
        }
        
        // Constants
        else if ([symbol isKindOfClass:[MOBridgeSupportConstant class]]) {
            NSString *type = nil;
#if __LP64__
            type = [(MOBridgeSupportConstant *)symbol type64];
            if (type == nil) {
                type = [(MOBridgeSupportConstant *)symbol type];
            }
#else
            type = [(MOBridgeSupportConstant *)symbol type];
#endif
            
            // Raise if there is no type
            if (type == nil) {
                NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"No type defined for symbol: %@", symbol] userInfo:nil];
                if (exception != NULL) {
                    *exception = [runtime JSValueForObject:e];
                }
                return NULL;
            }
            
            // Grab symbol
            void *symbol = dlsym(RTLD_DEFAULT, [propertyName UTF8String]);
            if (!symbol) {
                NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Symbol not found: %@", symbol] userInfo:nil];
                if (exception != NULL) {
                    *exception = [runtime JSValueForObject:e];
                }
                return NULL;
            }
            
            char typeEncodingChar = [type UTF8String][0];
            MOFunctionArgument *argument = [[MOFunctionArgument alloc] init];
            
            if (typeEncodingChar == _C_STRUCT_B) {
                [argument setStructureTypeEncoding:type withCustomStorage:symbol];
            }
            else if (typeEncodingChar == _C_PTR) {
                if ([type isEqualToString:@"^{__CFString=}"]) {
                    [argument setTypeEncoding:_C_ID withCustomStorage:symbol];
                }
                else {
                    [argument setPointerTypeEncoding:type withCustomStorage:symbol];
                }
            }
            else {
                [argument setTypeEncoding:typeEncodingChar withCustomStorage:symbol];
            }
            
            JSValueRef valueJS = [argument getValueAsJSValueInContext:ctx];
            
            return valueJS;
        }
        
        // Enums
        else if ([symbol isKindOfClass:[MOBridgeSupportEnum class]]) {
            double doubleValue = 0;
            NSNumber *value = [(MOBridgeSupportEnum *)symbol value];
#if __LP64__
            NSNumber *value64 = [(MOBridgeSupportEnum *)symbol value64];
            if (value64 != nil) {
                doubleValue = [value doubleValue];
            }
            else {
#endif
                if (value != nil) {
                    doubleValue = [value doubleValue];
                }
                else {
                    NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"No value for enum: %@", symbol] userInfo:nil];
                    if (exception != NULL) {
                        *exception = [runtime JSValueForObject:e];
                    }
                    return NULL;
                }
#if __LP64__
            }
#endif
            return JSValueMakeNumber(ctx, doubleValue);
        }
    }
    
    return NULL;
}


#pragma mark -
#pragma mark Mocha Objects

static void MOObject_initialize(JSContextRef ctx, JSObjectRef object) {
    MOBox *private = (__bridge MOBox *)(JSObjectGetPrivate(object));
    CFRetain((__bridge CFTypeRef)private);
}

static void MOObject_finalize(JSObjectRef object) {
    MOBox *private = (__bridge MOBox *)(JSObjectGetPrivate(object));
    id o = [private representedObject];
    
    // Give the object a chance to finalize itself
    if ([o respondsToSelector:@selector(finalizeForMochaScript)]) {
        [o finalizeForMochaScript];
    }
    
    // Remove the object association
    Mocha *runtime = [private runtime];
    [runtime removeBoxAssociationForObject:o];
    
    JSObjectSetPrivate(object, NULL);
    
    CFRelease((__bridge CFTypeRef)private);
}


#pragma mark -
#pragma mark Mocha Boxed Objects

static bool MOBoxedObject_hasProperty(JSContextRef ctx, JSObjectRef objectJS, JSStringRef propertyNameJS) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(NULL, propertyNameJS));
    
//    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    id private = (__bridge id)(JSObjectGetPrivate(objectJS));
    id object = [private representedObject];
    Class objectClass = [object class];
    
    // String conversion
    if ([propertyName isEqualToString:@"toString"]) {
        return YES;
    }
    
    // Allocators
    if ([object isKindOfClass:[MOAllocator class]]) {
        objectClass = [object objectClass];
        
        // Method
        SEL selector = MOSelectorFromPropertyName(propertyName);
        NSMethodSignature *methodSignature = [objectClass instanceMethodSignatureForSelector:selector];
        if (!methodSignature) {
            // Allow the trailing underscore to be left off (issue #7)
            selector = MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"]);
            methodSignature = [objectClass instanceMethodSignatureForSelector:selector];
        }
        if (methodSignature != nil) {
            if ([objectClass respondsToSelector:@selector(isSelectorExcludedFromMochaScript:)]) {
                if (![objectClass isSelectorExcludedFromMochaScript:selector]) {
                    return YES;
                }
            }
            else {
                return YES;
            }
        }
    }
    
    // Property
    objc_property_t property = class_getProperty(objectClass, [propertyName UTF8String]);
    if (property != NULL) {
        SEL selector = NULL;
        char * getterValue = property_copyAttributeValue(property, "G");
        if (getterValue != NULL) {
            selector = NSSelectorFromString([NSString stringWithUTF8String:getterValue]);
            free(getterValue);
        }
        else {
            selector = NSSelectorFromString(propertyName);
        }
        
        if ([object respondsToSelector:selector] && ![objectClass isSelectorExcludedFromMochaScript:selector]) {
            return YES;
        }
    }
    
    // Association object
    id value = objc_getAssociatedObject(object, (__bridge const void *)(propertyName));
    if (value != nil) {
        return YES;
    }
    
    // Method
    SEL selector = MOSelectorFromPropertyName(propertyName);
    NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
    if (!methodSignature) {
        // Allow the trailing underscore to be left off (issue #7)
        selector = MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"]);
        methodSignature = [object methodSignatureForSelector:selector];
    }
    if (methodSignature != nil) {
        if ([objectClass respondsToSelector:@selector(isSelectorExcludedFromMochaScript:)]) {
            if (![objectClass isSelectorExcludedFromMochaScript:selector]) {
                return YES;
            }
        }
        else {
            return YES;
        }
    }
    
    // Indexed subscript
    if ([object respondsToSelector:@selector(objectForIndexedSubscript:)]) {
        NSScanner *scanner = [NSScanner scannerWithString:propertyName];
        NSInteger integerValue;
        if ([scanner scanInteger:&integerValue]) {
            return YES;
        }
    }
    
    // Keyed subscript
    if ([object respondsToSelector:@selector(objectForKeyedSubscript:)]) {
        return YES;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        // special case bridging of NSString w/ JS string functions
        
        if (MOStringPrototypeFunction(ctx, propertyName)) {
            return YES;
        }
    }
    
    return NO;
}

static JSValueRef MOBoxedObject_getProperty(JSContextRef ctx, JSObjectRef objectJS, JSStringRef propertyNameJS, JSValueRef *exception) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(NULL, propertyNameJS));
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    id private = (__bridge id)(JSObjectGetPrivate(objectJS));
    id object = [private representedObject];
    Class objectClass = [object class];
    
    // Perform the lookup
    @try {
        // String conversion
        if ([propertyName isEqualToString:@"toString"]) {
            MOMethod *function = [MOMethod methodWithTarget:object selector:@selector(description)];
            return [runtime JSValueForObject:function];
        }
        
        // Allocators
        if ([object isKindOfClass:[MOAllocator class]]) {
            objectClass = [object objectClass];
            
            // Method
            SEL selector = MOSelectorFromPropertyName(propertyName);
            NSMethodSignature *methodSignature = [objectClass instanceMethodSignatureForSelector:selector];
            if (!methodSignature) {
                // Allow the trailing underscore to be left off (issue #7)
                selector = MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"]);
                methodSignature = [objectClass instanceMethodSignatureForSelector:selector];
            }
            if (methodSignature != nil) {
                BOOL implements = NO;
                if ([objectClass respondsToSelector:@selector(isSelectorExcludedFromMochaScript:)]) {
                    if (![objectClass isSelectorExcludedFromMochaScript:selector]) {
                        implements = YES;
                    }
                }
                else {
                    implements = YES;
                }
                if (implements) {
                    MOMethod *function = [MOMethod methodWithTarget:object selector:selector];
                    return [runtime JSValueForObject:function];
                }
            }
        }
        
        
        // Association object
        id value = objc_getAssociatedObject(object, (__bridge const void *)(propertyName));
        if (value != nil) {
            return [runtime JSValueForObject:value];
        }
        
        // Method
        SEL selector = MOSelectorFromPropertyName(propertyName);
        NSMethodSignature *methodSignature = [object methodSignatureForSelector:selector];
        if (!methodSignature) {
            // Allow the trailing underscore to be left off (issue #7)
            selector = MOSelectorFromPropertyName([propertyName stringByAppendingString:@"_"]);
            methodSignature = [object methodSignatureForSelector:selector];
        }
        if (methodSignature != nil) {
            BOOL implements = NO;
            if ([objectClass respondsToSelector:@selector(isSelectorExcludedFromMochaScript:)]) {
                if (![objectClass isSelectorExcludedFromMochaScript:selector]) {
                    implements = YES;
                }
            }
            else {
                implements = YES;
            }
            if (implements) {
                MOMethod *function = [MOMethod methodWithTarget:object selector:selector];
                return [runtime JSValueForObject:function];
            }
        }
        
        // Property
        objc_property_t property = class_getProperty(objectClass, [propertyName UTF8String]);
        if (property != NULL) {
            SEL selector = NULL;
            char * getterValue = property_copyAttributeValue(property, "G");
            if (getterValue != NULL) {
                selector = NSSelectorFromString([NSString stringWithUTF8String:getterValue]);
                free(getterValue);
            }
            else {
                selector = NSSelectorFromString(propertyName);
            }
            
            if ([object respondsToSelector:selector] && ![objectClass isSelectorExcludedFromMochaScript:selector]) {
                MOMethod *method = [MOMethod methodWithTarget:object selector:selector];
                JSValueRef value = MOFunctionInvoke(method, ctx, 0, NULL, exception);
                return value;
            }
        }
        
        // Indexed subscript
        if ([object respondsToSelector:@selector(objectForIndexedSubscript:)]) {
            NSScanner *scanner = [NSScanner scannerWithString:propertyName];
            NSInteger integerValue;
            if ([scanner scanInteger:&integerValue]) {
                id value = [object objectForIndexedSubscript:integerValue];
                if (value != nil) {
                    return [runtime JSValueForObject:value];
                }
            }
        }
        
        // Keyed subscript
        if ([object respondsToSelector:@selector(objectForKeyedSubscript:)]) {
            id value = [object objectForKeyedSubscript:propertyName];
            if (value != nil) {
                return [runtime JSValueForObject:value];
            }
            else {
                return JSValueMakeNull(ctx);
            }
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            // special case bridging of NSString w/ JS string functions
            
            JSValueRef jsPropertyValue = MOStringPrototypeFunction(ctx, propertyName);
            
            if (jsPropertyValue) {
                return jsPropertyValue;
            }
        }
        
        
        
//        if (exception != NULL) {
//            NSString *reason = nil;
//            if (object == objectClass) {
//                // Class method
//                reason = [NSString stringWithFormat:@"Unrecognized selector sent to class: +[%@ %@]", objectClass, NSStringFromSelector(selector)];
//            }
//            else {
//                // Instance method
//                reason = [NSString stringWithFormat:@"Unrecognized selector sent to instance -[%@ %@]", objectClass, NSStringFromSelector(selector)];
//            }
//            NSException *e = [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
//            *exception = [runtime JSValueForObject:e];
//        }
//        
//        return NULL;
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return NULL;
}

static bool MOBoxedObject_setProperty(JSContextRef ctx, JSObjectRef objectJS, JSStringRef propertyNameJS, JSValueRef valueJS, JSValueRef *exception) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(NULL, propertyNameJS));
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    id private = (__bridge id)(JSObjectGetPrivate(objectJS));
    id object = [private representedObject];
    Class objectClass = [object class];
    id value = [runtime objectForJSValue:valueJS];
    
    // Perform the lookup
    @try {
        // Property
        objc_property_t property = class_getProperty(objectClass, [propertyName UTF8String]);
        if (property != NULL) {
            SEL selector = NULL;
            char * setterValue = property_copyAttributeValue(property, "S");
            if (setterValue != NULL) {
                selector = NSSelectorFromString([NSString stringWithUTF8String:setterValue]);
                free(setterValue);
            }
            else {
                NSString *setterName = MOPropertyNameToSetterName(propertyName);
                selector = MOSelectorFromPropertyName(setterName);
            }
            
            if ([object respondsToSelector:selector] && ![objectClass isSelectorExcludedFromMochaScript:selector]) {
                MOMethod *method = [MOMethod methodWithTarget:object selector:selector];
                MOFunctionInvoke(method, ctx, 1, &valueJS, exception);
                return YES;
            }
        }
        
        // Indexed subscript
        if ([object respondsToSelector:@selector(setObject:forIndexedSubscript:)]) {
            NSScanner *scanner = [NSScanner scannerWithString:propertyName];
            NSInteger integerValue;
            if ([scanner scanInteger:&integerValue]) {
                [object setObject:value forIndexedSubscript:integerValue];
                return YES;
            }
        }
        
        // Keyed subscript
        if ([object respondsToSelector:@selector(objectForKeyedSubscript:)]) {
            [object setObject:value forKeyedSubscript:propertyName];
            return YES;
        }
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return NO;
}

static bool MOBoxedObject_deleteProperty(JSContextRef ctx, JSObjectRef objectJS, JSStringRef propertyNameJS, JSValueRef *exception) {
    NSString *propertyName = (NSString *)CFBridgingRelease(JSStringCopyCFString(NULL, propertyNameJS));
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    id private = (__bridge id)(JSObjectGetPrivate(objectJS));
    id object = [private representedObject];
    
    // Perform the lookup
    @try {
        // Indexed subscript
        if ([object respondsToSelector:@selector(setObject:forIndexedSubscript:)]) {
            NSScanner *scanner = [NSScanner scannerWithString:propertyName];
            NSInteger integerValue;
            if ([scanner scanInteger:&integerValue]) {
                [object setObject:nil forIndexedSubscript:integerValue];
                return YES;
            }
        }
        
        // Keyed subscript
        if ([object respondsToSelector:@selector(objectForKeyedSubscript:)]) {
            [object setObject:nil forKeyedSubscript:propertyName];
            return YES;
        }
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return NO;
}

static void MOBoxedObject_getPropertyNames(JSContextRef ctx, JSObjectRef object, JSPropertyNameAccumulatorRef propertyNames) {
    MOBox *privateObject = (__bridge MOBox *)(JSObjectGetPrivate(object));
    
    // If we have a dictionary, add keys from allKeys
    id o = [privateObject representedObject];
    
    if ([o isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = o;
        NSArray *keys = [dictionary allKeys];
        
        for (NSString *key in keys) {
            JSStringRef jsString = JSStringCreateWithUTF8CString([key UTF8String]);
            JSPropertyNameAccumulatorAddName(propertyNames, jsString);
            JSStringRelease(jsString);
        }
    }
}

static JSValueRef MOBoxedObject_convertToType(JSContextRef ctx, JSObjectRef object, JSType type, JSValueRef *exception) {
    return MOJSValueToType(ctx, object, type, exception);
}

static bool MOBoxedObject_hasInstance(JSContextRef ctx, JSObjectRef constructor, JSValueRef possibleInstance, JSValueRef *exception) {
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    MOBox *privateObject = (__bridge MOBox *)(JSObjectGetPrivate(constructor));
    id representedObject = [privateObject representedObject];
    
    if (!JSValueIsObject(ctx, possibleInstance)) {
        return false;
    }
    
    JSObjectRef instanceObj = JSValueToObject(ctx, possibleInstance, exception);
    if (instanceObj == nil) {
        return NO;
    }
    MOBox *instancePrivateObj = (__bridge MOBox *)(JSObjectGetPrivate(instanceObj));
    id instanceRepresentedObj = [instancePrivateObj representedObject];
    
    // Check to see if the object's class matches the passed-in class
    @try {
        if (representedObject == [instanceRepresentedObj class]) {
            return true;
        }
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != nil) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return false;
}


#pragma mark -
#pragma mark Mocha Constructors

static JSObjectRef MOConstructor_callAsConstructor(JSContextRef ctx, JSObjectRef object, size_t argumentsCount, const JSValueRef arguments[], JSValueRef *exception) {
    return NULL;
}


#pragma mark -
#pragma mark Mocha Functions

static JSValueRef MOFunction_callAsFunction(JSContextRef ctx, JSObjectRef functionJS, JSObjectRef thisObject, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception) {
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    MOBox *private = (__bridge MOBox *)(JSObjectGetPrivate(functionJS));
    id function = [private representedObject];
    JSValueRef value = NULL;
    
    // Perform the invocation
    @try {
        value = MOFunctionInvoke(function, ctx, argumentCount, arguments, exception);
    }
    @catch (NSException *e) {
        // Catch ObjC exceptions and propogate them up as JS exceptions
        if (exception != nil) {
            *exception = [runtime JSValueForObject:e];
        }
    }
    
    return value;
}


static JSValueRef MOStringPrototypeFunction(JSContextRef ctx, NSString *name) {
    
    
    JSValueRef exception = nil;
    JSStringRef jsPropertyName = JSStringCreateWithUTF8CString("String");
    JSValueRef jsPropertyValue = JSObjectGetProperty(ctx, JSContextGetGlobalObject(ctx), jsPropertyName, &exception);
    JSStringRelease(jsPropertyName);
    
    jsPropertyName = JSStringCreateWithUTF8CString("prototype");
    jsPropertyValue = JSObjectGetProperty(ctx, JSValueToObject(ctx, jsPropertyValue, nil), jsPropertyName, &exception);
    JSStringRelease(jsPropertyName);
    
    jsPropertyName = JSStringCreateWithUTF8CString([name UTF8String]);
    jsPropertyValue = JSObjectGetProperty(ctx, JSValueToObject(ctx, jsPropertyValue, nil), jsPropertyName, &exception);
    JSStringRelease(jsPropertyName);
    
    if (jsPropertyValue && JSValueGetType(ctx, jsPropertyValue) == kJSTypeObject) {
        // OK, there's a JS String method with the same name as propertyName.  Let's use that.
        return jsPropertyValue;
    }
    
    return nil;
}
//
//  MOBox.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation MOBox

@synthesize representedObject=_representedObject;
@synthesize JSObject=_JSObject;
@synthesize runtime=_runtime;

@end
//
//  MOClassDescription.m
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//













#import <objc/runtime.h>


@interface MOClassDescription ()

- (id)initWithClass:(Class)aClass registered:(BOOL)isRegistered;

@end


@implementation MOClassDescription {
    Class _class;
    BOOL _registered;
}

+ (MOClassDescription *)descriptionForClassWithName:(NSString *)name {
    return [self descriptionForClass:NSClassFromString(name)];
}

+ (MOClassDescription *)descriptionForClass:(Class)aClass {
    return [[self alloc] initWithClass:aClass registered:YES];
}

+ (MOClassDescription *)allocateDescriptionForClassWithName:(NSString *)name superclass:(Class)superclass {
    if ([name length] == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"name must be of non-zero length" userInfo:nil];
    }
    
    Class aClass = NSClassFromString(name);
    if (aClass != Nil) {
        return nil;
    }
    
    aClass = objc_allocateClassPair(superclass, [name UTF8String], 0);
    if (aClass == nil) {
        NSLog(@"Error creating Objective-C class with name: %@", name);
        return nil;
    }
    
    return [[self alloc] initWithClass:aClass registered:NO];
}

- (id)initWithClass:(Class)aClass registered:(BOOL)isRegistered {
    self = [super init];
    if (self) {
        _class = aClass;
        _registered = isRegistered;
    }
    return self;
}

- (Class)registerClass {
    if (_registered == NO) {
        objc_registerClassPair(_class);
        _registered = YES;
    }
    else {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Class is already registered: %s", class_getName(_class)] userInfo:nil];
    }
    return _class;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : class=%s>", [self class], self, class_getName(_class)];
}


#pragma mark -
#pragma mark Accessors

- (NSString *)name {
    return [NSString stringWithUTF8String:class_getName(_class)];
}

- (Class)descriptedClass {
    return _class;
}

- (MOClassDescription *)superclass {
    Class superclass = class_getSuperclass(_class);
    if (superclass != Nil) {
        return [MOClassDescription descriptionForClass:superclass];
    }
    return nil;
}

- (NSArray *)ancestors {
    NSMutableArray *array = [NSMutableArray array];
    Class superclass = class_getSuperclass(_class);
    while (superclass != Nil) {
        MOClassDescription *description = [MOClassDescription descriptionForClass:superclass];
        if (description != nil) {
            [array addObject:description];
        }
        superclass = class_getSuperclass(superclass);
    }
    return array;
}


#pragma mark -
#pragma mark Instance Variables

- (NSArray *)instanceVariablesWithAncestors {
    NSMutableArray *array = [NSMutableArray array];
    MOClassDescription *description = self;
    while (description != nil) {
        [array addObjectsFromArray:[description instanceVariables]];
        description = description.superclass;
    }
    return array;
}

- (NSArray *)instanceVariables {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(_class, &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    if (ivars != NULL) {
        for (NSUInteger i=0; i<count; i++) {
            Ivar ivar = ivars[i];
            NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
            NSString *typeEncoding = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            MOInstanceVariableDescription *instanceVariable = [MOInstanceVariableDescription instanceVariableWithName:name typeEncoding:typeEncoding];
            [array addObject:instanceVariable];
        }
        
        free(ivars);
    }
    
    return array;
}

- (BOOL)addInstanceVariableWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding {
    if (_registered == YES) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"The class %s is already registered and its ivar layout cannot be modified.", class_getName(_class)] userInfo:nil];
    }
    
    const char * nameString = [name UTF8String];
    const char * typeString = [typeEncoding UTF8String];
    
    size_t alignment = 0;
    size_t size = 0;
    BOOL success = YES;
    
    success = [MOFunctionArgument getAlignment:&alignment ofTypeEncoding:typeString[0]];
    if (!success) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to get storage alignment for argument type %c", typeString[0]] userInfo:nil];
    }
    
    if (typeString[0] == _C_STRUCT_B) {
        size = [MOFunctionArgument sizeOfStructureTypeEncoding:typeEncoding];
    }
    else {
        success = [MOFunctionArgument getSize:&size ofTypeEncoding:typeString[0]];
        if (!success) {
            @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to get storage size for argument type %c", typeString[0]] userInfo:nil];
        }
    }
    
    return class_addIvar(_class, nameString, size, alignment, typeString);
}


#pragma mark -
#pragma mark Methods

+ (NSArray *)mo_methodsForClass:(Class)aClass {
    unsigned int count = 0;
    Method *methods = class_copyMethodList(aClass, &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    if (methods != NULL) {
        for (NSUInteger i=0; i<count; i++) {
            Method method = methods[i];
            SEL selector = method_getName(method);
            NSString *typeEncoding = [NSString stringWithUTF8String:method_getTypeEncoding(method)];
            MOMethodDescription *methodDesc = [MOMethodDescription methodWithSelector:selector typeEncoding:typeEncoding];
            [array addObject:methodDesc];
        }
        
        free(methods);
    }
    
    return array;
}

- (NSArray *)classMethods {
    Class metaclass = object_getClass(_class);
    return [MOClassDescription mo_methodsForClass:metaclass];
}

- (NSArray *)classMethodsWithAncestors {
    NSMutableArray *array = [NSMutableArray array];
    MOClassDescription *description = self;
    while (description != nil) {
        [array addObjectsFromArray:[description classMethods]];
        description = description.superclass;
    }
    return array;
}

- (NSArray *)instanceMethods {
    return [MOClassDescription mo_methodsForClass:_class];
}

- (NSArray *)instanceMethodsWithAncestors {
    NSMutableArray *array = [NSMutableArray array];
    MOClassDescription *description = self;
    while (description != nil) {
        [array addObjectsFromArray:[description instanceMethods]];
        description = description.superclass;
    }
    return array;
}

+ (BOOL)mo_addMethodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding block:(id)block class:(Class)aClass {
    if (selector == NULL) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"method cannot be nil" userInfo:nil];
    }
    if (typeEncoding == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"typeEncoding cannot be nil" userInfo:nil];
    }
    
    const char * typeEncodingString = [typeEncoding UTF8String];
    IMP implementation = imp_implementationWithBlock(block);
    
    return class_addMethod(aClass, selector, implementation, typeEncodingString);
}

- (BOOL)addClassMethodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding block:(id)block {
    Class metaclass = object_getClass(_class);
    return [MOClassDescription mo_addMethodWithSelector:selector typeEncoding:typeEncoding block:block class:metaclass];
}

- (BOOL)addClassMethodWithSelector:(SEL)selector function:(MOJavaScriptObject *)function {
    NSUInteger argCount = 0;
    id block = MOGetBlockForJavaScriptFunction(function, &argCount);
    
    NSMutableString *typeEncoding = [NSMutableString stringWithFormat:@"@@:"];
    for (NSUInteger i=0; i<argCount; i++) {
        [typeEncoding appendString:@"@"];
    }
    
    return [self addClassMethodWithSelector:selector typeEncoding:typeEncoding block:block];
}

- (BOOL)addInstanceMethodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding block:(id)block {
    return [MOClassDescription mo_addMethodWithSelector:selector typeEncoding:typeEncoding block:block class:_class];
}

- (BOOL)addInstanceMethodWithSelector:(SEL)selector function:(MOJavaScriptObject *)function {
    NSUInteger argCount = 0;
    id block = MOGetBlockForJavaScriptFunction(function, &argCount);
    
    NSMutableString *typeEncoding = [NSMutableString stringWithFormat:@"@@:"];
    for (NSUInteger i=0; i<argCount; i++) {
        [typeEncoding appendString:@"@"];
    }
    
    return [self addInstanceMethodWithSelector:selector typeEncoding:typeEncoding block:block];
}


#pragma mark -
#pragma mark Properties

- (NSArray *)properties {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(_class, &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    if (properties != NULL) {
        for (NSUInteger i=0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            
            MOPropertyDescription *propertyDesc = [[MOPropertyDescription alloc] init];
            propertyDesc.name = name;
            
            unsigned int attributeCount = 0;
            objc_property_attribute_t * attributes = property_copyAttributeList(property, &attributeCount);
            
            if (attributes != NULL) {
                for (NSUInteger i=0; i<attributeCount; i++) {
                    objc_property_attribute_t attribute = attributes[i];
                    const char *name = attribute.name;
                    const char *value = attribute.value;
                    
                    if (strcmp(name, "R") == 0) {
                        propertyDesc.readOnly = YES;
                    }
                    else if (strcmp(name, "C") == 0) {
                        propertyDesc.ownershipRule = MOObjCOwnershipRuleCopy;
                    }
                    else if (strcmp(name, "&") == 0) {
                        propertyDesc.ownershipRule = MOObjCOwnershipRuleRetain;
                    }
                    else if (strcmp(name, "N") == 0) {
                        propertyDesc.nonAtomic = YES;
                    }
                    else if (strcmp(name, "D") == 0) {
                        propertyDesc.dynamic = YES;
                    }
                    else if (strcmp(name, "W") == 0) {
                        propertyDesc.weak = YES;
                    }
                    else if (strcmp(name, "G") == 0) {
                        NSString *selectorName = [NSString stringWithUTF8String:value];
                        SEL selector = NSSelectorFromString(selectorName);
                        propertyDesc.getterSelector = selector;
                    }
                    else if (strcmp(name, "S") == 0) {
                        NSString *selectorName = [NSString stringWithUTF8String:value];
                        SEL selector = NSSelectorFromString(selectorName);
                        propertyDesc.getterSelector = selector;
                    }
                    else if (strcmp(name, "T") == 0) {
                        NSString *typeEncoding = [NSString stringWithUTF8String:value];
                        propertyDesc.typeEncoding = typeEncoding;
                    }
                    else if (strcmp(name, "V") == 0) {
                        NSString *variableName = [NSString stringWithUTF8String:value];
                        propertyDesc.ivarName = variableName;
                    }
                }
                
                free(attributes);
            }
            
            [array addObject:propertyDesc];
        }
        
        free(properties);
    }
    
    return array;
}

- (NSArray *)propertiesWithAncestors {
    NSMutableArray *array = [NSMutableArray array];
    MOClassDescription *description = self;
    while (description != nil) {
        [array addObjectsFromArray:[description properties]];
        description = description.superclass;
    }
    return array;
}

- (BOOL)addProperty:(MOPropertyDescription *)property {
    if (property == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"property cannot be nil" userInfo:nil];
    }
    if ([[property name] length] == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"name must be of non-zero length" userInfo:nil];
    }
    if (property.typeEncoding == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"typeEncoding must be of non-zero length" userInfo:nil];
    }
    
    const char * name = [[property name] UTF8String];
    const char * typeEncoding = [[property typeEncoding] UTF8String];
    const char * variableName = [[property ivarName] UTF8String];
    
    // Calculate the number of attributes
    unsigned int attributeCount = 0;
    
    if (property.typeEncoding != nil) {
        attributeCount++;
    }
    if (property.readOnly) {
        attributeCount++;
    }
    if (property.dynamic) {
        attributeCount++;
    }
    if (property.weak) {
        attributeCount++;
    }
    if (property.nonAtomic) {
        attributeCount++;
    }
    if (property.getterSelector != NULL) {
        attributeCount++;
    }
    if (property.setterSelector != NULL) {
        attributeCount++;
    }
    if (property.ownershipRule == MOObjCOwnershipRuleCopy
        || property.ownershipRule == MOObjCOwnershipRuleRetain) {
        attributeCount++;
    }
    if (property.ivarName != nil) {
        attributeCount++;
    }
    
    // Build the attributes
    objc_property_attribute_t *attrs = NULL;
    if (attributeCount > 0) {
        attrs = (objc_property_attribute_t *)malloc(sizeof(objc_property_attribute_t) * attributeCount);
        
        NSUInteger i = 0;
        
        // Type encoding (must be first)
        objc_property_attribute_t type = { "T", typeEncoding };
        attrs[i] = type;
        i++;
        
        // Readonly
        if (property.readOnly) {
            objc_property_attribute_t readonly = { "R", "" };
            attrs[i] = readonly;
            i++;
        }
        
        // Ownership rule
        if (property.ownershipRule == MOObjCOwnershipRuleCopy) {
            objc_property_attribute_t ownership = { "C", "" };
            attrs[i] = ownership;
            i++;
        }
        else if (property.ownershipRule == MOObjCOwnershipRuleRetain) {
            objc_property_attribute_t ownership = { "&", "" };
            attrs[i] = ownership;
            i++;
        }
        
        // Nonatomic
        if (property.nonAtomic) {
            objc_property_attribute_t nonatomic = { "N", "" };
            attrs[i] = nonatomic;
            i++;
        }
        
        // Getter
        if (property.getterSelector != NULL) {
            NSString *string = NSStringFromSelector(property.getterSelector);
            const char * value = [string UTF8String];
            objc_property_attribute_t getter = { "G", value };
            attrs[i] = getter;
            i++;
        }
        
        // Setter
        if (property.setterSelector != NULL) {
            NSString *string = NSStringFromSelector(property.setterSelector);
            const char * value = [string UTF8String];
            objc_property_attribute_t getter = { "S", value };
            attrs[i] = getter;
            i++;
        }
        
        // Dynamic
        if (property.dynamic) {
            objc_property_attribute_t readonly = { "R", "" };
            attrs[i] = readonly;
            i++;
        }
        
        // Weak
        if (property.weak) {
            objc_property_attribute_t weak = { "W", "" };
            attrs[i] = weak;
            i++;
        }
        
        // Backing ivar (must be last)
        if (property.ivarName != nil) {
            objc_property_attribute_t backingivar = { "V", variableName };
            attrs[i] = backingivar;
        }
    }
    
    BOOL success = class_addProperty(_class, name, (const objc_property_attribute_t *)attrs, attributeCount);
    
    free((void *)attrs);
    
    return success;
}


#pragma mark -
#pragma mark Protocols

- (NSArray *)protocols {
    unsigned int count;
    Protocol *__unsafe_unretained *protocols = class_copyProtocolList(_class, &count);
    
    if (protocols == NULL) {
        return [NSArray array];
    }
    
    NSMutableArray *protocolNames = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i=0; i<count; i++) {
        Protocol *protocol = protocols[i];
        MOProtocolDescription *protocolDesc = [MOProtocolDescription descriptionForProtocol:protocol];
        [protocolNames addObject:protocolDesc];
    }
    
    free(protocols);
    
    return protocolNames;
}

- (NSArray *)protocolsWithAncestors {
    NSMutableArray *array = [NSMutableArray array];
    MOClassDescription *description = self;
    while (description != nil) {
        [array addObjectsFromArray:[description protocols]];
        description = description.superclass;
    }
    return array;
}

- (void)addProtocol:(MOProtocolDescription *)protocol {
    if (protocol == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"protocol cannot be nil" userInfo:nil];
    }
    
    Protocol *aProtocol = [protocol protocol];
    class_addProtocol(_class, aProtocol);
}

@end
//
//  MOClosure.m
//  Mocha
//
//  Created by Logan Collins on 5/19/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//







@implementation MOClosure

@synthesize block=_block;

//
// The following two structs are taken from clang's source.
//

struct Block_descriptor {
    unsigned long reserved;
    unsigned long size;
    void *rest[1];
};

struct Block_literal {
    void *isa;
    int flags;
    int reserved;
    void *invoke;
    struct Block_descriptor *descriptor;
};

+ (MOClosure *)closureWithBlock:(id)block {
    return [[self alloc] initWithBlock:block];
}

- (id)initWithBlock:(id)block {
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void *)callAddress {
    return ((__bridge struct Block_literal *)_block)->invoke;
}

- (const char *)typeEncoding {
    struct Block_literal *block = (__bridge struct Block_literal *)_block;
    struct Block_descriptor *descriptor = block->descriptor;
    
    int copyDisposeFlag = 1 << 25;
    int signatureFlag = 1 << 30;
    
    assert(block->flags & signatureFlag);
    
    int index = 0;
    if (block->flags & copyDisposeFlag) {
        index += 2;
    }
    
    return descriptor->rest[index];
}

@end
//
//  MOInstanceVariableDescription.m
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//





@implementation MOInstanceVariableDescription

@synthesize name=_name;
@synthesize typeEncoding=_typeEncoding;

+ (MOInstanceVariableDescription *)instanceVariableWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding {
    return [[self alloc] initWithName:name typeEncoding:typeEncoding];
}

- (id)initWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding {
    self = [super init];
    if (self) {
        self.name = name;
        self.typeEncoding = typeEncoding;
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : name=%@, typeEncoding=%@>", [self class], self, self.name, self.typeEncoding];
}

@end
//
//  MOJavaScriptObject.m
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation MOJavaScriptObject {
    JSObjectRef _JSObject;
    JSContextRef _JSContext;
}

+ (MOJavaScriptObject *)objectWithJSObject:(JSObjectRef)jsObject context:(JSContextRef)ctx {
    MOJavaScriptObject *object = [[MOJavaScriptObject alloc] init];
    [object setJSObject:jsObject JSContext:ctx];
    return object;
}

- (void)dealloc {
    if (_JSObject != NULL) {
        JSValueUnprotect(_JSContext, _JSObject);
    }
}

- (JSObjectRef)JSObject {
    return _JSObject;
}

- (void)setJSObject:(JSObjectRef)JSObject JSContext:(JSContextRef)JSContext {
    if (_JSObject != NULL) {
        JSValueUnprotect(_JSContext, _JSObject);
    }
    _JSObject = JSObject;
    _JSContext = JSContext;
    if (_JSObject != NULL) {
        JSValueProtect(_JSContext, _JSObject);
    }
}

@end
//
//  MOMethod.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//





@implementation MOMethod

@synthesize target=_target;
@synthesize selector=_selector;
@synthesize block=_block;

+ (MOMethod *)methodWithTarget:(id)target selector:(SEL)selector {
    MOMethod *method = [[self alloc] init];
    method.target = target;
    method.selector = selector;
    return method;
}

+ (MOMethod *)methodWithBlock:(id)block {
    MOMethod *method = [[self alloc] init];
    method.block = block;
    return method;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : target=%@, selector=%@>", [self class], self, [self target], NSStringFromSelector([self selector])];
}

@end
//
//  MOMethodDescription.m
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//





@implementation MOMethodDescription

@synthesize selector=_selector;
@synthesize typeEncoding=_typeEncoding;

+ (MOMethodDescription *)methodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding {
    return [[self alloc] initWithSelector:selector typeEncoding:typeEncoding];
}

- (id)initWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding {
    self = [super init];
    if (self) {
        self.selector = selector;
        self.typeEncoding = typeEncoding;
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : selector=%@, typeEncoding=%@>", [self class], self, NSStringFromSelector(self.selector), self.typeEncoding];
}

@end
//
//  MOObjCRuntime.m
//  Mocha
//
//  Created by Logan Collins on 5/16/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//



#import <objc/runtime.h>


@implementation MOObjCRuntime

+ (MOObjCRuntime *)sharedRuntime {
    static MOObjCRuntime * sharedRuntime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRuntime = [[self alloc] init];
    });
    return sharedRuntime;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark Accessors

- (NSArray *)classes {
    unsigned int count;
    Class *classList = objc_copyClassList(&count);
    NSMutableArray *classes = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i=0; i<count; i++) {
        Class klass = classList[i];
        const char *name = class_getName(klass);
        NSString *string = [NSString stringWithUTF8String:name];
        if (![string hasPrefix:@"_"]) {
            [classes addObject:string];
        }
    }
    free(classList);
    [classes sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return classes;
}

- (NSArray *)protocols {
    unsigned int count;
    Protocol *__unsafe_unretained *protocolList = objc_copyProtocolList(&count);
    NSMutableArray *protocols = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i=0; i<count; i++) {
        Protocol *protocol = protocolList[i];
        const char *name = protocol_getName(protocol);
        NSString *string = [NSString stringWithUTF8String:name];
        if (![string hasPrefix:@"_"]) {
            [protocols addObject:string];
        }
    }
    free(protocolList);
    [protocols sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return protocols;
}

@end
//
//  MOPropertyDescription.m
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation MOPropertyDescription

@synthesize name=_name;
@synthesize typeEncoding=_typeEncoding;
@synthesize ivarName=_ivarName;
@synthesize getterSelector=_getterSelector;
@synthesize setterSelector=_setterSelector;
@synthesize ownershipRule=_ownershipRule;
@synthesize dynamic=_dynamic;
@synthesize nonAtomic=_nonAtomic;
@synthesize readOnly=_readOnly;
@synthesize weak=_weak;

- (NSString *)description {
    NSMutableArray *attributeValues = [NSMutableArray array];
    
    if (self.ownershipRule == MOObjCOwnershipRuleAssign) {
        [attributeValues addObject:@"assign"];
    }
    else if (self.ownershipRule == MOObjCOwnershipRuleCopy) {
        [attributeValues addObject:@"copy"];
    }
    else if (self.ownershipRule == MOObjCOwnershipRuleRetain) {
        [attributeValues addObject:@"retain"];
    }
    
    if (self.dynamic) {
        [attributeValues addObject:@"dynamic"];
    }
    if (self.nonAtomic) {
        [attributeValues addObject:@"nonatomic"];
    }
    if (self.readOnly) {
        [attributeValues addObject:@"readonly"];
    }
    if (self.weak) {
        [attributeValues addObject:@"weak"];
    }
    
    if (self.getterSelector != NULL) {
        [attributeValues addObject:[NSString stringWithFormat:@"getter=%@", NSStringFromSelector(self.getterSelector)]];
    }
    if (self.setterSelector != NULL) {
        [attributeValues addObject:[NSString stringWithFormat:@"setter=%@", NSStringFromSelector(self.setterSelector)]];
    }
    
    NSString *attributes = [attributeValues componentsJoinedByString:@","];
    
    return [NSString stringWithFormat:@"<%@: %p : name=%@, typeEncoding=%@, ivar=%@, attributes=(%@)>", [self class], self, self.name, self.typeEncoding, self.ivarName, attributes];
}

@end
//
//  MOProtocolDescription.m
//  Mocha
//
//  Created by Logan Collins on 5/18/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//







#import <objc/runtime.h>


@implementation MOProtocolDescription {
    Protocol *_protocol;
}

+ (MOProtocolDescription *)descriptionForProtocolWithName:(NSString *)name {
    Protocol *protocol = NSProtocolFromString(name);
    if (protocol == NULL) {
        return nil;
    }
    return [self descriptionForProtocol:protocol];
}

+ (MOProtocolDescription *)descriptionForProtocol:(Protocol *)protocol {
    return [[self alloc] initWithProtocol:protocol];
}

+ (MOProtocolDescription *)allocateDescriptionForProtocolWithName:(NSString *)name {
    Protocol *protocol = objc_allocateProtocol([name UTF8String]);
    if (protocol == NULL) {
        return nil;
    }
    return [[self alloc] initWithProtocol:protocol];
}

- (id)initWithProtocol:(Protocol *)protocol {
    self = [super init];
    if (self) {
        _protocol = protocol;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : name=%s>", [self class], self, protocol_getName(_protocol)];
}


#pragma mark -
#pragma mark Accessors

- (Protocol *)protocol {
    return _protocol;
}

- (NSString *)name {
    return [NSString stringWithUTF8String:protocol_getName(_protocol)];
}


#pragma mark -
#pragma mark Methods

- (NSArray *)requiredClassMethods {
    unsigned int count = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(_protocol, YES, NO, &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    if (methodDescriptions != NULL) {
        for (NSUInteger i=0; i<count; i++) {
            struct objc_method_description methodDescription = methodDescriptions[i];
            SEL selector = methodDescription.name;
            NSString *typeEncoding = [NSString stringWithUTF8String:methodDescription.types];
            MOMethodDescription *methodDesc = [MOMethodDescription methodWithSelector:selector typeEncoding:typeEncoding];
            [array addObject:methodDesc];
        }
        
        free(methodDescriptions);
    }
    
    return array;
}

- (NSArray *)optionalClassMethods {
    unsigned int count = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(_protocol, NO, NO, &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    if (methodDescriptions != NULL) {
        for (NSUInteger i=0; i<count; i++) {
            struct objc_method_description methodDescription = methodDescriptions[i];
            SEL selector = methodDescription.name;
            NSString *typeEncoding = [NSString stringWithUTF8String:methodDescription.types];
            MOMethodDescription *methodDesc = [MOMethodDescription methodWithSelector:selector typeEncoding:typeEncoding];
            [array addObject:methodDesc];
        }
        
        free(methodDescriptions);
    }
    
    return array;
}

- (void)addClassMethod:(MOMethodDescription *)method required:(BOOL)isRequired {
    if (method == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"method cannot be nil" userInfo:nil];
    }
    SEL selector = [method selector];
    const char * typeEncoding = [[method typeEncoding] UTF8String];
    protocol_addMethodDescription(_protocol, selector, typeEncoding, isRequired, NO);
}

- (NSArray *)requiredInstanceMethods {
    unsigned int count = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(_protocol, YES, YES, &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    if (methodDescriptions != NULL) {
        for (NSUInteger i=0; i<count; i++) {
            struct objc_method_description methodDescription = methodDescriptions[i];
            SEL selector = methodDescription.name;
            NSString *typeEncoding = [NSString stringWithUTF8String:methodDescription.types];
            MOMethodDescription *methodDesc = [MOMethodDescription methodWithSelector:selector typeEncoding:typeEncoding];
            [array addObject:methodDesc];
        }
        
        free(methodDescriptions);
    }
    
    return array;
}

- (NSArray *)optionalInstanceMethods {
    unsigned int count = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(_protocol, NO, YES, &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    if (methodDescriptions != NULL) {
        for (NSUInteger i=0; i<count; i++) {
            struct objc_method_description methodDescription = methodDescriptions[i];
            SEL selector = methodDescription.name;
            NSString *typeEncoding = [NSString stringWithUTF8String:methodDescription.types];
            MOMethodDescription *methodDesc = [MOMethodDescription methodWithSelector:selector typeEncoding:typeEncoding];
            [array addObject:methodDesc];
        }
        
        free(methodDescriptions);
    }
    
    return array;
}

- (void)addInstanceMethod:(MOMethodDescription *)method required:(BOOL)isRequired {
    if (method == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"method cannot be nil" userInfo:nil];
    }
    SEL selector = [method selector];
    const char * typeEncoding = [[method typeEncoding] UTF8String];
    protocol_addMethodDescription(_protocol, selector, typeEncoding, isRequired, YES);
}


#pragma mark -
#pragma mark Properties

- (NSArray *)properties {
    unsigned int count = 0;
    objc_property_t *properties = protocol_copyPropertyList(_protocol, &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    if (properties != NULL) {
        for (NSUInteger i=0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            
            MOPropertyDescription *propertyDesc = [[MOPropertyDescription alloc] init];
            propertyDesc.name = name;
            
            unsigned int attributeCount = 0;
            objc_property_attribute_t * attributes = property_copyAttributeList(property, &attributeCount);
            
            if (attributes != NULL) {
                for (NSUInteger i=0; i<attributeCount; i++) {
                    objc_property_attribute_t attribute = attributes[i];
                    const char *name = attribute.name;
                    const char *value = attribute.value;
                    
                    if (strcmp(name, "R") == 0) {
                        propertyDesc.readOnly = YES;
                    }
                    else if (strcmp(name, "C") == 0) {
                        propertyDesc.ownershipRule = MOObjCOwnershipRuleCopy;
                    }
                    else if (strcmp(name, "&") == 0) {
                        propertyDesc.ownershipRule = MOObjCOwnershipRuleRetain;
                    }
                    else if (strcmp(name, "N") == 0) {
                        propertyDesc.nonAtomic = YES;
                    }
                    else if (strcmp(name, "D") == 0) {
                        propertyDesc.dynamic = YES;
                    }
                    else if (strcmp(name, "W") == 0) {
                        propertyDesc.weak = YES;
                    }
                    else if (strcmp(name, "G") == 0) {
                        NSString *selectorName = [NSString stringWithUTF8String:value];
                        SEL selector = NSSelectorFromString(selectorName);
                        propertyDesc.getterSelector = selector;
                    }
                    else if (strcmp(name, "S") == 0) {
                        NSString *selectorName = [NSString stringWithUTF8String:value];
                        SEL selector = NSSelectorFromString(selectorName);
                        propertyDesc.getterSelector = selector;
                    }
                    else if (strcmp(name, "T") == 0) {
                        NSString *typeEncoding = [NSString stringWithUTF8String:value];
                        propertyDesc.typeEncoding = typeEncoding;
                    }
                    else if (strcmp(name, "V") == 0) {
                        NSString *variableName = [NSString stringWithUTF8String:value];
                        propertyDesc.ivarName = variableName;
                    }
                }
                
                free(attributes);
            }
            
            [array addObject:propertyDesc];
        }
        
        free(properties);
    }
    
    return array;
}

- (void)addProperty:(MOPropertyDescription *)property required:(BOOL)isRequired {
    if (property == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"property cannot be nil" userInfo:nil];
    }
    if ([[property name] length] == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"name must be of non-zero length" userInfo:nil];
    }
    if (property.typeEncoding == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"typeEncoding must be of non-zero length" userInfo:nil];
    }
    if (property.ivarName == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"ivarName must be of non-zero length" userInfo:nil];
    }
    
    const char * name = [[property name] UTF8String];
    const char * typeEncoding = [[property typeEncoding] UTF8String];
    const char * variableName = [[property ivarName] UTF8String];
    
    // Calculate the number of attributes
    unsigned int attributeCount = 2; // (typeEncoding + variableName)
    
    if (property.readOnly) {
        attributeCount++;
    }
    if (property.dynamic) {
        attributeCount++;
    }
    if (property.weak) {
        attributeCount++;
    }
    if (property.nonAtomic) {
        attributeCount++;
    }
    if (property.getterSelector != NULL) {
        attributeCount++;
    }
    if (property.setterSelector != NULL) {
        attributeCount++;
    }
    if (property.ownershipRule == MOObjCOwnershipRuleCopy
        || property.ownershipRule == MOObjCOwnershipRuleRetain) {
        attributeCount++;
    }
    
    // Build the attributes
    objc_property_attribute_t *attrs = (objc_property_attribute_t *)malloc(sizeof(objc_property_attribute_t) * attributeCount);
    NSUInteger i = 0;
    
    // Type encoding (must be first)
    objc_property_attribute_t type = { "T", typeEncoding };
    attrs[i] = type;
    i++;
    
    // Readonly
    if (property.readOnly) {
        objc_property_attribute_t readonly = { "R", "" };
        attrs[i] = readonly;
        i++;
    }
    
    // Ownership rule
    if (property.ownershipRule == MOObjCOwnershipRuleCopy) {
        objc_property_attribute_t ownership = { "C", "" };
        attrs[i] = ownership;
        i++;
    }
    else if (property.ownershipRule == MOObjCOwnershipRuleRetain) {
        objc_property_attribute_t ownership = { "&", "" };
        attrs[i] = ownership;
        i++;
    }
    
    // Nonatomic
    if (property.nonAtomic) {
        objc_property_attribute_t nonatomic = { "N", "" };
        attrs[i] = nonatomic;
        i++;
    }
    
    // Getter
    if (property.getterSelector != NULL) {
        NSString *string = NSStringFromSelector(property.getterSelector);
        const char * value = [string UTF8String];
        objc_property_attribute_t getter = { "G", value };
        attrs[i] = getter;
        i++;
    }
    
    // Setter
    if (property.setterSelector != NULL) {
        NSString *string = NSStringFromSelector(property.setterSelector);
        const char * value = [string UTF8String];
        objc_property_attribute_t getter = { "S", value };
        attrs[i] = getter;
        i++;
    }
    
    // Dynamic
    if (property.dynamic) {
        objc_property_attribute_t readonly = { "R", "" };
        attrs[i] = readonly;
        i++;
    }
    
    // Weak
    if (property.weak) {
        objc_property_attribute_t weak = { "W", "" };
        attrs[i] = weak;
        i++;
    }
    
    // Backing ivar (must be last)
    objc_property_attribute_t backingivar = { "V", variableName };
    attrs[i] = backingivar;
    
    protocol_addProperty(_protocol, name, (const objc_property_attribute_t *)attrs, attributeCount, isRequired, YES);
    
    free((void *)attrs);
}


#pragma mark -
#pragma mark Protocols

- (NSArray *)protocols {
    unsigned int count;
    Protocol *__unsafe_unretained *protocols = protocol_copyProtocolList(_protocol, &count);
    
    if (protocols == NULL) {
        return [NSArray array];
    }
    
    NSMutableArray *protocolNames = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i=0; i<count; i++) {
        Protocol *protocol = protocols[i];
        MOProtocolDescription *protocolDesc = [MOProtocolDescription descriptionForProtocol:protocol];
        [protocolNames addObject:protocolDesc];
    }
    
    free(protocols);
    
    return protocolNames;
}

- (void)addProtocol:(MOProtocolDescription *)protocol {
    if (protocol == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"protocol cannot be nil" userInfo:nil];
    }
    
    Protocol *aProtocol = [protocol protocol];
    protocol_addProtocol(_protocol, aProtocol);
}

@end
//
//  MOStruct.m
//  Mocha
//
//  Created by Logan Collins on 5/15/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//





@implementation MOStruct {
    NSArray *_memberNames;
    NSMutableDictionary *_memberValues;
}

@synthesize name=_name;
@synthesize memberNames=_memberNames;

+ (MOStruct *)structureWithName:(NSString *)name memberNames:(NSArray *)memberNames {
    return [[self alloc] initWithName:name memberNames:memberNames];
}

- (id)initWithName:(NSString *)name memberNames:(NSArray *)memberNames {
    self = [super init];
    if (self) {
        _name = [name copy];
        _memberNames = [memberNames copy];
        _memberValues = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)init {
    return [self initWithName:nil memberNames:nil];
}

- (NSString *)descriptionWithIndent:(NSUInteger)indent {
    NSMutableString *indentString = [NSMutableString string];
    for (NSUInteger i=0; i<indent; i++) {
        [indentString appendString:@"    "];
    }
    
    NSMutableString *items = [NSMutableString stringWithString:@"{\n"];
    for (NSUInteger i=0; i<[_memberNames count]; i++) {
        NSString *key = [_memberNames objectAtIndex:i];
        
        [items appendString:indentString];
        [items appendString:@"    "];
        [items appendString:key];
        [items appendString:@" = "];
        
        id value = [_memberValues objectForKey:key];
        if ([value isKindOfClass:[MOStruct class]]) {
            [items appendString:[value descriptionWithIndent:indent + 1]];
        }
        else {
            [items appendString:[value description]];
        }
        
        if (i != [_memberNames count] - 1) {
            [items appendString:@","];
        }
        
        [items appendString:@"\n"];
    }
    [items appendString:indentString];
    [items appendString:@"}"];
    return [NSString stringWithFormat:@"%@ %@", self.name, items];
}

- (NSString *)description {
    return [self descriptionWithIndent:0];
}

- (id)objectForMemberName:(NSString *)name {
    if (![_memberNames containsObject:name]) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Struct %@ has no member named %@", self.name, name] userInfo:nil];
    }
    return [_memberValues objectForKey:name];
}

- (void)setObject:(id)obj forMemberName:(NSString *)name {
    if (![_memberNames containsObject:name]) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Struct %@ has no member named %@", self.name, name] userInfo:nil];
    }
    [_memberValues setObject:obj forKey:name];
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return [self objectForMemberName:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    [self setObject:obj forMemberName:key];
}

@end
//
//  MOUndefined.m
//  Mocha
//
//  Created by Logan Collins on 5/15/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation MOUndefined

+ (MOUndefined *)undefined {
    static MOUndefined *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
//
//  MOFunctionArgument.m
//  Mocha
//
//  Created by Logan Collins on 5/13/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

// 
// Note: A lot of this code is based on code from the PyObjC and JSCocoa projects.
// 




#import "MOPointerValue.h"






#import <objc/runtime.h>


@interface MOFunctionArgument ()

- (void *)allocateStorage;

@end


@implementation MOFunctionArgument {
    char _typeEncoding;
    void* _storage;
    BOOL _ownsStorage;
    ffi_type _structureType;
    NSString *_structureTypeEncoding;
    NSString *_pointerTypeEncoding;
    id _customData;
}

@synthesize pointer=_pointer;
@synthesize returnValue=_returnValue;

- (id)init {
    self = [super init];
    if (self) {
        _storage = NULL;
        _ownsStorage = NO;
    }
    return self;
}

- (void)dealloc {
    if (_storage != NULL && _ownsStorage) {
        free(_storage);
    }
    _storage = NULL;
    
    if (_structureType.elements != NULL) {
        free(_structureType.elements);
        _structureType.elements = NULL;
    }
}

- (NSString *)description {
    NSString *fullTypeEncoding = (_structureTypeEncoding != nil ? _structureTypeEncoding : @"");
    if ([fullTypeEncoding length] == 0) {
        fullTypeEncoding = (_pointerTypeEncoding != nil ? _pointerTypeEncoding : @"");
    }
    return [NSString stringWithFormat:@"<%@: %p : typeEncoding=%c %@, returnValue=%@, storage=%p>", [self class], self, _typeEncoding, fullTypeEncoding, (_returnValue ? @"YES" : @"NO"), _storage];
}


#pragma mark -
#pragma mark Accessors

- (char)typeEncoding {
    return _typeEncoding;
}

- (void)setTypeEncoding:(char)typeEncoding {
    [self setTypeEncoding:typeEncoding withCustomStorage:NULL];
}

- (void)setTypeEncoding:(char)typeEncoding withCustomStorage:(void *)storagePtr {
    if (![MOFunctionArgument getSize:NULL ofTypeEncoding:typeEncoding]) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Invalid type encoding: %c", typeEncoding] userInfo:nil];
    };
    
    _typeEncoding = typeEncoding;
    _pointerTypeEncoding = nil;
    _structureTypeEncoding = nil;
    
    if (storagePtr != NULL) {
        _storage = storagePtr;
    }
    else {
        [self allocateStorage];
    }
}

- (NSString *)pointerTypeEncoding {
    return _pointerTypeEncoding;
}

- (void)setPointerTypeEncoding:(NSString *)pointerTypeEncoding {
    [self setPointerTypeEncoding:pointerTypeEncoding withCustomStorage:NULL];
}

- (void)setPointerTypeEncoding:(NSString *)pointerTypeEncoding withCustomStorage:(void *)storagePtr {
    _typeEncoding = _C_PTR;
    _pointerTypeEncoding = [pointerTypeEncoding copy];
    _structureTypeEncoding = nil;
    
    if (storagePtr != NULL) {
        _storage = storagePtr;
    }
    else {
        [self allocateStorage];
    }
}

- (NSString *)structureTypeEncoding {
    return _structureTypeEncoding;
}

- (void)setStructureTypeEncoding:(NSString *)structureTypeEncoding {
    [self setStructureTypeEncoding:structureTypeEncoding withCustomStorage:NULL];
}

- (void)setStructureTypeEncoding:(NSString *)structureTypeEncoding withCustomStorage:(void *)storagePtr {
    _typeEncoding = _C_STRUCT_B;
    _pointerTypeEncoding = nil;
    _structureTypeEncoding = [structureTypeEncoding copy];
    
    if (storagePtr != NULL) {
        _storage = storagePtr;
    }
    else {
        [self allocateStorage];
    }
    
    NSArray *types = [MOFunctionArgument typeEncodingsFromStructureTypeEncoding:structureTypeEncoding];
    NSUInteger elementCount = [types count];
    
    // Build FFI type
    _structureType.size    = 0;
    _structureType.alignment = 0;
    _structureType.type    = FFI_TYPE_STRUCT;
    _structureType.elements = malloc(sizeof(ffi_type *) * (elementCount + 1)); // +1 is trailing NULL
    
    NSUInteger i = 0;
    for (NSString *type in types) {
        char charEncoding = *(char*)[type UTF8String];
        _structureType.elements[i++] = [MOFunctionArgument ffiTypeForTypeEncoding:charEncoding];
    }
    _structureType.elements[elementCount] = NULL;
}

- (ffi_type *)ffiType {
    if (!_typeEncoding) {
        return NULL;
    }
    if (_pointerTypeEncoding) {
        return &ffi_type_pointer;
    }
    if (_typeEncoding == _C_STRUCT_B) {
        return &_structureType;
    }
    return [MOFunctionArgument ffiTypeForTypeEncoding:_typeEncoding];
}

- (NSString *)typeDescription {
    return [MOFunctionArgument descriptionOfTypeEncoding:_typeEncoding fullTypeEncoding:_structureTypeEncoding];
}


#pragma mark -
#pragma mark Storage

- (void**)storage {
    if (self.pointer != nil) {
        return &_storage;
    }
    return _storage;
}

- (void *)allocateStorage {
    if (!_typeEncoding) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"No type encoding set in %@", self] userInfo:nil];
    }
    
    BOOL success = NO;
    size_t size = 0;
    
    // Special case for structs
    if (_typeEncoding == _C_STRUCT_B) {
        // Some front padding for alignment and tail padding for structure
        // ( http://developer.apple.com/documentation/DeveloperTools/Conceptual/LowLevelABI/Articles/IA32.html )
        // Structures are tail-padded to 32-bit multiples.
        
        // +16 for alignment
        // +4 for tail padding
        // size = [MOFunctionArgument sizeOfStructureTypeEncoding:_structureTypeEncoding] + 16 + 4;
        size = [MOFunctionArgument sizeOfStructureTypeEncoding:_structureTypeEncoding] + 4;
        success = YES;
    }
    else {
        success = [MOFunctionArgument getSize:&size ofTypeEncoding:_typeEncoding];
    }
    
    if (success) {
        size_t minimalReturnSize = sizeof(long);
        if (self.returnValue && size < minimalReturnSize) {
            size = minimalReturnSize;
        }
        _ownsStorage = YES;
        _storage = malloc(size);
    }
    else {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to allocate storage for argument type %c", _typeEncoding] userInfo:nil];
    }
    
    return _storage;
}

// This destroys the original pointer value by modifying it in place : maybe change to returning the new address ?
+ (void)alignPtr:(void**)ptr accordingToEncoding:(char)encoding {
    size_t alignOnSize = 0;
    BOOL success = [MOFunctionArgument getAlignment:&alignOnSize ofTypeEncoding:encoding];
    
    if (success) {
        long address = (long)*ptr;
        if ((address % alignOnSize) != 0) {
            address = (address + alignOnSize) & ~(alignOnSize - 1);
        }
        
        *ptr = (void*)address;
    }
    else {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to align pointer for argument type %c", encoding] userInfo:nil];
    }
}

// This destroys the original pointer value by modifying it in place : maybe change to returning the new address ?
+ (void)advancePtr:(void**)ptr accordingToEncoding:(char)encoding {
    long address = (long)*ptr;
    size_t size = 0;
    BOOL success = [MOFunctionArgument getSize:&size ofTypeEncoding:encoding];
    if (success) {
        address += size;
        *ptr = (void*)address;
    }
    else {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to advance pointer for argument type %c", encoding] userInfo:nil];
    }
}


#pragma mark -
#pragma mark JSValue conversion

- (JSValueRef)getValueAsJSValueInContext:(JSContextRef)ctx {
    return [self getValueAsJSValueInContext:ctx dereference:NO];
}

- (JSValueRef)getValueAsJSValueInContext:(JSContextRef)ctx dereference:(BOOL)dereference {
    NSAssert(_storage != NULL, @"Cannot get value with NULL storage pointer");
    
    JSValueRef value = NULL;
    void *p = _storage;
    char typeEncoding = _typeEncoding;
    NSString *encoding = (_structureTypeEncoding ? _structureTypeEncoding : _pointerTypeEncoding);
    
    if (dereference) {
        if (typeEncoding == _C_PTR) {
            typeEncoding = [_pointerTypeEncoding characterAtIndex:1];
            encoding = [_pointerTypeEncoding substringFromIndex:1];
        }
        else {
            @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to dereference non-pointer value: %@", self] userInfo:nil];
        }
    }
    
    if (![MOFunctionArgument toJSValue:&value inContext:ctx typeEncoding:typeEncoding fullTypeEncoding:encoding storage:p]) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Getting value as JSValue failed: %@", self] userInfo:nil];
    }
    
    return value;
}

- (void)setValueAsJSValue:(JSValueRef)value context:(JSContextRef)ctx {
    [self setValueAsJSValue:value context:ctx dereference:NO];
}

- (void)setValueAsJSValue:(JSValueRef)value context:(JSContextRef)ctx dereference:(BOOL)dereference {
    NSAssert(_storage != NULL, @"Cannot set value with NULL storage pointer");
    
    if (value != NULL && !JSValueIsNull(ctx, value)) {
        void *p = _storage;
        char typeEncoding = _typeEncoding;
        NSString *encoding = (_structureTypeEncoding ? _structureTypeEncoding : _pointerTypeEncoding);
        
        if (dereference) {
            if (typeEncoding == _C_PTR) {
                typeEncoding = [_pointerTypeEncoding characterAtIndex:1];
                encoding = [_pointerTypeEncoding substringFromIndex:1];
            }
            else {
                @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to dereference non-pointer value: %@", self] userInfo:nil];
            }
        }
        
        if (![MOFunctionArgument fromJSValue:value inContext:ctx typeEncoding:typeEncoding fullTypeEncoding:encoding storage:p]) {
            @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Setting value from JSValue failed: %@, %@", self, MOJSValueToString(ctx, value, NULL)] userInfo:nil];
        }
    }
    else {
        *(void**)_storage = NULL;
    }
}


#pragma mark -
#pragma mark Type Encodings

/*
 * __alignOf__ returns 8 for double, but its struct align is 4
 * use dummy structures to get struct alignment, each having a byte as first element
 */
typedef struct { char a; void* b; } struct_C_ID;
typedef struct { char a; char b; } struct_C_CHR;
typedef struct { char a; short b; } struct_C_SHT;
typedef struct { char a; int b; } struct_C_INT;
typedef struct { char a; long b; } struct_C_LNG;
typedef struct { char a; long long b; } struct_C_LNG_LNG;
typedef struct { char a; float b; } struct_C_FLT;
typedef struct { char a; double b; } struct_C_DBL;
typedef struct { char a; BOOL b; } struct_C_BOOL;

+ (BOOL)getAlignment:(size_t *)alignmentPtr ofTypeEncoding:(char)encoding {
    BOOL success = YES;
    size_t alignment = 0;
    switch (encoding) {
        case _C_ID:         alignment = offsetof(struct_C_ID, b); break;
        case _C_CLASS:      alignment = offsetof(struct_C_ID, b); break;
        case _C_SEL:        alignment = offsetof(struct_C_ID, b); break;
        case _C_CHR:        alignment = offsetof(struct_C_CHR, b); break;
        case _C_UCHR:       alignment = offsetof(struct_C_CHR, b); break;
        case _C_SHT:        alignment = offsetof(struct_C_SHT, b); break;
        case _C_USHT:       alignment = offsetof(struct_C_SHT, b); break;
        case _C_INT:        alignment = offsetof(struct_C_INT, b); break;
        case _C_UINT:       alignment = offsetof(struct_C_INT, b); break;
        case _C_LNG:        alignment = offsetof(struct_C_LNG, b); break;
        case _C_ULNG:       alignment = offsetof(struct_C_LNG, b); break;
        case _C_LNG_LNG:    alignment = offsetof(struct_C_LNG_LNG, b); break;
        case _C_ULNG_LNG:   alignment = offsetof(struct_C_LNG_LNG, b); break;
        case _C_FLT:        alignment = offsetof(struct_C_FLT, b); break;
        case _C_DBL:        alignment = offsetof(struct_C_DBL, b); break;
        case _C_BOOL:       alignment = offsetof(struct_C_BOOL, b); break;
        case _C_PTR:        alignment = offsetof(struct_C_ID, b); break;
        case _C_CHARPTR:    alignment = offsetof(struct_C_ID, b); break;
        default:            success = NO; break;
    }
    if (success && alignmentPtr != NULL) {
        *alignmentPtr = alignment;
    }
    return success;
}

+ (BOOL)getSize:(size_t *)sizePtr ofTypeEncoding:(char)encoding {
    BOOL success = YES;
    size_t size = 0;
    switch (encoding) {
        case _C_ID:         size = sizeof(id); break;
        case _C_CLASS:      size = sizeof(Class); break;
        case _C_SEL:        size = sizeof(SEL); break;
        case _C_PTR:        size = sizeof(void*); break;
        case _C_CHARPTR:    size = sizeof(char*); break;
        case _C_CHR:        size = sizeof(char); break;
        case _C_UCHR:       size = sizeof(unsigned char); break;
        case _C_SHT:        size = sizeof(short); break;
        case _C_USHT:       size = sizeof(unsigned short); break;
        case _C_INT:        size = sizeof(int); break;
        case _C_LNG:        size = sizeof(long); break;
        case _C_UINT:       size = sizeof(unsigned int); break;
        case _C_ULNG:       size = sizeof(unsigned long); break;
        case _C_LNG_LNG:    size = sizeof(long long); break;
        case _C_ULNG_LNG:   size = sizeof(unsigned long long); break;
        case _C_FLT:        size = sizeof(float); break;
        case _C_DBL:        size = sizeof(double); break;
        case _C_BOOL:       size = sizeof(bool); break;
        case _C_VOID:       size = sizeof(void); break;
        default:            success = NO; break;
    }
    if (success && sizePtr != NULL) {
        *sizePtr = size;
    }
    return success;
}

+ (ffi_type *)ffiTypeForTypeEncoding:(char)encoding {
    switch (encoding) {
        case _C_ID:
        case _C_CLASS:
        case _C_SEL:
        case _C_PTR:
        case _C_CHARPTR:    return &ffi_type_pointer;
        case _C_CHR:        return &ffi_type_sint8;
        case _C_UCHR:       return &ffi_type_uint8;
        case _C_SHT:        return &ffi_type_sint16;
        case _C_USHT:       return &ffi_type_uint16;
        case _C_INT:
        case _C_LNG:        return &ffi_type_sint32;
        case _C_UINT:
        case _C_ULNG:       return &ffi_type_uint32;
        case _C_LNG_LNG:    return &ffi_type_sint64;
        case _C_ULNG_LNG:   return &ffi_type_uint64;
        case _C_FLT:        return &ffi_type_float;
        case _C_DBL:        return &ffi_type_double;
        case _C_BOOL:       return &ffi_type_sint8;
        case _C_VOID:       return &ffi_type_void;
    }
    return NULL;
}

+ (NSString *)descriptionOfTypeEncoding:(char)encoding {
    switch (encoding) {
        case _C_ID:         return @"id";
        case _C_CLASS:      return @"Class";
        case _C_SEL:        return @"SEL";
        case _C_PTR:        return @"void*";
        case _C_CHARPTR:    return @"char*";
        case _C_CHR:        return @"char";
        case _C_UCHR:       return @"unsigned char";
        case _C_SHT:        return @"short";
        case _C_USHT:       return @"unsigned short";
        case _C_INT:        return @"int";
        case _C_LNG:        return @"long";
        case _C_UINT:       return @"unsigned int";
        case _C_ULNG:       return @"unsigned long";
        case _C_LNG_LNG:    return @"long long";
        case _C_ULNG_LNG:   return @"unsigned long long";
        case _C_FLT:        return @"float";
        case _C_DBL:        return @"double";
        case _C_BOOL:       return @"bool";
        case _C_VOID:       return @"void";
        case _C_UNDEF:      return @"(unknown)";
    }
    return nil;
}

+ (NSString *)descriptionOfTypeEncoding:(char)typeEncoding fullTypeEncoding:(NSString *)fullTypeEncoding {
    switch (typeEncoding) {
        case _C_VOID:       return @"void";
        case _C_ID:         return @"id";
        case _C_CLASS:      return @"Class";
        case _C_CHR:        return @"char";
        case _C_UCHR:       return @"unsigned char";
        case _C_SHT:        return @"short";
        case _C_USHT:       return @"unsigned short";
        case _C_INT:        return @"int";
        case _C_UINT:       return @"unsigned int";
        case _C_LNG:        return @"long";
        case _C_ULNG:       return @"unsigned long";
        case _C_LNG_LNG:    return @"long long";
        case _C_ULNG_LNG:   return @"unsigned long long";
        case _C_FLT:        return @"float";
        case _C_DBL:        return @"double";
        case _C_STRUCT_B: {
            return [MOFunctionArgument structureTypeEncodingDescription:fullTypeEncoding];
        }
        case _C_SEL:        return @"selector";
        case _C_CHARPTR:    return @"char*";
        case _C_BOOL:       return @"bool";
        case _C_PTR:        return @"void*";
        case _C_UNDEF:      return @"(unknown)";
    }
    return nil;
}


#pragma mark -
#pragma mark Structure Encodings

/*
 * From {_NSRect={_NSPoint=ff}{_NSSize=ff}}
 * Return {_NSRect="origin"{_NSPoint="x"f"y"f}"size"{_NSSize="width"f"height"f}}
 */
+ (NSString *)structureNameFromStructureTypeEncoding:(NSString *)encoding {
    // Extract structure name
    // skip '{'
    char *c = (char *)[encoding UTF8String] + 1;
    // skip '_' if it's there
    if (*c == '_') {
        c++;
    }
    char *c2 = c;
    while (*c2 && *c2 != '=') {
        c2++;
    }
    return [[NSString alloc] initWithBytes:c length:(c2-c) encoding:NSUTF8StringEncoding];
}

+ (NSString *)structureFullTypeEncodingFromStructureTypeEncoding:(NSString *)encoding {
    NSString *structureName = [MOFunctionArgument structureNameFromStructureTypeEncoding:encoding];
    return [self structureFullTypeEncodingFromStructureName:structureName];
}

+ (NSString *)structureFullTypeEncodingFromStructureName:(NSString *)structureName {
    // Fetch structure type encoding from BridgeSupport
    id symbol = [[MOBridgeSupportController sharedController] performQueryForSymbolName:structureName];
    
    if (symbol == nil) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"No structure encoding found for %@", structureName] userInfo:nil];
        return nil;
    }
    
#if __LP64__
    id type = ([symbol respondsToSelector:@selector(type64)] ? [symbol type64] : nil);
    if (type == nil) {
        type = ([symbol respondsToSelector:@selector(type)] ? [(MOBridgeSupportStruct*)symbol type] : nil);
    }
#else
    id type = ([symbol respondsToSelector:@selector(type)] ? [symbol type] : nil);
#endif
    
    return type;
}

+ (NSString *)structureTypeEncodingDescription:(NSString *)structureTypeEncoding {
    NSString *fullStructureTypeEncoding = [self structureFullTypeEncodingFromStructureTypeEncoding:structureTypeEncoding];
    if (!fullStructureTypeEncoding) {
        return [NSString stringWithFormat:@"(Could not describe struct %@)", structureTypeEncoding];
    }
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@{", [self structureNameFromStructureTypeEncoding:fullStructureTypeEncoding]];
    [self structureTypeEncodingDescription:fullStructureTypeEncoding inString:&str];
    [str appendString:@"}"];
    
    return str;
}

//
// Given a structure encoding string, produce a human readable format
//
+ (NSInteger)structureTypeEncodingDescription:(NSString *)structureTypeEncoding inString:(NSMutableString **)str {
    char *c = (char*)[structureTypeEncoding UTF8String];
    char *c0 = c;
    
    // Skip '{'
    c += 1;
    
    // Skip '_' if it's there
    if (*c == '_') {
        c++;
    }
    
    // Skip structureName, '='
    id structureName = [self structureNameFromStructureTypeEncoding:structureTypeEncoding];
    c += [structureName length] + 1;
    
    int    openedBracesCount = 1;
    int closedBracesCount = 0;
    int propertyCount = 0;
    
    for (; *c && closedBracesCount != openedBracesCount; c++) {
        if (*c == '{') {
            [*str appendString:@"{"];
            openedBracesCount++;
        }
        if (*c == '}') {
            [*str appendString:@"}"];
            closedBracesCount++;
        }
        
        // Parse name then type
        if (*c == '"') {
            propertyCount++;
            if (propertyCount > 1) {
                [*str appendString:@", "];
            }
            
            char* c2 = c+1;
            while (c2 && *c2 != '"') {
                c2++;
            }
            
            NSString *propertyName = [[NSString alloc] initWithBytes:c+1 length:(c2-c-1) encoding:NSUTF8StringEncoding];
            c = c2;
            
            // Skip '"'
            c++;
            
            char encoding = *c;
            [*str appendString:propertyName];
            [*str appendString:@": "];
            
            if (encoding == '{') {
                [*str appendString:@"{"];
                NSInteger parsed = [self structureTypeEncodingDescription:[NSString stringWithUTF8String:c] inString:str];
                c += parsed;
            }
            else {
                [*str appendString:@"("];
                [*str appendString:[self descriptionOfTypeEncoding:encoding fullTypeEncoding:nil]];
                [*str appendString:@")"];
            }
        }
    }
    return c - c0 - 1;
}

+ (size_t)sizeOfStructureTypeEncoding:(NSString *)encoding {
    NSArray *types = [self typeEncodingsFromStructureTypeEncoding:encoding];
    size_t computedSize = 0;
    void** ptr = (void**)&computedSize;
    for (NSString *type in types) {
        char charEncoding = *(char*)[type UTF8String];
        // Align 
        [MOFunctionArgument alignPtr:ptr accordingToEncoding:charEncoding];
        // Advance ptr
        [MOFunctionArgument advancePtr:ptr accordingToEncoding:charEncoding];
    }
    return computedSize;
}

+ (NSArray *)typeEncodingsFromStructureTypeEncoding:(NSString*)structureTypeEncoding {
    return [self typeEncodingsFromStructureTypeEncoding:structureTypeEncoding parsedCount:NULL];
}

+ (NSArray *)typeEncodingsFromStructureTypeEncoding:(NSString *)structureTypeEncoding parsedCount:(NSInteger *)count {
    NSMutableArray *types = [NSMutableArray array];
    char *c = (char *)[structureTypeEncoding UTF8String];
    char *c0 = c;
    int    openedBracesCount = 0;
    int closedBracesCount = 0;
    
    for (; *c; c++) {
        if (*c == '{') {
            openedBracesCount++;
            while (*c && *c != '=') {
                c++;
            }
            if (!*c) {
                continue;
            }
        }
        
        if (*c == '}') {
            closedBracesCount++;
            
            // If we parsed something (c>c0) and have an equal amount of opened and closed braces, we're done
            if (c0 != c && openedBracesCount == closedBracesCount) {
                c++;
                break;
            }
            
            continue;
        }
        
        if (*c == '=') {
            continue;
        }
        
        [types addObject:[NSString stringWithFormat:@"%c", *c]];
        
        // Special case for pointers
        if (*c == '^') {
            // Skip pointers to pointers (^^^)
            while (*c && *c == _C_PTR) {
                c++;
            }
            
            // Skip type, special case for structure
            if (*c == '{') {
                int    openedBracesCount2 = 1;
                int closedBracesCount2 = 0;
                c++;
                
                for (; *c && closedBracesCount2 != openedBracesCount2; c++) {
                    if (*c == '{') {
                        openedBracesCount2++;
                    }
                    
                    if (*c == '}') {
                        closedBracesCount2++;
                    }
                }
                c--;
            }
        }
    }
    
    if (count) {
        *count = c-c0;
    }
    
    if (closedBracesCount != openedBracesCount) {
        NSLog(@"Could not parse structure type encodings for %@", structureTypeEncoding);
        return nil;
    }
    
    return types;
}


#pragma mark -
#pragma mark JSValue Type Conversion

+ (BOOL)fromJSValue:(JSValueRef)value inContext:(JSContextRef)ctx typeEncoding:(char)typeEncoding fullTypeEncoding:(NSString *)fullTypeEncoding storage:(void *)ptr {
    if (!typeEncoding) {
        return NO;
    }
    
    if (ptr == NULL) {
        return NO;
    }
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    switch (typeEncoding) {
        case _C_ID:
        case _C_CLASS: {
            id __autoreleasing object = [runtime objectForJSValue:value];
            *(void**)ptr = (__bridge void *)object;
            return YES;
        }
        case _C_PTR: {
            id __autoreleasing object = [runtime objectForJSValue:value];
            if ([object isKindOfClass:[MOPointerValue class]]) {
                *(void**)ptr = [object pointerValue];
            }
            else if ([object isKindOfClass:[MOStruct class]]) {
                JSObjectRef object = JSValueToObject(ctx, value, NULL);
                NSString *type = [MOFunctionArgument structureFullTypeEncodingFromStructureTypeEncoding:[fullTypeEncoding substringFromIndex:1]];
                
                NSInteger numParsed = [MOFunctionArgument structureFromJSObject:object inContext:ctx inParentJSValueRef:NULL cString:(char *)[type UTF8String] storage:&ptr];
                return numParsed;
            }
            else {
                *(void**)ptr = (__bridge void *)object;
            }
            return YES;
        }
        case _C_CHR:
        case _C_UCHR:
        case _C_SHT:
        case _C_USHT:
        case _C_INT:
        case _C_UINT:
        case _C_LNG:
        case _C_ULNG:
        case _C_LNG_LNG:
        case _C_ULNG_LNG:
        case _C_FLT:
        case _C_DBL: {
            double number = JSValueToNumber(ctx, value, NULL);
            
            switch (typeEncoding) {
                case _C_CHR:        *(char*)ptr = (char)number; break;
                case _C_UCHR:       *(unsigned char*)ptr = (unsigned char)number; break;
                case _C_SHT:        *(short*)ptr = (short)number; break;
                case _C_USHT:       *(unsigned short*)ptr = (unsigned short)number; break;
                case _C_INT:
                case _C_UINT: {
#ifdef __BIG_ENDIAN__
                    // Two step conversion : to unsigned int then to int. One step conversion fails on PPC.
                    unsigned int uint = (unsigned int)number;
                    *(signed int*)ptr = (signed int)uint;
                    break;
#endif
#ifdef __LITTLE_ENDIAN__
                    *(int*)ptr = (int)number;
                    break;
#endif
                }
                case _C_LNG:        *(long*)ptr = (long)number; break;
                case _C_ULNG:       *(unsigned long*)ptr = (unsigned long)number; break;
                case _C_LNG_LNG:    *(long long*)ptr = (long long)number; break;
                case _C_ULNG_LNG:   *(unsigned long long*)ptr = (unsigned long long)number; break;
                case _C_FLT:        *(float*)ptr = (float)number; break;
                case _C_DBL:        *(double*)ptr = (double)number; break;
            }
            return YES;
        }
        case _C_STRUCT_B: {
            if (!JSValueIsObject(ctx, value)) {
                return NO;
            }
            
            JSObjectRef object = JSValueToObject(ctx, value, NULL);
            NSString *type = [MOFunctionArgument structureFullTypeEncodingFromStructureTypeEncoding:fullTypeEncoding];
            
            NSInteger numParsed = [MOFunctionArgument structureFromJSObject:object inContext:ctx inParentJSValueRef:NULL cString:(char*)[type UTF8String] storage:&ptr];
            return (numParsed > 0);
        }
        case _C_SEL: {
            NSString *str = MOJSValueToString(ctx, value, NULL);
            *(SEL*)ptr = NSSelectorFromString(str);
            return YES;
        }
        case _C_CHARPTR: {
            NSString *str = MOJSValueToString(ctx, value, NULL);
            *(char**)ptr = (char*)[str UTF8String];
            return YES;
        }
        case _C_BOOL: {
            bool b = JSValueToBoolean(ctx, value);
            *(bool*)ptr = b;
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)toJSValue:(JSValueRef *)value inContext:(JSContextRef)ctx typeEncoding:(char)typeEncoding fullTypeEncoding:(NSString *)fullTypeEncoding storage:(void *)ptr {
    if (!typeEncoding) {
        return NO;
    }
    
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    switch (typeEncoding) {
        case _C_ID:    
        case _C_CLASS: {
            id __autoreleasing object = (__bridge id)(*(void**)ptr);
            *value = [runtime JSValueForObject:object];
            return YES;
        }
        case _C_PTR: {
            void* pointer = *(void**)ptr;
            MOPointerValue *object = [[MOPointerValue alloc] initWithPointerValue:pointer typeEncoding:fullTypeEncoding];
            *value = [runtime JSValueForObject:object];
            return YES;
        }
        case _C_VOID: {
            return YES;
        }
        case _C_CHR:
        case _C_UCHR:
        case _C_SHT:
        case _C_USHT:
        case _C_INT:
        case _C_UINT:
        case _C_LNG:
        case _C_ULNG:
        case _C_LNG_LNG:
        case _C_ULNG_LNG:
        case _C_FLT:
        case _C_DBL: {
            double number;
            switch (typeEncoding) {
                case _C_CHR:        number = *(char*)ptr; break;
                case _C_UCHR:       number = *(unsigned char*)ptr; break;
                case _C_SHT:        number = *(short*)ptr; break;
                case _C_USHT:       number = *(unsigned short*)ptr; break;
                case _C_INT:        number = *(int*)ptr; break;
                case _C_UINT:       number = *(unsigned int*)ptr; break;
                case _C_LNG:        number = *(long*)ptr; break;
                case _C_ULNG:       number = *(unsigned long*)ptr; break;
                case _C_LNG_LNG:    number = *(long long*)ptr; break;
                case _C_ULNG_LNG:   number = *(unsigned long long*)ptr; break;
                case _C_FLT:        number = *(float*)ptr; break;
                case _C_DBL:        number = *(double*)ptr; break;
            }
            *value = JSValueMakeNumber(ctx, number);
            return YES;
        }
        case _C_STRUCT_B: {
            void *p = ptr;
            NSString *type = [MOFunctionArgument structureFullTypeEncodingFromStructureTypeEncoding:fullTypeEncoding];
            if (type == nil) {
                return NO;
            }
            
            NSInteger numParsed = [MOFunctionArgument structureToJSValue:value inContext:ctx cString:(char *)[type UTF8String] storage:&p];
            return (numParsed > 0);
        }
        case _C_SEL: {
            SEL sel = *(SEL*)ptr;
            id str = NSStringFromSelector(sel);
            JSStringRef    jsName = JSStringCreateWithCFString((__bridge CFStringRef)str);
            *value = JSValueMakeString(ctx, jsName);
            JSStringRelease(jsName);
            return YES;
        }
        case _C_BOOL: {
            BOOL b = *(BOOL*)ptr;
            *value = JSValueMakeBoolean(ctx, b);
            return YES;
        }
        case _C_CHARPTR: {
            // Return JavaScript null if char* is null
            char* charPtr = *(char**)ptr;
            if (charPtr == NULL) {
                *value = JSValueMakeNull(ctx);
                return YES;
            }
            
            // Convert to NSString and then to JavaScript string
            NSString *name = [NSString stringWithUTF8String:charPtr];
            JSStringRef    jsName = JSStringCreateWithCFString((__bridge CFStringRef)name);
            *value = JSValueMakeString(ctx, jsName);
            JSStringRelease(jsName);
            
            return YES;
        }
    }
    
    return NO;
}

+ (NSInteger)structureFromJSObject:(JSObjectRef)object inContext:(JSContextRef)ctx inParentJSValueRef:(JSValueRef)parentValue cString:(char *)c storage:(void **)ptr {
    id structureName = [MOFunctionArgument structureNameFromStructureTypeEncoding:[NSString stringWithUTF8String:c]];
    char *c0 = c;
    
    // Skip '{'
    c += 1;
    
    // Skip '_' if it's there
    if (*c == '_') {
        c++;
    }
    
    // Skip structureName, '='
    c += [structureName length] + 1;
    
    int    openedBracesCount = 1;
    int closedBracesCount = 0;
    for (; *c && closedBracesCount != openedBracesCount; c++) {
        if (*c == '{') {
            openedBracesCount++;
        }
        if (*c == '}') {
            closedBracesCount++;
        }
        
        // Parse name then type
        if (*c == '"') {
            char* c2 = c+1;
            while (c2 && *c2 != '"') {
                c2++;
            }
            
            NSString *propertyName = [[NSString alloc] initWithBytes:c+1 length:(c2-c-1) encoding:NSUTF8StringEncoding];
            c = c2;
            
            // Skip '"'
            c++;
            char encoding = *c;
            
            JSStringRef propertyNameJS = JSStringCreateWithUTF8CString([propertyName UTF8String]);
            JSValueRef valueJS = JSObjectGetProperty(ctx, object, propertyNameJS, NULL);
            JSStringRelease(propertyNameJS);
            
            if (encoding == '{') {
                if (JSValueIsObject(ctx, valueJS)) {
                    JSObjectRef objectProperty = JSValueToObject(ctx, valueJS, NULL);
                    NSInteger numParsed = [self structureFromJSObject:objectProperty inContext:ctx inParentJSValueRef:NULL cString:c storage:ptr];
                    c += numParsed;
                }
                else {
                    return 0;
                }
            }
            else {
                // Align 
                [MOFunctionArgument alignPtr:ptr accordingToEncoding:encoding];
                // Get value
                [MOFunctionArgument fromJSValue:valueJS inContext:ctx typeEncoding:encoding fullTypeEncoding:nil storage:*ptr];
                // Advance ptr
                [MOFunctionArgument advancePtr:ptr accordingToEncoding:encoding];
            }
        }
    }
    return c - c0 - 1;
}

+ (NSInteger)structureToJSValue:(JSValueRef *)value inContext:(JSContextRef)ctx cString:(char *)c storage:(void **)ptr {
    return [self structureToJSValue:value inContext:ctx cString:c storage:ptr initialValues:nil initialValueCount:0 convertedValueCount:nil];
}

+ (NSInteger)structureToJSValue:(JSValueRef *)value inContext:(JSContextRef)ctx cString:(char *)c storage:(void **)ptr initialValues:(JSValueRef *)initialValues initialValueCount:(NSInteger)initialValueCount convertedValueCount:(NSInteger *)convertedValueCount {
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    NSString *structureName = [MOFunctionArgument structureNameFromStructureTypeEncoding:[NSString stringWithUTF8String:c]];
    
    NSMutableArray *memberNames = [NSMutableArray array];
    NSMutableDictionary *memberValues = [NSMutableDictionary dictionary];
    
    char *c0 = c;
    
    // Skip '{'
    c += 1;
    
    // Skip '_' if it's there
    if (*c == '_') {
        c++;
    }
    
    // Skip structureName, '='
    c += [structureName length] + 1;
    
    int    openedBracesCount = 1;
    int closedBracesCount = 0;
    for (; *c && closedBracesCount != openedBracesCount; c++) {
        if (*c == '{') {
            openedBracesCount++;
        }
        if (*c == '}') {
            closedBracesCount++;
        }
        
        // Parse name then type
        if (*c == '"') {
            char* c2 = c+1;
            while (c2 && *c2 != '"') {
                c2++;
            }
            
            NSString *propertyName = [[NSString alloc] initWithBytes:c+1 length:(c2 - c - 1) encoding:NSUTF8StringEncoding];
            c = c2;
            
            // Skip '"'
            c++;
            
            char encoding = *c;
            
            JSValueRef valueJS = NULL;
            if (encoding == _C_STRUCT_B) {
                NSInteger numParsed = [self structureToJSValue:&valueJS inContext:ctx cString:c storage:ptr initialValues:initialValues initialValueCount:initialValueCount convertedValueCount:convertedValueCount];
                c += numParsed;
            }
            else {
                if (ptr != NULL) {
                    // Given a pointer to raw C structure data, convert its members to JS values
                    
                    // Align 
                    [MOFunctionArgument alignPtr:ptr accordingToEncoding:encoding];
                    // Get value
                    [MOFunctionArgument toJSValue:&valueJS inContext:ctx typeEncoding:encoding fullTypeEncoding:nil storage:*ptr];
                    // Advance ptr
                    [MOFunctionArgument advancePtr:ptr accordingToEncoding:encoding];
                }
                else {
                    // Given no pointer, get values from initialValues array. If not present, create undefined values
                    if (!convertedValueCount) {
                        return 0;
                    }
                    
                    if (initialValues && initialValueCount && *convertedValueCount < initialValueCount) {
                        valueJS = initialValues[*convertedValueCount];
                    }
                    else {
                        valueJS = JSValueMakeUndefined(ctx);                                    
                    }
                }
                
                if (convertedValueCount) {
                    *convertedValueCount = *convertedValueCount+1;
                }
            }
            
            id objValue = [runtime objectForJSValue:valueJS];
            [memberNames addObject:propertyName];
            [memberValues setObject:objValue forKey:propertyName];
        }
    }
    
    MOStruct *structure = [MOStruct structureWithName:structureName memberNames:memberNames];
    for (NSString *name in memberNames) {
        id value = [memberValues objectForKey:name];
        [structure setObject:value forMemberName:name];
    }
    
    JSValueRef jsValue = [runtime JSValueForObject:structure];
    JSObjectRef jsObject = JSValueToObject(ctx, jsValue, NULL);
    
    if (!*value) {
        *value = jsObject;
    }
    
    return c - c0 - 1;
}

@end
//
//  MOUtilities.m
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//











#import "MOPointerValue.h"
#import "MOPointer_Private.h"







#import <objc/runtime.h>
#import <objc/message.h>
#import <dlfcn.h>

#if TARGET_OS_IPHONE
#import "ffi.h"
#else
#import <ffi/ffi.h>
#endif


#pragma mark -
#pragma mark Values

JSValueRef MOJSValueToType(JSContextRef ctx, JSObjectRef objectJS, JSType type, JSValueRef *exception) {
    MOBox *box = (__bridge MOBox *)(JSObjectGetPrivate(objectJS));
    if (box != nil) {
        // Boxed object
        id object = [box representedObject];
        
        if ([object isKindOfClass:[NSString class]]) {
            JSStringRef string = JSStringCreateWithCFString((__bridge CFStringRef)object);
            JSValueRef value = JSValueMakeString(ctx, string);
            JSStringRelease(string);
            return value;
        }
        else if ([object isKindOfClass:[NSNumber class]]) {
            double doubleValue = [object doubleValue];
            return JSValueMakeNumber(ctx, doubleValue);
        }
        
        // Convert the object's description to a string as a last ditch effort
        NSString *description = [object description];
        JSStringRef string = JSStringCreateWithCFString((__bridge CFStringRef)description);
        JSValueRef value = JSValueMakeString(ctx, string);
        JSStringRelease(string);
        return value;
    }
    
    return NULL;
}

NSString * MOJSValueToString(JSContextRef ctx, JSValueRef value, JSValueRef *exception) {
    if (value == NULL || JSValueIsNull(ctx, value)) {
        return nil;
    }
    JSStringRef resultStringJS = JSValueToStringCopy(ctx, value, exception);
    NSString *resultString = (NSString *)CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, resultStringJS));
    JSStringRelease(resultStringJS);
    return resultString;
}


#pragma mark -
#pragma mark Invocation

JSValueRef MOSelectorInvoke(id target, SEL selector, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception) {
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    
    NSUInteger methodArgumentCount = [methodSignature numberOfArguments] - 2;
    if (methodArgumentCount != argumentCount) {
        NSString *reason = [NSString stringWithFormat:@"ObjC method %@ requires %lu %@, but JavaScript passed %zd %@", NSStringFromSelector(selector), methodArgumentCount, (methodArgumentCount == 1 ? @"argument" : @"arguments"), argumentCount, (argumentCount == 1 ? @"argument" : @"arguments")];
        NSException *e = [NSException exceptionWithName:MORuntimeException reason:reason userInfo:nil];
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e];
        }
        return NULL;
    }
    
    // Build arguments
    for (size_t i=0; i<argumentCount; i++) {
        JSValueRef argument = arguments[i];
        __unsafe_unretained id object = [runtime objectForJSValue:argument unboxObjects:NO];
        
        NSUInteger argIndex = i + 2;
        const char * argType = [methodSignature getArgumentTypeAtIndex:argIndex];
        
        // MOBox
        if ([object isKindOfClass:[MOBox class]]) {
            __unsafe_unretained id value = [object representedObject];
            [invocation setArgument:&value atIndex:argIndex];
        }
        
        // NSNumber
        else if ([object isKindOfClass:[NSNumber class]]) {
            // long
            if (strcmp(argType, @encode(long)) == 0
                || strcmp(argType, @encode(unsigned long)) == 0) {
                long val = [object longValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // short
            else if (strcmp(argType, @encode(short)) == 0
                     || strcmp(argType, @encode(unsigned short)) == 0) {
                short val = [object shortValue];
                [invocation setArgument:&val atIndex:argIndex];
                
            }
            // char
            else if (strcmp(argType, @encode(char)) == 0
                     || strcmp(argType, @encode(unsigned char)) == 0) {
                char val = [object charValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // long long
            else if (strcmp(argType, @encode(long long)) == 0
                     || strcmp(argType, @encode(unsigned long long)) == 0) {
                long long val = [object longLongValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // float
            else if (strcmp(argType, @encode(float)) == 0) {
                float val = [(NSNumber*)object floatValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // double
            else if (strcmp(argType, @encode(double)) == 0) {
                double val = [object doubleValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // BOOL
            else if (strcmp(argType, @encode(bool)) == 0
                     || strcmp(argType, @encode(_Bool)) == 0) {
                BOOL val = [object boolValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
            // int
            else {
                int val = [object intValue];
                [invocation setArgument:&val atIndex:argIndex];
            }
        }
        // id
        else {
            [invocation setArgument:&object atIndex:argIndex];
        }
    }
    
    
    // Invoke
    [invocation invoke];
    
    
    // Build return value
    const char * returnType = [methodSignature methodReturnType];
    JSValueRef returnValue = NULL;
    
    if (strcmp(returnType, @encode(void)) == 0) {
        returnValue = JSValueMakeUndefined(ctx);
    }
    // id
    else if (strcmp(returnType, @encode(id)) == 0
             || strcmp(returnType, @encode(Class)) == 0) {
        __unsafe_unretained id object = nil;
        [invocation getReturnValue:&object];
        returnValue = [runtime JSValueForObject:object];
    }
    // SEL
    /*else if (strcmp(returnType, @encode(SEL)) == 0) {
        SEL selector = NULL;
        [invocation getReturnValue:&selector];
        
        returnValue = object;
    }*/
    // void *
    else if (strcmp(returnType, @encode(void *)) == 0) {
        void *pointer = NULL;
        [invocation getReturnValue:&pointer];
        
        MOPointerValue * __autoreleasing object = [[MOPointerValue alloc] initWithPointerValue:pointer typeEncoding:nil];
        returnValue = (__bridge void *)object;
    }
    // bool
    else if (strcmp(returnType, @encode(bool)) == 0
             || strcmp(returnType, @encode(_Bool)) == 0) {
        BOOL value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithBool:value]];
    }
    // int
    else if (strcmp(returnType, @encode(int)) == 0
             || strcmp(returnType, @encode(unsigned int)) == 0) {
        int value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithInt:value]];
    }
    // long
    else if (strcmp(returnType, @encode(long)) == 0
             || strcmp(returnType, @encode(unsigned long)) == 0) {
        long value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithLong:value]];
    }
    // long long
    else if (strcmp(returnType, @encode(long long)) == 0
             || strcmp(returnType, @encode(unsigned long long)) == 0) {
        long long value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithLongLong:value]];
    }
    // short
    else if (strcmp(returnType, @encode(short)) == 0
             || strcmp(returnType, @encode(unsigned short)) == 0) {
        short value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithShort:value]];
    }
    // char
    else if (strcmp(returnType, @encode(char)) == 0
             || strcmp(returnType, @encode(unsigned char)) == 0) {
        char value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithChar:value]];
    }
    // float
    else if (strcmp(returnType, @encode(float)) == 0) {
        float value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithFloat:value]];
    }
    // double
    else if (strcmp(returnType, @encode(double)) == 0) {
        double value;
        [invocation getReturnValue:&value];
        returnValue = [runtime JSValueForObject:[NSNumber numberWithDouble:value]];
    }
    
    return returnValue;
}


JSValueRef MOFunctionInvoke(id function, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception) {
    Mocha *runtime = [Mocha runtimeWithContext:ctx];
    
    JSValueRef value = NULL;
    BOOL objCCall = NO;
    BOOL blockCall = NO;
    NSMutableArray *argumentEncodings = nil;
    MOFunctionArgument *returnValue = nil;
    void* callAddress = NULL;
    NSUInteger callAddressArgumentCount = 0;
    BOOL variadic = NO;
    
    id target = nil;
    SEL selector = NULL;
    
    id block = nil;
    
    // Determine the metadata for the function call
    if ([function isKindOfClass:[MOMethod class]]) {
        // ObjC method
        objCCall = YES;
        
        target = [function target];
        selector = [function selector];
        Class klass = [target class];
        
        // Override for Distributed Objects
        if ([klass isSubclassOfClass:[NSDistantObject class]]) {
            return MOSelectorInvoke(target, selector, ctx, argumentCount, arguments, exception);
        }
        
        // Override for Allocators
        if (selector == @selector(alloc)
            || selector == @selector(allocWithZone:))
        {
            // Override for -alloc
            MOAllocator *allocator = [MOAllocator allocator];
            allocator.objectClass = klass;
            return [runtime JSValueForObject:allocator];
        }
        if ([target isKindOfClass:[MOAllocator class]]) {
            klass = [target objectClass];
            target = [[target objectClass] alloc];
        }
        
        Method method = NULL;
        BOOL classMethod = (target == klass);
        
        // Determine the method type
        if (classMethod) {
            method = class_getClassMethod(klass, selector);
        }
        else {
            method = class_getInstanceMethod(klass, selector);
        }
        
        variadic = MOSelectorIsVariadic(klass, selector);
        
        if (method == NULL) {
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to locate method %@ of class %@", NSStringFromSelector(selector), klass] userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e];
            }
            return NULL;
        }
        
        const char *encoding = method_getTypeEncoding(method);
        argumentEncodings = [MOParseObjCMethodEncoding(encoding) mutableCopy];
        
        if (argumentEncodings == nil) {
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to parse method encoding for method %@ of class %@", NSStringFromSelector(selector), klass] userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e];
            }
            return NULL;
        }
        
        // Function arguments are all arguments minus return value and [instance, selector] params to objc_send
        callAddressArgumentCount = [argumentEncodings count] - 3;
        
        // Get call address
        callAddress = MOInvocationGetObjCCallAddressForArguments(argumentEncodings);
        
        if (variadic) {
            if (argumentCount > 0) {
                // add an argument for NULL
                argumentCount++;
            }
        }
        
        if ((variadic && (callAddressArgumentCount > argumentCount))
            || (!variadic && (callAddressArgumentCount != argumentCount)))
        {
            NSString *reason = [NSString stringWithFormat:@"ObjC method %@ requires %lu %@, but JavaScript passed %zd %@", NSStringFromSelector(selector), callAddressArgumentCount, (callAddressArgumentCount == 1 ? @"argument" : @"arguments"), argumentCount, (argumentCount == 1 ? @"argument" : @"arguments")];
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:reason userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e];
            }
            return NULL;
        }
    }
    else if ([function isKindOfClass:[MOClosure class]]) {
        // C block
        blockCall = YES;
        
        block = [function block];
        
        callAddress = [function callAddress];
        
        const char *typeEncoding = [(MOClosure *)function typeEncoding];
        argumentEncodings = [MOParseObjCMethodEncoding(typeEncoding) mutableCopy];
        
        if (argumentEncodings == nil) {
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to parse method encoding for method %@ of class %@", NSStringFromSelector(selector), [target class]] userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e];
            }
            return NULL;
        }
        
        callAddressArgumentCount = [argumentEncodings count] - 2;
        
        if (callAddressArgumentCount != argumentCount) {
            NSString *reason = [NSString stringWithFormat:@"Block requires %lu %@, but JavaScript passed %zd %@", callAddressArgumentCount, (callAddressArgumentCount == 1 ? @"argument" : @"arguments"), argumentCount, (argumentCount == 1 ? @"argument" : @"arguments")];
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:reason userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e];
            }
            return NULL;
        }
    }
    else if ([function isKindOfClass:[MOBridgeSupportFunction class]]) {
        // C function
        
        NSString *functionName = [function name];
        
        callAddress = dlsym(RTLD_DEFAULT, [functionName UTF8String]);
        
        // If the function cannot be found, raise an exception (instead of crashing)
        if (callAddress == NULL) {
            if (exception != NULL) {
                NSException *e = [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to find function with name: %@", functionName] userInfo:nil];
                *exception = [runtime JSValueForObject:e];
            }
            return NULL;
        }
        
        variadic = [function isVariadic];
        
        NSMutableArray *args = [NSMutableArray array];
        
        // Build return type
        MOBridgeSupportArgument *returnValue = [function returnValue];
        MOFunctionArgument *returnArg = nil;
        if (returnValue != nil) {
            NSString *returnTypeEncoding = nil;
#if __LP64__
            returnTypeEncoding = [returnValue type64];
            if (returnTypeEncoding == nil) {
                returnTypeEncoding = [returnValue type];
            }
#else
            returnTypeEncoding = [returnValue type];
#endif
            returnArg = MOFunctionArgumentForTypeEncoding(returnTypeEncoding);
        }
        else {
            // void return
            returnArg = [[MOFunctionArgument alloc] init];
            [returnArg setTypeEncoding:_C_VOID];
        }
        [returnArg setReturnValue:YES];
        [args addObject:returnArg];
        
        // Build arguments
        for (MOBridgeSupportArgument *argument in [function arguments]) {
            NSString *typeEncoding = nil;
#if __LP64__
            typeEncoding = [argument type64];
            if (typeEncoding == nil) {
                typeEncoding = [argument type];
            }
#else
            typeEncoding = [argument type];
#endif
            
            MOFunctionArgument *arg = MOFunctionArgumentForTypeEncoding(typeEncoding);
            [args addObject:arg];
        }
        
        argumentEncodings = [args mutableCopy];
        
        // Function arguments are all arguments minus return value
        callAddressArgumentCount = [args count] - 1;
        
        // Raise if the argument counts don't match
        if ((variadic && (callAddressArgumentCount > argumentCount))
            || (!variadic && (callAddressArgumentCount != argumentCount)))
        {
            NSString *reason = [NSString stringWithFormat:@"C function %@ requires %lu %@, but JavaScript passed %zd %@", functionName, callAddressArgumentCount, (callAddressArgumentCount == 1 ? @"argument" : @"arguments"), argumentCount, (argumentCount == 1 ? @"argument" : @"arguments")];
            NSException *e = [NSException exceptionWithName:MORuntimeException reason:reason userInfo:nil];
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e];
            }
            return NULL;
        }
    }
    
    
    // Prepare ffi
    ffi_cif cif;
    ffi_type** args = NULL;
    void** values = NULL;
    
    // Build the arguments
    NSUInteger effectiveArgumentCount = argumentCount;
    if (objCCall) {
        effectiveArgumentCount += 2;
    }
    if (blockCall) {
        effectiveArgumentCount += 1;
    }
    
    if (effectiveArgumentCount > 0) {
        args = malloc(sizeof(ffi_type *) * effectiveArgumentCount);
        values = malloc(sizeof(void *) * effectiveArgumentCount);
        
        NSUInteger j = 0;
        
        if (objCCall) {
            // ObjC calls include the target and selector as the first two arguments
            args[0] = &ffi_type_pointer;
            args[1] = &ffi_type_pointer;
            values[0] = (void *)&target;
            values[1] = (void *)&selector;
            j = 2;
        }
        else if (blockCall) {
            // Block calls include the block as the first argument
            args[0] = &ffi_type_pointer;
            values[0] = (void *)&block;
            j = 1;
        }
        
        for (NSUInteger i=0; i<argumentCount; i++, j++) {
            JSValueRef jsValue = NULL;
            
            MOFunctionArgument *arg = nil;
            if (variadic && i >= callAddressArgumentCount) {
                arg = [[MOFunctionArgument alloc] init];
                [arg setTypeEncoding:_C_ID];
                [argumentEncodings addObject:arg];
            }
            else {
                arg = [argumentEncodings objectAtIndex:(j + 1)];
            }
            
            if (objCCall && variadic && i == argumentCount - 1) {
                // The last variadic argument in ObjC calls is nil (the sentinel value)
                jsValue = NULL;
            }
            else {
                jsValue = arguments[i];
            }
            
            if (jsValue != NULL) {
                id object = [runtime objectForJSValue:jsValue];
                
                // Handle pointers
                if ([object isKindOfClass:[MOPointer class]]) {
                    [arg setPointer:object];
                    
                    id objValue = [(MOPointer *)object value];
                    JSValueRef jsValue = [runtime JSValueForObject:objValue];
                    [arg setValueAsJSValue:jsValue context:ctx dereference:YES];
                }
                else {
                    [arg setValueAsJSValue:jsValue context:ctx];
                }
            }
            else {
                [arg setValueAsJSValue:NULL context:ctx];
            }
            
            args[j] = [arg ffiType];
            values[j] = [arg storage];
        }
    }
    
    // Get return value holder
    returnValue = [argumentEncodings objectAtIndex:0];
    
    // Prep
    ffi_status prep_status = ffi_prep_cif(&cif, FFI_DEFAULT_ABI, (unsigned int)effectiveArgumentCount, [returnValue ffiType], args);
    
    // Call
    if (prep_status == FFI_OK) {
        void *storage = [returnValue storage];
        
        @try {
            ffi_call(&cif, callAddress, storage, values);
        }
        @catch (NSException *e) {
            if (effectiveArgumentCount > 0) {
                free(args);
                free(values);
            }
            if (exception != NULL) {
                *exception = [runtime JSValueForObject:e];
            }
            return NULL;
        }
    }
    
    // Free the arguments
    if (effectiveArgumentCount > 0) {
        free(args);
        free(values);
    }
    
    // Throw an exception if the prep call failed
    if (prep_status != FFI_OK) {
        NSException *e = [NSException exceptionWithName:MORuntimeException reason:@"ffi_prep_cif failed" userInfo:nil];
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e];
        }
        return NULL;
    }
    
    // Populate the value of pointers
    for (MOFunctionArgument *arg in argumentEncodings) {
        if ([arg pointer] != nil) {
            MOPointer *pointer = [arg pointer];
            JSValueRef value = [arg getValueAsJSValueInContext:ctx dereference:YES];
            id object = [runtime objectForJSValue:value];
            pointer.value = object;
        }
    }
    
    // If the return type is void, the return value should be undefined
    if ([returnValue ffiType] == &ffi_type_void) {
        return JSValueMakeUndefined(ctx);
    }
    
    @try {
        value = [returnValue getValueAsJSValueInContext:ctx];
    }
    @catch (NSException *e) {
        if (exception != NULL) {
            *exception = [runtime JSValueForObject:e];
        }
        return NULL;
    }
    
    return value;
}

BOOL MOSelectorIsVariadic(Class klass, SEL selector) {
    NSString *className = [NSString stringWithUTF8String:class_getName(klass)];
    
    while (klass != Nil) {
        MOBridgeSupportClass *classSymbol = [[MOBridgeSupportController sharedController] performQueryForSymbolName:className ofType:[MOBridgeSupportClass class]];
        if (classSymbol == nil) {
            klass = [klass superclass];
            continue;
        }
        
        MOBridgeSupportMethod *methodSymbol = [classSymbol methodWithSelector:selector];
        if (methodSymbol != nil) {
            return [methodSymbol isVariadic];
        }
        
        klass = [klass superclass];
    }
    
    return NO;
}

MOFunctionArgument * MOFunctionArgumentForTypeEncoding(NSString *typeEncoding) {
    MOFunctionArgument *argument = [[MOFunctionArgument alloc] init];
    
    char typeEncodingChar = [typeEncoding UTF8String][0];
    
    if (typeEncodingChar == _C_STRUCT_B) {
        [argument setStructureTypeEncoding:typeEncoding];
    }
    else if (typeEncodingChar == _C_PTR) {
        if ([typeEncoding isEqualToString:@"^{__CFString=}"]) {
            [argument setTypeEncoding:_C_ID];
        }
        else {
            [argument setPointerTypeEncoding:typeEncoding];
        }
    }
    else {
        [argument setTypeEncoding:typeEncodingChar];
    }
    
    return argument;
}

NSArray * MOParseObjCMethodEncoding(const char *typeEncoding) {
    NSMutableArray *argumentEncodings = [NSMutableArray array];
    char *argsParser = (char *)typeEncoding;
    
    for(; *argsParser; argsParser++) {
        // Skip ObjC argument order
        if (*argsParser >= '0' && *argsParser <= '9') {
            continue;
        }
        else {
            // Skip ObjC type qualifiers - except for _C_CONST these are not defined in runtime.h
            if (*argsParser == _C_CONST ||
                *argsParser == 'n' ||
                *argsParser == 'N' || 
                *argsParser == 'o' ||
                *argsParser == 'O' ||
                *argsParser == 'R' ||
                *argsParser == 'V') {
                continue;
            }
            else {
                if (*argsParser == _C_STRUCT_B) {
                    // Parse structure encoding
                    NSInteger count = 0;
                    [MOFunctionArgument typeEncodingsFromStructureTypeEncoding:[NSString stringWithUTF8String:argsParser] parsedCount:&count];
                    
                    NSString *encoding = [[NSString alloc] initWithBytes:argsParser length:count encoding:NSUTF8StringEncoding];
                    MOFunctionArgument *argumentEncoding = [[MOFunctionArgument alloc] init];
                    
                    // Set return value
                    if ([argumentEncodings count] == 0) {
                        [argumentEncoding setReturnValue:YES];
                    }
                    
                    [argumentEncoding setStructureTypeEncoding:encoding];
                    [argumentEncodings addObject:argumentEncoding];
                    
                    argsParser += count - 1;
                }
                else {
                    // Custom handling for pointers as they're not one char long.
                    char* typeStart = argsParser;
                    if (*argsParser == '^') {
                        while (*argsParser && !(*argsParser >= '0' && *argsParser <= '9')) {
                            argsParser++;
                        }
                    }
                    
                    MOFunctionArgument *argumentEncoding = [[MOFunctionArgument alloc] init];
                    
                    // Set return value
                    if ([argumentEncodings count] == 0) {
                        [argumentEncoding setReturnValue:YES];
                    }
                    
                    // If pointer, copy pointer type (^i, ^{NSRect}) to the argumentEncoding
                    if (*typeStart == _C_PTR) {
                        NSString *encoding = [[NSString alloc] initWithBytes:typeStart length:(argsParser - typeStart) encoding:NSUTF8StringEncoding];
                        [argumentEncoding setPointerTypeEncoding:encoding];
                    }
                    else {
                        @try {
                            [argumentEncoding setTypeEncoding:*typeStart];
                        }
                        @catch (NSException *e) {
                            return nil;
                        }
                        
                        // Blocks are '@?', skip '?'
                        if (typeStart[0] == _C_ID && typeStart[1] == _C_UNDEF) {
                            argsParser++;
                        }
                    }
                    
                    [argumentEncodings addObject:argumentEncoding];
                }
            }
        }
        
        if (!*argsParser) {
            break;
        }
    }
    return argumentEncodings;
}


//
// From PyObjC : when to call objc_msgSend_stret, for structure return
// Depending on structure size & architecture, structures are returned as function first argument (done transparently by ffi) or via registers
//

#if defined(__ppc__)
#   define SMALL_STRUCT_LIMIT    4
#elif defined(__ppc64__)
#   define SMALL_STRUCT_LIMIT    8
#elif defined(__i386__) 
#   define SMALL_STRUCT_LIMIT     8
#elif defined(__x86_64__) 
#   define SMALL_STRUCT_LIMIT    16
#elif TARGET_OS_IPHONE
// TOCHECK
#   define SMALL_STRUCT_LIMIT    4
#else
#   error "Unsupported MACOSX platform"
#endif

BOOL MOInvocationShouldUseStret(NSArray *arguments) {
    size_t resultSize = 0;
    char returnEncoding = [(MOFunctionArgument *)[arguments objectAtIndex:0] typeEncoding];
    if (returnEncoding == _C_STRUCT_B) {
        resultSize = [MOFunctionArgument sizeOfStructureTypeEncoding:[[arguments objectAtIndex:0] structureTypeEncoding]];
    }
    
    if (returnEncoding == _C_STRUCT_B && 
        //#ifdef  __ppc64__
        //            ffi64_stret_needs_ptr(signature_to_ffi_return_type(rettype), NULL, NULL)
        //
        //#else /* !__ppc64__ */
        (resultSize > SMALL_STRUCT_LIMIT
#ifdef __i386__
         /* darwin/x86 ABI is slightly odd ;-) */
         || (resultSize != 1 
             && resultSize != 2 
             && resultSize != 4 
             && resultSize != 8)
#endif
#ifdef __x86_64__
         /* darwin/x86-64 ABI is slightly odd ;-) */
         || (resultSize != 1 
             && resultSize != 2 
             && resultSize != 4 
             && resultSize != 8
             && resultSize != 16
             )
#endif
         )
        //#endif /* !__ppc64__ */
        ) {
        //                    callAddress = objc_msgSend_stret;
        //                    usingStret = YES;
        return YES;
    }
    return NO;
}

void * MOInvocationGetObjCCallAddressForArguments(NSArray *arguments) {
    BOOL usingStret    = MOInvocationShouldUseStret(arguments);
    void *callAddress = NULL;
    if (usingStret)    {
        callAddress = objc_msgSend_stret;
    }
    else {
        callAddress = objc_msgSend;
    }
    
#if __i386__
    // If i386 and the return type is float/double, use objc_msgSend_fpret
    // ARM and x86_64 use the standard objc_msgSend
    char returnEncoding = [[arguments objectAtIndex:0] typeEncoding];
    if (returnEncoding == 'f' || returnEncoding == 'd') {
        callAddress = objc_msgSend_fpret;
    }
#endif
    
    return callAddress;
}


#pragma mark -
#pragma mark Selectors

SEL MOSelectorFromPropertyName(NSString *propertyName) {
    NSString *selectorString = [propertyName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
    SEL selector = NSSelectorFromString(selectorString);
    return selector;
}

NSString * MOSelectorToPropertyName(SEL selector) {
    NSString *selectorString = NSStringFromSelector(selector);
    NSString *propertyString = [selectorString stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    return propertyString;
}

NSString * MOPropertyNameToSetterName(NSString *propertyName) {
    if ([propertyName length] > 0) {
        // Capitalize first character and append "set" and "_"
        // title -> setTitle_
        NSString *capitalizedName = [NSString stringWithFormat:@"%@%@", [[propertyName substringToIndex:1] capitalizedString], [propertyName substringFromIndex:1]];
        return [[@"set" stringByAppendingString:capitalizedName] stringByAppendingString:@"_"];
    }
    else {
        return nil;
    }
}


#pragma mark -
#pragma mark Blocks

typedef id (^MOJavaScriptClosureBlock)(id obj, ...);

id MOGetBlockForJavaScriptFunction(MOJavaScriptObject *function, NSUInteger *argCount) {
    JSObjectRef jsFunction = [function JSObject];
    JSContextRef ctx = [function JSContext];
    
    if (argCount != NULL) {
        JSStringRef lengthString = JSStringCreateWithCFString(CFSTR("length"));
        JSValueRef value = JSObjectGetProperty(ctx, jsFunction, lengthString, NULL);
        JSStringRelease(lengthString);
        
        *argCount = (NSUInteger)JSValueToNumber(ctx, value, NULL);
    }
    
    MOJavaScriptClosureBlock newBlock = (id)^(id obj, ...) {
        // JavaScript functions
        JSObjectRef jsFunction = [function JSObject];
        JSContextRef ctx = [function JSContext];
        Mocha *runtime = [Mocha runtimeWithContext:ctx];
        
        JSStringRef lengthString = JSStringCreateWithCFString(CFSTR("length"));
        JSValueRef value = JSObjectGetProperty(ctx, jsFunction, lengthString, NULL);
        JSStringRelease(lengthString);
        
        NSUInteger argCount = (NSUInteger)JSValueToNumber(ctx, value, NULL);
        
        JSValueRef exception = NULL;
        
        va_list args;
        va_start(args, obj);
        
        id arg = obj;
        JSValueRef jsValue = [runtime JSValueForObject:obj];
        JSObjectRef jsObject = JSValueToObject(ctx, jsValue, &exception);
        if (jsObject == NULL) {
            [runtime throwJSException:exception];
            return nil;
        }
        
        JSValueRef *jsArguments = (JSValueRef *)malloc(sizeof(JSValueRef) * (argCount - 1));
        
        // Handle passed arguments
        for (NSUInteger i=0; i<argCount; i++) {
            arg = va_arg(args, id);
            jsArguments[i] = [runtime JSValueForObject:arg];
        }
        
        va_end(args);
        
        JSValueRef jsReturnValue = JSObjectCallAsFunction(ctx, jsFunction, jsObject, argCount, jsArguments, &exception);
        id returnValue = [runtime objectForJSValue:jsReturnValue];
        
        if (jsArguments != NULL) {
            free(jsArguments);
        }
        
        if (exception != NULL) {
            [runtime throwJSException:exception];
            return nil;
        }
        
        return (__bridge void*)returnValue;
    };
    return [newBlock copy];
}
//
//  MOPointer.m
//  Mocha
//
//  Created by Logan Collins on 7/31/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//


#import "MOPointer_Private.h"


@implementation MOPointer

@synthesize value=_value;

- (id)initWithValue:(id)value {
    self = [super init];
    if (self) {
        self.value = value;
    }
    return self;
}

@end
//
//  MOAllocator.m
//  Mocha
//
//  Created by Logan Collins on 7/25/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//




@implementation MOAllocator

@synthesize objectClass=_objectClass;

+ (MOAllocator *)allocator {
    return [[self alloc] init];
}

@end
//
//  MOMapTable.m
//  Mocha
//
//  Created by Logan Collins on 8/6/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//



//
// Note: This file must be compiled with the -fno-objc-arc compiler setting.
//


static const void * MOObjectRetain(CFAllocatorRef allocator, const void * value) {
    return (const void *)[(id)value retain];
}

static void MOObjectRelease(CFAllocatorRef allocator, const void * value) {
    [(id)value release];
}

static CFStringRef MOObjectCopyDescription(const void * value) {
    return (CFStringRef)[[(id)value description] copy];
}

static Boolean MOObjectEqual(const void * value1, const void * value2) {
    return (Boolean)[(id)value1 isEqual:(id)value2];
}

static CFHashCode MOObjectHash(const void * value) {
    return (CFHashCode)[(id)value hash];
}


@implementation MOMapTable

+ (MOMapTable *)mapTableWithStrongToStrongObjects {
    CFDictionaryKeyCallBacks keyCallBacks = { 0, MOObjectRetain, MOObjectRelease, MOObjectCopyDescription, MOObjectEqual, MOObjectHash };
    CFDictionaryValueCallBacks valueCallBacks = { 0, MOObjectRetain, MOObjectRelease, MOObjectCopyDescription, MOObjectEqual };
    CFMutableDictionaryRef dictionary = CFDictionaryCreateMutable(NULL, 0, &keyCallBacks, &valueCallBacks);
    MOMapTable *mapTable = [[self alloc] initWithOwnedDictionary:dictionary];
	return [mapTable autorelease];
}

+ (MOMapTable *)mapTableWithStrongToUnretainedObjects {
    CFDictionaryKeyCallBacks keyCallBacks = { 0, MOObjectRetain, MOObjectRelease, MOObjectCopyDescription, MOObjectEqual, MOObjectHash };
    CFDictionaryValueCallBacks valueCallBacks = { 0, NULL, NULL, MOObjectCopyDescription, MOObjectEqual };
    CFMutableDictionaryRef dictionary = CFDictionaryCreateMutable(NULL, 0, &keyCallBacks, &valueCallBacks);
    MOMapTable *mapTable = [[self alloc] initWithOwnedDictionary:dictionary];
	return [mapTable autorelease];
}

+ (MOMapTable *)mapTableWithUnretainedToStrongObjects {
    CFDictionaryKeyCallBacks keyCallBacks = { 0, NULL, NULL, MOObjectCopyDescription, MOObjectEqual, MOObjectHash };
    CFDictionaryValueCallBacks valueCallBacks = { 0, MOObjectRetain, MOObjectRelease, MOObjectCopyDescription, MOObjectEqual };
    CFMutableDictionaryRef dictionary = CFDictionaryCreateMutable(NULL, 0, &keyCallBacks, &valueCallBacks);
    MOMapTable *mapTable = [[self alloc] initWithOwnedDictionary:dictionary];
	return [mapTable autorelease];
}

+ (MOMapTable *)mapTableWithUnretainedToUnretainedObjects {
    CFDictionaryKeyCallBacks keyCallBacks = { 0, NULL, NULL, MOObjectCopyDescription, MOObjectEqual, MOObjectHash };
    CFDictionaryValueCallBacks valueCallBacks = { 0, NULL, NULL, MOObjectCopyDescription, MOObjectEqual };
    CFMutableDictionaryRef dictionary = CFDictionaryCreateMutable(NULL, 0, &keyCallBacks, &valueCallBacks);
    MOMapTable *mapTable = [[self alloc] initWithOwnedDictionary:dictionary];
	return [mapTable autorelease];
}

- (id)initWithOwnedDictionary:(CFMutableDictionaryRef)dictionary {
    self = [super init];
    if (self) {
        _dictionary = dictionary;
    }
    return self;
}

- (void)dealloc {
    CFRelease(_dictionary);
    [super dealloc];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [(NSMutableDictionary *)_dictionary countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSEnumerator *)keyEnumerator {
    return [(NSMutableDictionary *)_dictionary keyEnumerator];
}

- (NSEnumerator *)objectEnumerator {
    return [(NSMutableDictionary *)_dictionary objectEnumerator];
}

- (NSUInteger)count {
    return CFDictionaryGetCount(_dictionary);
}

- (NSArray *)allKeys {
    return [(NSMutableDictionary *)_dictionary allKeys];
}

- (NSArray *)allObjects {
    return [(NSMutableDictionary *)_dictionary allValues];
}

- (id)objectForKey:(id)key {
    return (id)CFDictionaryGetValue(_dictionary, (const void *)key);
}

- (void)setObject:(id)value forKey:(id)key {
    if (value == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Value cannot be nil" userInfo:nil];
    }
    if (key == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Key cannot be nil" userInfo:nil];
    }
    CFDictionarySetValue(_dictionary, (const void *)key, (const void *)value);
}

- (void)removeObjectForKey:(id)key {
    if (key == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Key cannot be nil" userInfo:nil];
    }
    CFDictionaryRemoveValue(_dictionary, (const void *)key);
}

- (void)removeAllObjects {
    CFDictionaryRemoveAllValues(_dictionary);
}

@end
//
//  JSTExtras.m
//  jsenabler
//
//  Created by August Mueller on 1/15/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//


#import "JSTalk.h"
#import <ScriptingBridge/ScriptingBridge.h>

@implementation JSTalk (JSTExtras)

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

@implementation NSApplication (JSTExtras)

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


//
//  JSTListener.m
//  jstalk
//
//  Created by August Mueller on 1/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//



@interface JSTListener (Private)
- (void)setupListener;
@end


@implementation JSTListener

@synthesize rootObject=_rootObject;

+ (id)sharedListener {
    static JSTListener *me = nil;
    if (!me) {
        me = [[JSTListener alloc] init];
    }
    
    return me;
}

+ (void)listen {
    [[self sharedListener] setupListener];
}

+ (void)listenWithRootObject:(id)rootObject; {
    ((JSTListener*)[self sharedListener]).rootObject = rootObject;
    [self listen];
}


- (void)setupListener {
    NSString *myBundleId    = [[NSBundle mainBundle] bundleIdentifier];
    NSString *port          = [NSString stringWithFormat:@"%@.JSTalk", myBundleId];
    
    _conn = [[NSConnection alloc] init];
    // Pick your poision:
    // "Without Independent Conversation Queueing, your app will be re-entered during upon a 2nd remote DO call if you return to the run loop"
    // http://www.mac-developer-network.com/shows/podcasts/lnc/lnc020/
    // "Because independent conversation queueing causes remote messages to block where they normally do not, it can cause deadlock to occur between applications."
    // http://developer.apple.com/documentation/Cocoa/Conceptual/DistrObjects/Tasks/configuring.html#//apple_ref/doc/uid/20000766
    // We'll go with ICQ for now.
    [_conn setIndependentConversationQueueing:YES]; 
    [_conn setRootObject:_rootObject ? _rootObject : NSApp];
    
    if ([_conn registerName:port]) {
        //NSLog(@"JSTalk listening on port %@", port);
    }
    else {
        NSLog(@"JSTalk could not listen on port %@", port);
        _conn = nil;
    }
}

@end
//
//  JSTPreprocessor.m
//  jstalk
//
//  Created by August Mueller on 2/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//







@implementation JSTPreprocessor

+ (NSString*)processMultilineStrings:(NSString*)sourceString {
    
    NSString *tok = @"\"\"\"";
    
    NSScanner *scanner = [NSScanner scannerWithString:sourceString];
    
    // we don't want to skip any whitespace at the front, so we give it an empty character set.
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
    
    NSMutableString *ret = [NSMutableString string];
    
    while (![scanner isAtEnd]) {
        
        NSString *into;
        NSString *quot;
        
        if ([scanner scanUpToString:tok intoString:&into]) {
            [ret appendString:into];
        }
        
        if ([scanner scanString:tok intoString:nil]) {
            if ([scanner scanString:tok intoString:nil]) {
                continue;
            }
            else if ([scanner scanUpToString:tok intoString:&quot] && [scanner scanString:tok intoString: nil]) {
                
                quot = [quot stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
                quot = [quot stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
                
                [ret appendString:@"\""];
                
                NSArray *lines = [quot componentsSeparatedByString:@"\n"];
                int i = 0;
                while (i < [lines count] - 1) {
                    NSString *line = [lines objectAtIndex:i];
                    line = [line stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                    [ret appendFormat:@"%@\\n", line];
                    i++;
                }
                
                NSString *line = [lines objectAtIndex:i];
                line = [line stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                [ret appendFormat:@"%@\"", line];
            }
        }
    }
    
    return ret;
}

+ (NSString*)preprocessForObjCStrings:(NSString*)sourceString {
    
    NSMutableString *buffer = [NSMutableString string];
    TDTokenizer *tokenizer  = [TDTokenizer tokenizerWithString:sourceString];
    
    tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
    tokenizer.commentState.reportsCommentTokens = NO;
    
    TDToken *eof                    = [TDToken EOFToken];
    TDToken *tok                    = nil;
    TDToken *nextToken              = nil;
    
    while ((tok = [tokenizer nextToken]) != eof) {
        
        if (tok.isSymbol && [[tok stringValue] isEqualToString:@"@"]) {
            
            // woo, it's special objc stuff.
            
            nextToken = [tokenizer nextToken];
            if (nextToken.quotedString) {
                [buffer appendFormat:@"[NSString stringWithString:%@]", [nextToken stringValue]];
            }
            else {
                [buffer appendString:[tok stringValue]];
                [buffer appendString:[nextToken stringValue]];
            }
        }
        else {
            [buffer appendString:[tok stringValue]];
        }
    }
    
    return buffer;
}

+ (BOOL)isOpenSymbol:(NSString*)tag {
    return [tag isEqualToString:@"["] || [tag isEqualToString:@"("];
}

+ (BOOL)isCloseSymbol:(NSString*)tag {
    return [tag isEqualToString:@"]"] || [tag isEqualToString:@")"];
}

+ (NSString*)fixTypeToVar:(NSString*)type {
    
    if ([type isEqualToString:@"double"]      ||
        [type isEqualToString:@"float"]       ||
        [type isEqualToString:@"CGFloat"]     ||
        [type isEqualToString:@"long"]        ||
        [type isEqualToString:@"NSInteger"]   ||
        [type isEqualToString:@"NSUInteger"]  ||
        [type isEqualToString:@"id"]          ||
        [type isEqualToString:@"bool"]        ||
        [type isEqualToString:@"BOOL"]        ||
        [type isEqualToString:@"int"])
    {
        return @"var";
    }
    
    return type;
}

+ (NSString*)preprocessForObjCMessagesToJS:(NSString*)sourceString {
    
    NSMutableString *buffer = [NSMutableString string];
    TDTokenizer *tokenizer  = [TDTokenizer tokenizerWithString:sourceString];
    
    tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
    tokenizer.commentState.reportsCommentTokens = YES;
    
    TDToken *eof                    = [TDToken EOFToken];
    TDToken *tok                    = nil;
    
    JSTPSymbolGroup *currentGroup   = nil;
    
    while ((tok = [tokenizer nextToken]) != eof) {
        
        // debug(@"tok: '%@' %d", [tok description], tok.word);
        
        if ([tok isSymbol] && [self isOpenSymbol:[tok stringValue]]) {
            
            JSTPSymbolGroup *nextGroup  = [[JSTPSymbolGroup alloc] init];
            
            nextGroup.parent            = currentGroup;
            currentGroup                = nextGroup;

        }
        else if ([tok isSymbol] && [self isCloseSymbol:tok.stringValue]) {
            
            if (currentGroup.parent) {
                [currentGroup.parent addSymbol:currentGroup];
            }
            else if ([currentGroup description]) {
                [buffer appendString:[currentGroup description]];
            }
            
            currentGroup = currentGroup.parent;
            
            continue;
        }
        
        if (currentGroup) {
            [currentGroup addSymbol:tok];
        }
        else {
            
            NSString *s = [tok stringValue];
            
            s = [self fixTypeToVar:s];
            
            [buffer appendString:s];
        }
    }
    
    return buffer;
}

+ (NSString*)preprocessCode:(NSString*)sourceString {
    
    sourceString = [self processMultilineStrings:sourceString];
    sourceString = [self preprocessForObjCStrings:sourceString];
    sourceString = [self preprocessForObjCMessagesToJS:sourceString];
    
    return sourceString;
}

@end



@implementation JSTPSymbolGroup
@synthesize args=_args;
@synthesize parent=_parent;

- (id)init {
	self = [super init];
	if (self != nil) {
		_args = [NSMutableArray array];
	}
    
	return self;
}


- (void)dealloc {

}

- (void)addSymbol:(id)aSymbol {
    
    if (!_openSymbol && [aSymbol isKindOfClass:[TDToken class]]) {
        _openSymbol = [[aSymbol stringValue] characterAtIndex:0];
    }
    else {
        [_args addObject:aSymbol];
    }
}

- (int)nonWhitespaceCountInArray:(NSArray*)ar {
    
    int count = 0;
    
    for (__strong id f in ar) {
        
        f = [[f description] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([f length]) {
            count++;
        }
    } 
    
    return count;
    
}

- (NSString*)description {
    
    NSUInteger argsCount = [_args count];
    
    if (_openSymbol == '(') {
        return [NSString stringWithFormat:@"(%@)", [_args componentsJoinedByString:@""]];
    }
    
    if (_openSymbol != '[') {
        return [NSString stringWithFormat:@"Bad JSTPSymbolGroup! %@", _args];
    }
    
    BOOL firstArgIsWord         = [_args count] && ([[_args objectAtIndex:0] isKindOfClass:[TDToken class]] && [[_args objectAtIndex:0] isWord]);
    BOOL firstArgIsSymbolGroup  = [_args count] && [[_args objectAtIndex:0] isKindOfClass:[JSTPSymbolGroup class]];
    
    // objc messages start with a word.  So, if it isn't- then let's just fling things back the way they were.
    if (!firstArgIsWord && !firstArgIsSymbolGroup) {
        return [NSString stringWithFormat:@"[%@]", [_args componentsJoinedByString:@""]];
    }
    
    
    NSMutableString *selector   = [NSMutableString string];
    NSMutableArray *currentArgs = [NSMutableArray array];
    NSMutableArray *methodArgs  = [NSMutableArray array];
    NSString *target            = [_args objectAtIndex:0];
    NSString *lastWord          = nil;
    BOOL hadSymbolAsArg         = NO;
    NSUInteger idx = 1;
    
    while (idx < argsCount) {
        
        id currentPassedArg = [_args objectAtIndex:idx++];
        
        TDToken *currentToken = [currentPassedArg isKindOfClass:[TDToken class]] ? currentPassedArg : nil;
        
        NSString *value = currentToken ? [currentToken stringValue] : [currentPassedArg description];
        
        if ([currentToken isWhitespace]) {
            
            //if ([value isEqualToString:@" "]) {
                [currentArgs addObject:value];
            //}
            
            continue;
        }
        
        if (!hadSymbolAsArg && [currentToken isSymbol]) {
            hadSymbolAsArg = YES;
        }
        
        
        
        if ([@":" isEqualToString:value]) {
            
            [currentArgs removeLastObject];
            
            if ([currentArgs count]) {
                [methodArgs addObject:[currentArgs componentsJoinedByString:@" "]];
                [currentArgs removeAllObjects];
            }
            
            [selector appendString:lastWord];
            [selector appendString:value];
        }
        else {
            [currentArgs addObject:[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        
        lastWord = value;
    }
    
    
    if ([currentArgs count]) {
        [methodArgs addObject:[currentArgs componentsJoinedByString:@""]];
    }
    
    
    if (![selector length] && !hadSymbolAsArg && ([methodArgs count] == 1)) {
        [selector appendString:[methodArgs lastObject]];
        [methodArgs removeAllObjects];
    }
    
    if (![selector length] && [methodArgs count] == 1) {
        return [NSString stringWithFormat:@"[%@%@]", target, [methodArgs lastObject]];
    }
    
    if (![methodArgs count] && ![selector length]) {
        return [NSString stringWithFormat:@"[%@]", target];
    }
    
    if (![selector length] && lastWord) {
        [selector appendString:lastWord];
        [methodArgs removeLastObject];
    }
    
    
    BOOL useMsgSend = NO;
    
    if (useMsgSend) {
        NSMutableString *ret = [NSMutableString stringWithString:@"jsobjc_msgSend"];

        if ([methodArgs count]) {
            [ret appendFormat:@"%d", (int)[methodArgs count]];
        }
        
        [ret appendFormat:@"(%@, \"%@\"", target, selector];
        
        for (NSString *arg in methodArgs) {
            [ret appendFormat:@", %@", arg];
        }
        
        [ret appendString:@")"];
        
        return ret;
    }
    
    [selector replaceOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [selector length])];
    
    NSMutableString *ret = [NSMutableString stringWithFormat:@"%@.%@(", target, selector];
    
    if ([self nonWhitespaceCountInArray:methodArgs]) {
        
        for (int i = 0; i < [methodArgs count]; i++) {
            
            NSString *arg = [methodArgs objectAtIndex:i];
            NSString *s = [arg description];
            NSString *t = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            [ret appendString:s];
            
            if ([t length] && i < [methodArgs count] - 1) {
                [ret appendString:@","];
            }
        }
    }
    
    [ret appendString:@")"];
    
    return ret;
    
}

@end

//
//  JSTTextView.m
//  jstalk
//
//  Created by August Mueller on 1/18/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//







static NSString *JSTQuotedStringAttributeName = @"JSTQuotedString";

@interface JSTTextView (Private)
- (void)setupLineView;
@end


@implementation JSTTextView

@synthesize keywords=_keywords;
@synthesize lastAutoInsert=_lastAutoInsert;


- (id)initWithFrame:(NSRect)frameRect textContainer:(NSTextContainer *)container {
    
	self = [super initWithFrame:frameRect textContainer:container];
    
	if (self != nil) {
        [self performSelector:@selector(setupLineViewAndStuff) withObject:nil afterDelay:0];
        [self setSmartInsertDeleteEnabled:NO];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
	if (self != nil) {
        // what's the right way to do this?
        [self performSelector:@selector(setupLineViewAndStuff) withObject:nil afterDelay:0];
        [self setSmartInsertDeleteEnabled:NO];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)setupLineViewAndStuff {
    
    NoodleLineNumberView *numberView = [[NoodleLineNumberView alloc] initWithScrollView:[self enclosingScrollView]];
    [[self enclosingScrollView] setVerticalRulerView:numberView];
    [[self enclosingScrollView] setHasHorizontalRuler:NO];
    [[self enclosingScrollView] setHasVerticalRuler:YES];
    [[self enclosingScrollView] setRulersVisible:YES];
    
    [[self textStorage] setDelegate:self];
    
    /*
     var s = "break case catch continue default delete do else finally for function if in instanceof new return switch this throw try typeof var void while with abstract boolean byte char class const debugger double enum export extends final float goto implements import int interface long native package private protected public short static super synchronized throws transient volatile null true false nil id CGFloat NSInteger NSUInteger bool BOOL"
     
     words = s.split(" ")
     var i = 0;
     list = ""
     while (i < words.length) {
     list = list + '@"' + words[i] + '", ';
     i++
     }
     
     print("NSArray *blueWords = [NSArray arrayWithObjects:" + list + " nil];")
     */
    
    NSArray *blueWords = [NSArray arrayWithObjects:@"break", @"case", @"catch", @"continue", @"default", @"delete", @"do", @"else", @"finally", @"for", @"function", @"if", @"in", @"instanceof", @"new", @"return", @"switch", @"this", @"throw", @"try", @"typeof", @"var", @"void", @"while", @"with", @"abstract", @"boolean", @"byte", @"char", @"class", @"const", @"debugger", @"double", @"enum", @"export", @"extends", @"final", @"float", @"goto", @"implements", @"import", @"int", @"interface", @"long", @"native", @"package", @"private", @"protected", @"public", @"short", @"static", @"super", @"synchronized", @"throws", @"transient", @"volatile", @"null", @"true", @"false", @"nil", @"id", @"CGFloat", @"NSInteger", @"NSUInteger", @"bool", @"BOOL", nil];

    
    NSMutableDictionary *keywords = [NSMutableDictionary dictionary];
    
    for (NSString *word in blueWords) {
        [keywords setObject:[NSColor blueColor] forKey:word];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeSelection:) name:NSTextViewDidChangeSelectionNotification object:self];

    
    self.keywords = keywords;
    
    
    [self parseCode:nil];
    
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
    
    NSUInteger sourceLoc = 0;
    
    while ((tok = [tokenizer nextToken]) != eof) {
        
        NSColor *fontColor = [NSColor blackColor];
        
        if ([tok isQuotedString]) {
            fontColor = [NSColor darkGrayColor];
        }
        else if ([tok isNumber]) {
            fontColor = [NSColor blueColor];
        }
        else if ([tok isComment]) {
            fontColor = [NSColor redColor];
        }
        else if ([tok isWord]) {
            NSColor *c = [_keywords objectForKey:[tok stringValue]];
            fontColor = c ? c : fontColor;
        }
        
        NSUInteger strLen = [[tok stringValue] length];
        
        if (fontColor) {
            [[self textStorage] addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(sourceLoc, strLen)];
        }
        
        if ([tok isQuotedString]) {
            [[self textStorage] addAttribute:JSTQuotedStringAttributeName value:[NSNumber numberWithBool:YES] range:NSMakeRange(sourceLoc, strLen)];
        }
        else {
            [[self textStorage] removeAttribute:JSTQuotedStringAttributeName range:NSMakeRange(sourceLoc, strLen)];
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
    [self insertText:@"    "];
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


@end

// stolen from NSTextStorage_TETextExtras.m
@implementation NSTextStorage (TETextExtras)

- (BOOL)_usesProgrammingLanguageBreaks {
    return YES;
}
@end
//
//  MarkerTextView.m
//  Line View Test
//
//  Created by Paul Kim on 10/4/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//




#define CORNER_RADIUS	3.0
#define MARKER_HEIGHT	13.0

@implementation MarkerLineNumberView

- (void)dealloc
{

}

- (void)setRuleThickness:(CGFloat)thickness
{
	[super setRuleThickness:thickness];
	
	// Overridden to reset the size of the marker image forcing it to redraw with the new width.
	// If doing this in a non-subclass of NoodleLineNumberView, you can set it to post frame 
	// notifications and listen for them.
	[markerImage setSize:NSMakeSize(thickness, MARKER_HEIGHT)];	
}

- (void)drawMarkerImageIntoRep:(id)rep
{
	NSBezierPath	*path;
	NSRect			rect;
	
	rect = NSMakeRect(1.0, 2.0, [rep size].width - 2.0, [rep size].height - 3.0);
	
	path = [NSBezierPath bezierPath];
	[path moveToPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect) + NSHeight(rect) / 2)];
	[path lineToPoint:NSMakePoint(NSMaxX(rect) - 5.0, NSMaxY(rect))];
	
	[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect) + CORNER_RADIUS, NSMaxY(rect) - CORNER_RADIUS) radius:CORNER_RADIUS startAngle:90 endAngle:180];
	
	[path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect) + CORNER_RADIUS, NSMinY(rect) + CORNER_RADIUS) radius:CORNER_RADIUS startAngle:180 endAngle:270];
	[path lineToPoint:NSMakePoint(NSMaxX(rect) - 5.0, NSMinY(rect))];
	[path closePath];
	
	[[NSColor colorWithCalibratedRed:0.003 green:0.56 blue:0.85 alpha:1.0] set];
	[path fill];
	
	[[NSColor colorWithCalibratedRed:0 green:0.44 blue:0.8 alpha:1.0] set];
	
	[path setLineWidth:2.0];
	[path stroke];
}

- (NSImage *)markerImageWithSize:(NSSize)size
{
	if (markerImage == nil)
	{
		NSCustomImageRep	*rep;
		
		markerImage = [[NSImage alloc] initWithSize:size];
		rep = [[NSCustomImageRep alloc] initWithDrawSelector:@selector(drawMarkerImageIntoRep:) delegate:self];
		[rep setSize:size];
		[markerImage addRepresentation:rep];
	}
	return markerImage;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	NSPoint					location;
	NSUInteger				line;
	
	location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	line = [self lineNumberForLocation:location.y];
	
	if (line != NSNotFound)
	{
		NoodleLineNumberMarker		*marker;
		
		marker = [self markerAtLine:line];
		
		if (marker != nil)
		{
			[self removeMarker:marker];
		}
		else
		{
			marker = [[NoodleLineNumberMarker alloc] initWithRulerView:self
															 lineNumber:line
																  image:[self markerImageWithSize:NSMakeSize([self ruleThickness], MARKER_HEIGHT)]
														   imageOrigin:NSMakePoint(0, MARKER_HEIGHT / 2)];
			[self addMarker:marker];
		}
		[self setNeedsDisplay:YES];
	}
}

@end
//
//  NoodleLineNumberView.m
//  Line View Test
//
//  Created by Paul Kim on 9/28/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//




#define DEFAULT_THICKNESS	22.0
#define RULER_MARGIN		5.0

@interface NoodleLineNumberView (Private)

- (NSMutableArray *)lineIndices;
- (void)invalidateLineIndices;
- (void)calculateLines;
- (NSUInteger)lineNumberForCharacterIndex:(NSUInteger)index inText:(NSString *)text;
- (NSDictionary *)textAttributes;
- (NSDictionary *)markerTextAttributes;

@end

@implementation NoodleLineNumberView

- (id)initWithScrollView:(NSScrollView *)aScrollView
{
    if ((self = [super initWithScrollView:aScrollView orientation:NSVerticalRuler]) != nil)
    {
		linesToMarkers = [[NSMutableDictionary alloc] init];
		
        [self setClientView:[aScrollView documentView]];
    }
    return self;
}

- (void)awakeFromNib
{
	linesToMarkers = [[NSMutableDictionary alloc] init];
	[self setClientView:[[self scrollView] documentView]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFont:(NSFont *)aFont
{
    if (font != aFont) {
		font = aFont;
    }
}

- (NSFont *)font
{
	if (font == nil)
	{
		return [NSFont labelFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]];
	}
    return font;
}

- (void)setTextColor:(NSColor *)color
{
	if (textColor != color)
	{
		textColor  = color;
	}
}

- (NSColor *)textColor
{
	if (textColor == nil)
	{
		return [NSColor colorWithCalibratedWhite:0.42 alpha:1.0];
	}
	return textColor;
}

- (void)setAlternateTextColor:(NSColor *)color
{
	if (alternateTextColor != color)
	{
		alternateTextColor = color;
	}
}

- (NSColor *)alternateTextColor
{
	if (alternateTextColor == nil)
	{
		return [NSColor whiteColor];
	}
	return alternateTextColor;
}

- (void)setBackgroundColor:(NSColor *)color
{
	if (backgroundColor != color)
	{
		backgroundColor = color;
	}
}

- (NSColor *)backgroundColor
{
	return backgroundColor;
}

- (void)setClientView:(NSView *)aView
{
    /*
    if (!aView) {
        debug(@"%s:%d", __FUNCTION__, __LINE__);
        [super setClientView:aView];
        return;
    }
    */
	id		oldClientView;
	
	oldClientView = [self clientView];
	
    if ((oldClientView != aView) && [oldClientView isKindOfClass:[NSTextView class]])
    {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextStorageDidProcessEditingNotification object:[(NSTextView *)oldClientView textStorage]];
    }
    [super setClientView:aView];
    if ((aView != nil) && [aView isKindOfClass:[NSTextView class]])
    {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextStorageDidProcessEditingNotification object:[(NSTextView *)aView textStorage]];

		[self invalidateLineIndices];
    }
}

- (NSMutableArray *)lineIndices
{
	if (lineIndices == nil)
	{
		[self calculateLines];
	}
	return lineIndices;
}

- (void)invalidateLineIndices
{
	lineIndices = nil;
}

- (void)textDidChange:(NSNotification *)notification
{
	// Invalidate the line indices. They will be recalculated and recached on demand.
	[self invalidateLineIndices];
	
    [self setNeedsDisplay:YES];
}

- (NSInteger)lineNumberForLocation:(CGFloat)location
{
	NSUInteger		line, count, index, rectCount, i;
	NSRectArray		rects;
	NSRect			visibleRect;
	NSLayoutManager	*layoutManager;
	NSTextContainer	*container;
	NSRange			nullRange;
	NSMutableArray	*lines;
	id				view;
		
	view = [self clientView];
	visibleRect = [[[self scrollView] contentView] bounds];
	
	lines = [self lineIndices];

	location += NSMinY(visibleRect);
	
	if ([view isKindOfClass:[NSTextView class]])
	{
		nullRange = NSMakeRange(NSNotFound, 0);
		layoutManager = [view layoutManager];
		container = [view textContainer];
		count = [lines count];
		
		for (line = 0; line < count; line++)
		{
			index = [[lines objectAtIndex:line] unsignedIntegerValue];
			
			rects = [layoutManager rectArrayForCharacterRange:NSMakeRange(index, 0)
								 withinSelectedCharacterRange:nullRange
											  inTextContainer:container
													rectCount:&rectCount];
			
			for (i = 0; i < rectCount; i++)
			{
				if ((location >= NSMinY(rects[i])) && (location < NSMaxY(rects[i])))
				{
					return line + 1;
				}
			}
		}	
	}
	return NSNotFound;
}

- (NoodleLineNumberMarker *)markerAtLine:(NSUInteger)line
{
	return [linesToMarkers objectForKey:[NSNumber numberWithUnsignedInteger:line - 1]];
}


- (void)calculateLines
{
    id              view;

    view = [self clientView];
    
    if ([view isKindOfClass:[NSTextView class]])
    {
        NSUInteger        index, numberOfLines, stringLength, lineEnd, contentEnd;
        NSString        *text;
        CGFloat         oldThickness, newThickness;
        
        text = [view string];
        stringLength = [text length];
        lineIndices = [[NSMutableArray alloc] init];
        
        index = 0;
        numberOfLines = 0;
        
        do
        {
            [lineIndices addObject:[NSNumber numberWithUnsignedInteger:index]];
            
            index = NSMaxRange([text lineRangeForRange:NSMakeRange(index, 0)]);
            numberOfLines++;
        }
        while (index < stringLength);

        // Check if text ends with a new line.
        [text getLineStart:NULL end:&lineEnd contentsEnd:&contentEnd forRange:NSMakeRange([[lineIndices lastObject] unsignedIntegerValue], 0)];
        if (contentEnd < lineEnd)
        {
            [lineIndices addObject:[NSNumber numberWithUnsignedInteger:index]];
        }

        oldThickness = [self ruleThickness];
        newThickness = [self requiredThickness];
        if (fabs(oldThickness - newThickness) > 1)
        {
			NSInvocation			*invocation;
			
			// Not a good idea to resize the view during calculations (which can happen during
			// display). Do a delayed perform (using NSInvocation since arg is a float).
			invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(setRuleThickness:)]];
			[invocation setSelector:@selector(setRuleThickness:)];
			[invocation setTarget:self];
			[invocation setArgument:&newThickness atIndex:2];
			
			[invocation performSelector:@selector(invoke) withObject:nil afterDelay:0.0];
        }
	}
}

- (NSUInteger)lineNumberForCharacterIndex:(NSUInteger)index inText:(NSString *)text
{
    NSUInteger			left, right, mid, lineStart;
	NSMutableArray		*lines;

	lines = [self lineIndices];
	
    // Binary search
    left = 0;
    right = [lines count];

    while ((right - left) > 1)
    {
        mid = (right + left) / 2;
        lineStart = [[lines objectAtIndex:mid] unsignedIntegerValue];
        
        if (index < lineStart)
        {
            right = mid;
        }
        else if (index > lineStart)
        {
            left = mid;
        }
        else
        {
            return mid;
        }
    }
    return left;
}

- (NSDictionary *)textAttributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self font], NSFontAttributeName, 
            [self textColor], NSForegroundColorAttributeName,
            nil];
}

- (NSDictionary *)markerTextAttributes
{
	    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self font], NSFontAttributeName, 
            [self alternateTextColor], NSForegroundColorAttributeName,
				nil];
}

- (CGFloat)requiredThickness
{
    NSUInteger			lineCount, digits, i;
    NSMutableString     *sampleString;
    NSSize              stringSize;
    
    lineCount = [[self lineIndices] count];
    digits = (NSUInteger)log10(lineCount) + 1;
	sampleString = [NSMutableString string];
    for (i = 0; i < digits; i++)
    {
        // Use "8" since it is one of the fatter numbers. Anything but "1"
        // will probably be ok here. I could be pedantic and actually find the fattest
		// number for the current font but nah.
        [sampleString appendString:@"8"];
    }
    
    stringSize = [sampleString sizeWithAttributes:[self textAttributes]];

	// Round up the value. There is a bug on 10.4 where the display gets all wonky when scrolling if you don't
	// return an integral value here.
    return ceilf(MAX(DEFAULT_THICKNESS, stringSize.width + RULER_MARGIN * 2));
}

- (void)drawHashMarksAndLabelsInRect:(NSRect)aRect
{
    id			view;
	NSRect		bounds;

	bounds = [self bounds];

	if (backgroundColor != nil)
	{
		[backgroundColor set];
		NSRectFill(bounds);
		
		[[NSColor colorWithCalibratedWhite:0.58 alpha:1.0] set];
		[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(bounds) - 0/5, NSMinY(bounds)) toPoint:NSMakePoint(NSMaxX(bounds) - 0.5, NSMaxY(bounds))];
	}
	
    view = [self clientView];
	
    if ([view isKindOfClass:[NSTextView class]])
    {
        NSLayoutManager			*layoutManager;
        NSTextContainer			*container;
        NSRect					visibleRect, markerRect;
        NSRange					range, glyphRange, nullRange;
        NSString				*text, *labelText;
        NSUInteger				rectCount, index, line, count;
        NSRectArray				rects;
        CGFloat					ypos, yinset;
        NSDictionary			*textAttributes, *currentTextAttributes;
        NSSize					stringSize, markerSize;
		NoodleLineNumberMarker	*marker;
		NSImage					*markerImage;
		NSMutableArray			*lines;

        layoutManager = [view layoutManager];
        container = [view textContainer];
        text = [view string];
        nullRange = NSMakeRange(NSNotFound, 0);
		
		yinset = [view textContainerInset].height;        
        visibleRect = [[[self scrollView] contentView] bounds];

        textAttributes = [self textAttributes];
		
		lines = [self lineIndices];

        // Find the characters that are currently visible
        glyphRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:container];
        range = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
        
        // Fudge the range a tad in case there is an extra new line at end.
        // It doesn't show up in the glyphs so would not be accounted for.
        range.length++;
        
        count = [lines count];
        
        for (line = [self lineNumberForCharacterIndex:range.location inText:text]; line < count; line++)
        {
            index = [[lines objectAtIndex:line] unsignedIntegerValue];
            
            if (NSLocationInRange(index, range))
            {
                rects = [layoutManager rectArrayForCharacterRange:NSMakeRange(index, 0)
                                     withinSelectedCharacterRange:nullRange
                                                  inTextContainer:container
                                                        rectCount:&rectCount];
				
                if (rectCount > 0)
                {
                    // Note that the ruler view is only as tall as the visible
                    // portion. Need to compensate for the clipview's coordinates.
                    ypos = yinset + NSMinY(rects[0]) - NSMinY(visibleRect);
					
					marker = [linesToMarkers objectForKey:[NSNumber numberWithUnsignedInteger:line]];
					
					if (marker != nil)
					{
						markerImage = [marker image];
						markerSize = [markerImage size];
						markerRect = NSMakeRect(0.0, 0.0, markerSize.width, markerSize.height);

						// Marker is flush right and centered vertically within the line.
						markerRect.origin.x = NSWidth(bounds) - [markerImage size].width - 1.0;
						markerRect.origin.y = ypos + NSHeight(rects[0]) / 2.0 - [marker imageOrigin].y;

						[markerImage drawInRect:markerRect fromRect:NSMakeRect(0, 0, markerSize.width, markerSize.height) operation:NSCompositeSourceOver fraction:1.0];
					}
                    
                    // Line numbers are internally stored starting at 0
                    labelText = [NSString stringWithFormat:@"%ld", (long)(line + 1)];
                    
                    stringSize = [labelText sizeWithAttributes:textAttributes];

					if (marker == nil)
					{
						currentTextAttributes = textAttributes;
					}
					else
					{
						currentTextAttributes = [self markerTextAttributes];
					}
					
                    // Draw string flush right, centered vertically within the line
                    [labelText drawInRect:
                       NSMakeRect(NSWidth(bounds) - stringSize.width - RULER_MARGIN,
                                  ypos + (NSHeight(rects[0]) - stringSize.height) / 2.0,
                                  NSWidth(bounds) - RULER_MARGIN * 2.0, NSHeight(rects[0]))
                           withAttributes:currentTextAttributes];
                }
            }
			if (index > NSMaxRange(range))
			{
				break;
			}
        }
    }
}

- (void)setMarkers:(NSArray *)markers
{
	NSEnumerator		*enumerator;
	NSRulerMarker		*marker;
	
	[linesToMarkers removeAllObjects];
	[super setMarkers:nil];

	enumerator = [markers objectEnumerator];
	while ((marker = [enumerator nextObject]) != nil)
	{
		[self addMarker:marker];
	}
}

- (void)addMarker:(NSRulerMarker *)aMarker
{
	if ([aMarker isKindOfClass:[NoodleLineNumberMarker class]])
	{
		[linesToMarkers setObject:aMarker
							forKey:[NSNumber numberWithUnsignedInteger:[(NoodleLineNumberMarker *)aMarker lineNumber] - 1]];
	}
	else
	{
		[super addMarker:aMarker];
	}
}

- (void)removeMarker:(NSRulerMarker *)aMarker
{
	if ([aMarker isKindOfClass:[NoodleLineNumberMarker class]])
	{
		[linesToMarkers removeObjectForKey:[NSNumber numberWithUnsignedInteger:[(NoodleLineNumberMarker *)aMarker lineNumber] - 1]];
	}
	else
	{
		[super removeMarker:aMarker];
	}
}

#pragma mark NSCoding methods

#define NOODLE_FONT_CODING_KEY				@"font"
#define NOODLE_TEXT_COLOR_CODING_KEY		@"textColor"
#define NOODLE_ALT_TEXT_COLOR_CODING_KEY	@"alternateTextColor"
#define NOODLE_BACKGROUND_COLOR_CODING_KEY	@"backgroundColor"

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder]) != nil)
	{
		if ([decoder allowsKeyedCoding])
		{
			font = [decoder decodeObjectForKey:NOODLE_FONT_CODING_KEY];
			textColor = [decoder decodeObjectForKey:NOODLE_TEXT_COLOR_CODING_KEY];
			alternateTextColor = [decoder decodeObjectForKey:NOODLE_ALT_TEXT_COLOR_CODING_KEY];
			backgroundColor = [decoder decodeObjectForKey:NOODLE_BACKGROUND_COLOR_CODING_KEY];
		}
		else
		{
			font = [decoder decodeObject];
			textColor = [decoder decodeObject];
			alternateTextColor = [decoder decodeObject];
			backgroundColor = [decoder decodeObject];
		}
		
		linesToMarkers = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[super encodeWithCoder:encoder];
	
	if ([encoder allowsKeyedCoding])
	{
		[encoder encodeObject:font forKey:NOODLE_FONT_CODING_KEY];
		[encoder encodeObject:textColor forKey:NOODLE_TEXT_COLOR_CODING_KEY];
		[encoder encodeObject:alternateTextColor forKey:NOODLE_ALT_TEXT_COLOR_CODING_KEY];
		[encoder encodeObject:backgroundColor forKey:NOODLE_BACKGROUND_COLOR_CODING_KEY];
	}
	else
	{
		[encoder encodeObject:font];
		[encoder encodeObject:textColor];
		[encoder encodeObject:alternateTextColor];
		[encoder encodeObject:backgroundColor];
	}
}

@end
//
//  NoodleLineNumberMarker.m
//  Line View Test
//
//  Created by Paul Kim on 9/30/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//




@implementation NoodleLineNumberMarker

- (id)initWithRulerView:(NSRulerView *)aRulerView lineNumber:(CGFloat)line image:(NSImage *)anImage imageOrigin:(NSPoint)imageOrigin
{
	if ((self = [super initWithRulerView:aRulerView markerLocation:0.0 image:anImage imageOrigin:imageOrigin]) != nil)
	{
		lineNumber = line;
	}
	return self;
}

- (void)setLineNumber:(NSUInteger)line
{
	lineNumber = line;
}

- (NSUInteger)lineNumber
{
	return lineNumber;
}

#pragma mark NSCoding methods

#define NOODLE_LINE_CODING_KEY		@"line"

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder]) != nil)
	{
		if ([decoder allowsKeyedCoding])
		{
			lineNumber = [[decoder decodeObjectForKey:NOODLE_LINE_CODING_KEY] unsignedIntegerValue];
		}
		else
		{
			lineNumber = [[decoder decodeObject] unsignedIntegerValue];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[super encodeWithCoder:encoder];
	
	if ([encoder allowsKeyedCoding])
	{
		[encoder encodeObject:[NSNumber numberWithUnsignedInteger:lineNumber] forKey:NOODLE_LINE_CODING_KEY];
	}
	else
	{
		[encoder encodeObject:[NSNumber numberWithUnsignedInteger:lineNumber]];
	}
}


#pragma mark NSCopying methods

- (id)copyWithZone:(NSZone *)zone
{
	id		copy;
	
	copy = [super copyWithZone:zone];
	[copy setLineNumber:lineNumber];
	
	return copy;
}


@end
// TETextUtils.m
// TextExtras
//
// Copyright © 1996-2006, Mike Ferris.
// All rights reserved.


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
//
//  JSTalk.m
//  jstalk
//
//  Created by August Mueller on 1/15/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import "JSTalk.h"


#import <ScriptingBridge/ScriptingBridge.h>





extern int *_NSGetArgc(void);
extern char ***_NSGetArgv(void);

static BOOL JSTalkShouldLoadJSTPlugins = YES;
static NSMutableArray *JSTalkPluginList;

@interface Mocha (Private)
- (JSValueRef)setObject:(id)object withName:(NSString *)name;
- (BOOL)removeObjectWithName:(NSString *)name;
- (JSValueRef)callJSFunction:(JSObjectRef)jsFunction withArgumentsInArray:(NSArray *)arguments;

@end

@interface JSTalk (Private)
- (void) print:(NSString*)s;
@end


@implementation JSTalk
@synthesize printController=_printController;
@synthesize errorController=_errorController;
@synthesize env=_env;
@synthesize shouldPreprocess=_shouldPreprocess;

+ (void)listen {
    [JSTListener listen];
}

+ (void)setShouldLoadExtras:(BOOL)b {
    JSTalkShouldLoadJSTPlugins = b;
}

+ (void)setShouldLoadJSTPlugins:(BOOL)b {
    JSTalkShouldLoadJSTPlugins = b;
}

- (id)init {
	self = [super init];
	if ((self != nil)) {
        _mochaRuntime = [[Mocha alloc] init];
        
        self.env = [NSMutableDictionary dictionary];
        _shouldPreprocess = YES;
        
        [self addExtrasToRuntime];
	}
    
	return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (JSGlobalContextRef)context {
    return [_mochaRuntime context];
}

- (void)addExtrasToRuntime {
    
    [self pushObject:self withName:@"jstalk"];
    [_mochaRuntime evalString:@"var nil=null;\n"];
    [_mochaRuntime setValue:[MOMethod methodWithTarget:self selector:@selector(print:)] forKey:@"print"];
    
    [_mochaRuntime loadFrameworkWithName:@"AppKit"];
    [_mochaRuntime loadFrameworkWithName:@"Foundation"];
}

+ (void)loadExtraAtPath:(NSString*)fullPath {
    
    Class pluginClass;
    
    @try {
        
        NSBundle *pluginBundle = [NSBundle bundleWithPath:fullPath];
        if (!pluginBundle) {
            return;
        }
        
        NSString *principalClassName = [[pluginBundle infoDictionary] objectForKey:@"NSPrincipalClass"];
        
        if (principalClassName && NSClassFromString(principalClassName)) {
            NSLog(@"The class %@ is already loaded, skipping the load of %@", principalClassName, fullPath);
            return;
        }
        
        [principalClassName class]; // force loading of it.
        
        NSError *err = nil;
        [pluginBundle loadAndReturnError:&err];
        
        if (err) {
            NSLog(@"Error loading plugin at %@", fullPath);
            NSLog(@"%@", err);
        }
        else if ((pluginClass = [pluginBundle principalClass])) {
            
            // do we want to actually do anything with em' at this point?
            
            NSString *bridgeSupportName = [[pluginBundle infoDictionary] objectForKey:@"BridgeSuportFileName"];
            
            if (bridgeSupportName) {
                NSString *bridgeSupportPath = [pluginBundle pathForResource:bridgeSupportName ofType:nil];
                
                NSError *outErr = nil;
                if (![[MOBridgeSupportController sharedController] loadBridgeSupportAtURL:[NSURL fileURLWithPath:bridgeSupportPath] error:&outErr]) {
                    NSLog(@"Could not load bridge support file at %@", bridgeSupportPath);
                }
            }
        }
        else {
            //debug(@"Could not load the principal class of %@", fullPath);
            //debug(@"infoDictionary: %@", [pluginBundle infoDictionary]);
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"EXCEPTION: %@: %@", [e name], e);
    }
    
}

+ (void)resetPlugins {
    JSTalkPluginList = nil;
}

+ (void)loadPlugins {
    
    // install plugins that were passed via the command line
    int i = 0;
    char **argv = *_NSGetArgv();
    for (i = 0; argv[i] != NULL; ++i) {
        
        NSString *a = [NSString stringWithUTF8String:argv[i]];
        
        if ([@"-jstplugin" isEqualToString:a]) {
            i++;
            NSLog(@"Loading plugin at: [%@]", [NSString stringWithUTF8String:argv[i]]);
            [self loadExtraAtPath:[NSString stringWithUTF8String:argv[i]]];
        }
    }
    
    JSTalkPluginList = [NSMutableArray array];
    
    NSString *appSupport = @"Library/Application Support/JSTalk/Plug-ins";
    NSString *appPath    = [[NSBundle mainBundle] builtInPlugInsPath];
    NSString *sysPath    = [@"/" stringByAppendingPathComponent:appSupport];
    NSString *userPath   = [NSHomeDirectory() stringByAppendingPathComponent:appSupport];
    
    
    // only make the JSTalk dir if we're JSTalkEditor.
    // or don't ever make it, since you'll get rejected from the App Store. *sigh*
    /*
    if (![[NSFileManager defaultManager] fileExistsAtPath:userPath]) {
        
        NSString *mainBundleId = [[NSBundle mainBundle] bundleIdentifier];
        
        if ([@"org.jstalk.JSTalkEditor" isEqualToString:mainBundleId]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    */
    
    for (NSString *folder in [NSArray arrayWithObjects:appPath, sysPath, userPath, nil]) {
        
        for (NSString *bundle in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:nil]) {
            
            if (!([bundle hasSuffix:@".jstplugin"])) {
                continue;
            }
            
            [self loadExtraAtPath:[folder stringByAppendingPathComponent:bundle]];
        }
    }
    
    if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"org.jstalk.JSTalkEditor"]) {
        
        NSURL *jst = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:@"org.jstalk.JSTalkEditor"];
        
        if (jst) {
            
            NSURL *folder = [[jst URLByAppendingPathComponent:@"Contents"] URLByAppendingPathComponent:@"PlugIns"];
            
            for (NSString *bundle in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[folder path] error:nil]) {
                
                if (!([bundle hasSuffix:@".jstplugin"])) {
                    continue;
                }
                
                [self loadExtraAtPath:[[folder path] stringByAppendingPathComponent:bundle]];
            }
        }
    }
}

+ (void)loadBridgeSupportFileAtURL:(NSURL*)url {
    NSError *outErr = nil;
    if (![[MOBridgeSupportController sharedController] loadBridgeSupportAtURL:url error:&outErr]) {
        NSLog(@"Could not load bridge support file at %@", url);
    }
}

NSString *currentJSTalkThreadIdentifier = @"org.jstalk.currentJSTalkHack";

+ (JSTalk*)currentJSTalk {
    return [[[NSThread currentThread] threadDictionary] objectForKey:currentJSTalkThreadIdentifier];
}

- (void)pushAsCurrentJSTalk {
    [[[NSThread currentThread] threadDictionary] setObject:self forKey:currentJSTalkThreadIdentifier];
}

- (void)popAsCurrentJSTalk {
    [[[NSThread currentThread] threadDictionary] removeObjectForKey:currentJSTalkThreadIdentifier];
}

- (void)pushObject:(id)obj withName:(NSString*)name  {
    [_mochaRuntime setObject:obj withName:name];
}

- (void)deleteObjectWithName:(NSString*)name {
    [_mochaRuntime removeObjectWithName:name];
}


- (id)executeString:(NSString*)str {
    
    if (!JSTalkPluginList && JSTalkShouldLoadJSTPlugins) {
        [JSTalk loadPlugins];
    }
    
    if (_shouldPreprocess) {
        str = [JSTPreprocessor preprocessCode:str];
    }
    
    [self pushAsCurrentJSTalk];
    
    id resultObj = nil;
    
    @try {
        
        resultObj = [_mochaRuntime evalString:str];
        
        if (resultObj == [MOUndefined undefined]) {
            resultObj = nil;
        }
    }
    @catch (NSException *e) {
        
        NSDictionary *d = [e userInfo];
        if ([d objectForKey:@"line"]) {
            if ([_errorController respondsToSelector:@selector(JSTalk:hadError:onLineNumber:atSourceURL:)]) {
                [_errorController JSTalk:self hadError:[e reason] onLineNumber:[[d objectForKey:@"line"] integerValue] atSourceURL:nil];
            }
        }
        
        NSLog(@"Exception: %@", [e userInfo]);
        [self printException:e];
    }
    @finally {
        //
    }
    
    [self popAsCurrentJSTalk];
    
    return resultObj;
}

- (BOOL)hasFunctionNamed:(NSString*)name {
    
    JSValueRef exception = nil;
    JSStringRef jsFunctionName = JSStringCreateWithUTF8CString([name UTF8String]);
    JSValueRef jsFunctionValue = JSObjectGetProperty([_mochaRuntime context], JSContextGetGlobalObject([_mochaRuntime context]), jsFunctionName, &exception);
    JSStringRelease(jsFunctionName);
    
    
    return jsFunctionValue && (JSValueGetType([_mochaRuntime context], jsFunctionValue) == kJSTypeObject);
}

- (id)callFunctionNamed:(NSString*)name withArguments:(NSArray*)args {
    
    id returnValue = nil;
    
    @try {
        
        [self pushAsCurrentJSTalk];
        
        returnValue = [_mochaRuntime callFunctionWithName:name withArgumentsInArray:args];
        
        if (returnValue == [MOUndefined undefined]) {
            returnValue = nil;
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self printException:e];
    }
    
    [self popAsCurrentJSTalk];
    
    return returnValue;
}


- (JSValueRef)callJSFunction:(JSObjectRef)jsFunction withArgumentsInArray:(NSArray *)arguments {
    [self pushAsCurrentJSTalk];
    JSValueRef r = nil;
    @try {
        r = [_mochaRuntime callJSFunction:jsFunction withArgumentsInArray:arguments];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        NSLog(@"Info: %@", [e userInfo]);
        [self printException:e];
    }
    
    [self popAsCurrentJSTalk];
    return r;
}

// JavaScriptCore isn't safe for recursion.  So calling this function from
// within a script is a really bad idea.  Of couse, that's what it was written
// for, so it really needs to be taken out.

- (void)include:(NSString*)fileName {
    
    if (![fileName hasPrefix:@"/"] && [_env objectForKey:@"scriptURL"]) {
        NSString *parentDir = [[[_env objectForKey:@"scriptURL"] path] stringByDeletingLastPathComponent];
        fileName = [parentDir stringByAppendingPathComponent:fileName];
    }
    
    NSURL *scriptURL = [NSURL fileURLWithPath:fileName];
    NSError *err = nil;
    NSString *str = [NSString stringWithContentsOfURL:scriptURL encoding:NSUTF8StringEncoding error:&err];
    
    if (!str) {
        NSLog(@"Could not open file '%@'", scriptURL);
        NSLog(@"Error: %@", err);
        return;
    }
    
    if (_shouldPreprocess) {
        str = [JSTPreprocessor preprocessCode:str];
    }
    
    [_mochaRuntime evalString:str];
}

- (void)printException:(NSException*)e {
    
    NSMutableString *s = [NSMutableString string];
    
    [s appendFormat:@"%@\n", e];
    
    NSDictionary *d = [e userInfo];
    
    for (id o in [d allKeys]) {
        [s appendFormat:@"%@: %@\n", o, [d objectForKey:o]];
    }
    
    [self print:s];
}

- (void)print:(NSString*)s {
    
    if (_printController && [_printController respondsToSelector:@selector(print:)]) {
        [_printController print:s];
    }
    else {
        if (![s isKindOfClass:[NSString class]]) {
            s = [s description];
        }
        
        printf("%s\n", [s UTF8String]);
    }
}


+ (id)applicationOnPort:(NSString*)port {
    
    NSConnection *conn  = nil;
    NSUInteger tries    = 0;
    
    while (!conn && tries < 10) {
        
        conn = [NSConnection connectionWithRegisteredName:port host:nil];
        tries++;
        if (!conn) {
            debug(@"Sleeping, waiting for %@ to open", port);
            sleep(1);
        }
    }
    
    if (!conn) {
        NSBeep();
        NSLog(@"Could not find a JSTalk connection to %@", port);
    }
    
    return [conn rootProxy];
}

+ (id)application:(NSString*)app {
    
    NSString *appPath = [[NSWorkspace sharedWorkspace] fullPathForApplication:app];
    
    if (!appPath) {
        NSLog(@"Could not find application '%@'", app);
        // fixme: why are we returning a bool?
        return [NSNumber numberWithBool:NO];
    }
    
    NSBundle *appBundle = [NSBundle bundleWithPath:appPath];
    NSString *bundleId  = [appBundle bundleIdentifier];
    
    // make sure it's running
	NSArray *runningApps = [[[NSWorkspace sharedWorkspace] launchedApplications] valueForKey:@"NSApplicationBundleIdentifier"];
    
	if (![runningApps containsObject:bundleId]) {
        BOOL launched = [[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:bundleId
                                                                             options:NSWorkspaceLaunchWithoutActivation | NSWorkspaceLaunchAsync
                                                      additionalEventParamDescriptor:nil
                                                                    launchIdentifier:nil];
        if (!launched) {
            NSLog(@"Could not open up %@", appPath);
            return nil;
        }
    }
    
    
    return [self applicationOnPort:[NSString stringWithFormat:@"%@.JSTalk", bundleId]];
}

+ (id)app:(NSString*)app {
    return [self application:app];
}

+ (id)proxyForApp:(NSString*)app {
    return [self application:app];
}


@end



#endif
#pragma clang diagnostic pop
