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
