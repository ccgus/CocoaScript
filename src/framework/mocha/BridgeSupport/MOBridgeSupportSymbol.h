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

