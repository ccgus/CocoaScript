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

#import "MOFunctionArgument.h"
#import "MORuntime_Private.h"
#import "MOPointer.h"
#import "MOPointerValue.h"
#import "MOStruct.h"
#import "MOUndefined.h"
#import "MOBridgeSupportController.h"
#import "MOBridgeSupportSymbol.h"

#import <objc/runtime.h>


NSString * MOJSValueToString(JSContextRef ctx, JSValueRef value, JSValueRef *exception);


@interface MOFunctionArgument ()

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


@implementation MOFunctionArgument {
    NSString *_typeEncoding;
    char _baseTypeEncoding;
    void * _storage;
    BOOL _ownsStorage;
    ffi_type _structureType;
}

- (id)init {
    return [self initWithBaseTypeEncoding:_C_ID];
}

- (id)initWithBaseTypeEncoding:(char)baseTypeEncoding {
    unichar character = (unichar)baseTypeEncoding;
    NSString *typeEncoding = [NSString stringWithCharacters:&character length:1];
    return [self initWithTypeEncoding:typeEncoding];
}

- (id)initWithTypeEncoding:(NSString *)typeEncoding {
    return [self initWithTypeEncoding:typeEncoding storage:NULL];
}

- (id)initWithTypeEncoding:(NSString *)typeEncoding storage:(void **)storagePtr {
    self = [super init];
    if (self) {
        [self setTypeEncoding:typeEncoding storage:storagePtr];
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
    
    [_typeEncoding release];
    [_pointer release];
    
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : typeEncoding=%@, returnValue=%@, storage=%p>", [self class], self, _typeEncoding, (_returnValue ? @"YES" : @"NO"), _storage];
}


#pragma mark -
#pragma mark Accessors

- (NSString *)typeEncoding {
    return _typeEncoding;
}

- (void)setTypeEncoding:(NSString *)typeEncoding {
    [self setTypeEncoding:typeEncoding storage:NULL];
}

- (void)setTypeEncoding:(NSString *)typeEncoding storage:(void **)storagePtr {
    if (_ownsStorage && _storage != NULL) {
        free(_storage);
    }
    _storage = NULL;
    _ownsStorage = NO;
    
    _baseTypeEncoding = [typeEncoding characterAtIndex:0];
    
    [_typeEncoding release];
    _typeEncoding = [typeEncoding retain];
    
    if (_baseTypeEncoding == _C_PTR) {
        // Override for toll-free bridged CFTypes, which encode as pointers but are really objects
        if ([typeEncoding isEqualToString:@"^{__CFArray=}"]
            || [typeEncoding isEqualToString:@"^{__CFAttributedString=}"]
            || [typeEncoding isEqualToString:@"^{__CFBoolean=}"]
            || [typeEncoding isEqualToString:@"^{__CFCalendar=}"]
            || [typeEncoding isEqualToString:@"^{__CFCharacterSet=}"]
            || [typeEncoding isEqualToString:@"^{__CFData=}"]
            || [typeEncoding isEqualToString:@"^{__CFDate=}"]
            || [typeEncoding isEqualToString:@"^{__CFDictionary=}"]
            || [typeEncoding isEqualToString:@"^{__CFError=}"]
            || [typeEncoding isEqualToString:@"^{__CFLocale=}"]
            || [typeEncoding isEqualToString:@"^{__CFNumber=}"]
            || [typeEncoding isEqualToString:@"^{__CFReadStream=}"]
            || [typeEncoding isEqualToString:@"^{__CFRunLoopTimer=}"]
            || [typeEncoding isEqualToString:@"^{__CFSet=}"]
            || [typeEncoding isEqualToString:@"^{__CFString=}"]
            || [typeEncoding isEqualToString:@"^{__CFTimeZone=}"]
            || [typeEncoding isEqualToString:@"^{__CFURL=}"]
            || [typeEncoding isEqualToString:@"^{__CFWriteStream=}"]) {
            _baseTypeEncoding = _C_ID;
            
            [_typeEncoding release];
            _typeEncoding = [@"@" retain];
        }
    }
    
    // Copy storage
    if (storagePtr != NULL) {
        _storage = storagePtr;
    }
    else {
        [self allocateStorage];
    }
    
    if (_baseTypeEncoding == _C_STRUCT_B) {
        // Build an ffi structure type for structs
        NSArray *types = [MOFunctionArgument typeEncodingsFromStructureTypeEncoding:typeEncoding];
        NSUInteger elementCount = [types count];
        
        _structureType.size = 0;
        _structureType.alignment = 0;
        _structureType.type = FFI_TYPE_STRUCT;
        if (_structureType.elements != nil) {
            free(_structureType.elements);
        }
        _structureType.elements = malloc(sizeof(ffi_type *) * (elementCount + 1)); // +1 is trailing NULL
        
        NSUInteger i = 0;
        for (NSString *type in types) {
            char charEncoding = *(char*)[type UTF8String];
            _structureType.elements[i++] = [MOFunctionArgument ffiTypeForTypeEncoding:charEncoding];
        }
        _structureType.elements[elementCount] = NULL;
    }
    else {
        if (![MOFunctionArgument getSize:NULL ofTypeEncoding:_baseTypeEncoding]) {
            @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Invalid type encoding: %c", _baseTypeEncoding] userInfo:nil];
        };
        
        _structureType.size = 0;
        _structureType.alignment = 0;
        _structureType.type = 0;
        if (_structureType.elements != NULL) {
            free(_structureType.elements);
        }
        _structureType.elements = NULL;
    }
}

- (ffi_type *)ffiType {
    if (_typeEncoding == nil) {
        return NULL;
    }
    else if (_baseTypeEncoding == _C_PTR) {
        return &ffi_type_pointer;
    }
    else if (_baseTypeEncoding == _C_STRUCT_B) {
        return &_structureType;
    }
    return [MOFunctionArgument ffiTypeForTypeEncoding:_baseTypeEncoding];
}

- (size_t)size {
    if (_baseTypeEncoding == _C_STRUCT_B) {
        return [MOFunctionArgument sizeOfStructureTypeEncoding:_typeEncoding];
    }
    else {
        size_t size = 0;
        [MOFunctionArgument getSize:&size ofTypeEncoding:_baseTypeEncoding];
        return size;
    }
}

- (NSString *)typeDescription {
    return [MOFunctionArgument descriptionOfTypeEncoding:_baseTypeEncoding fullTypeEncoding:_typeEncoding];
}


#pragma mark -
#pragma mark Storage

- (void **)storage {
    if (self.pointer != nil) {
        return &_storage;
    }
    return _storage;
}

- (void)allocateStorage {
    if (!_typeEncoding) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"No type encoding set in %@", self] userInfo:nil];
    }
    
    BOOL success = NO;
    size_t size = 0;
    
    // Special case for structs
    if (_baseTypeEncoding == _C_STRUCT_B) {
        // Some front padding for alignment and tail padding for structure
        // ( http://developer.apple.com/documentation/DeveloperTools/Conceptual/LowLevelABI/Articles/IA32.html )
        // Structures are tail-padded to 32-bit multiples.
        
        // +16 for alignment
        // +4 for tail padding
        // size = [MOFunctionArgument sizeOfStructureTypeEncoding:_typeEncoding] + 16 + 4;
        size = [MOFunctionArgument sizeOfStructureTypeEncoding:_typeEncoding] + 4;
        success = YES;
    }
    else {
        success = [MOFunctionArgument getSize:&size ofTypeEncoding:_baseTypeEncoding];
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
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to allocate storage for argument type %c", _baseTypeEncoding] userInfo:nil];
    }
}

// This destroys the original pointer value by modifying it in place : maybe change to returning the new address ?
+ (void)alignPtr:(void **)ptr accordingToEncoding:(char)encoding {
    size_t alignOnSize = 0;
    BOOL success = [MOFunctionArgument getAlignment:&alignOnSize ofTypeEncoding:encoding];
    
    if (success) {
        long address = (long)*ptr;
        if ((address % alignOnSize) != 0) {
            address = (address + alignOnSize) & ~(alignOnSize - 1);
        }
        
        *ptr = (void *)address;
    }
    else {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Unable to align pointer for argument type %c", encoding] userInfo:nil];
    }
}

// This destroys the original pointer value by modifying it in place : maybe change to returning the new address ?
+ (void)advancePtr:(void **)ptr accordingToEncoding:(char)encoding {
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
#pragma mark JSValue Conversion

- (JSValueRef)getValueAsJSValueInContext:(JSContextRef)ctx {
    return [self getValueAsJSValueInContext:ctx dereference:NO];
}

- (JSValueRef)getValueAsJSValueInContext:(JSContextRef)ctx dereference:(BOOL)dereference {
    NSAssert(_storage != NULL, @"Cannot get value with NULL storage pointer");
    
    JSValueRef value = NULL;
    void *p = _storage;
    char typeEncoding = _baseTypeEncoding;
    NSString *encoding = _typeEncoding;
    
    if (dereference) {
        if (typeEncoding == _C_PTR) {
            typeEncoding = [_typeEncoding characterAtIndex:1];
            encoding = [_typeEncoding substringFromIndex:1];
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
        char typeEncoding = _baseTypeEncoding;
        NSString *encoding = _typeEncoding;
        
        if (dereference) {
            if (typeEncoding == _C_PTR) {
                typeEncoding = [_typeEncoding characterAtIndex:1];
                encoding = [_typeEncoding substringFromIndex:1];
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
        *(void **)_storage = NULL;
    }
}


#pragma mark -
#pragma mark Type Encodings

/*
 * __alignOf__ returns 8 for double, but its struct align is 4
 * use dummy structures to get struct alignment, each having a byte as first element
 */
typedef struct { char a; void * b; } struct_C_ID;
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
    if (c == NULL) {
        return nil;
    }
    // skip '_' if it's there
    if (*c == '_') {
        c++;
    }
    char *c2 = c;
    while (*c2 && *c2 != '=') {
        c2++;
    }
    return [[[NSString alloc] initWithBytes:c length:(c2-c) encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSString *)structureFullTypeEncodingFromStructureTypeEncoding:(NSString *)encoding {
    NSString *structureName = [MOFunctionArgument structureNameFromStructureTypeEncoding:encoding];
    return [self structureFullTypeEncodingFromStructureName:structureName];
}

+ (NSString *)structureFullTypeEncodingFromStructureName:(NSString *)structureName {
    // Fetch structure type encoding from BridgeSupport
    id symbol = [[MOBridgeSupportController sharedController] symbolWithName:structureName type:[MOBridgeSupportStruct class]];
    
    if (symbol == nil) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"No structure encoding found for %@", structureName] userInfo:nil];
        return nil;
    }
    
#if __LP64__
    id type = ([symbol respondsToSelector:@selector(type64)] ? [symbol type64] : nil);
    if (type == nil) {
        type = ([symbol respondsToSelector:@selector(type)] ? [symbol type] : nil);
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
            
            [propertyName release];
            
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
    void ** ptr = (void **)&computedSize;
    for (NSString *type in types) {
        char charEncoding = *(char *)[type UTF8String];
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
    
    MORuntime *runtime = [MORuntime runtimeWithContext:ctx];
    
    switch (typeEncoding) {
        case _C_ID:
        case _C_CLASS: {
            id object = [runtime objectForJSValue:value inContext:ctx];
            *(void **)ptr = (__bridge void *)object;
            return YES;
        }
        case _C_PTR: {
            id object = [runtime objectForJSValue:value inContext:ctx];
            if ([object isKindOfClass:[MOPointerValue class]]) {
                *(void **)ptr = [object pointerValue];
            }
            else if ([object isKindOfClass:[MOStruct class]]) {
                JSObjectRef objectRef = JSValueToObject(ctx, value, NULL);
                NSString *type = [MOFunctionArgument structureFullTypeEncodingFromStructureTypeEncoding:[fullTypeEncoding substringFromIndex:1]];
                
                NSInteger numParsed = [MOFunctionArgument structureFromJSObject:objectRef inContext:ctx inParentJSValueRef:NULL cString:(char *)[type UTF8String] storage:&ptr];
                return numParsed;
            }
            else {
                *(void **)ptr = (__bridge void *)object;
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
                case _C_CHR:        *(char *)ptr = (char)number; break;
                case _C_UCHR:       *(unsigned char *)ptr = (unsigned char)number; break;
                case _C_SHT:        *(short *)ptr = (short)number; break;
                case _C_USHT:       *(unsigned short *)ptr = (unsigned short)number; break;
                case _C_INT:
                case _C_UINT: {
#ifdef __BIG_ENDIAN__
                    // Two step conversion : to unsigned int then to int. One step conversion fails on PPC.
                    unsigned int uint = (unsigned int)number;
                    *(signed int *)ptr = (signed int)uint;
                    break;
#endif
#ifdef __LITTLE_ENDIAN__
                    *(int*)ptr = (int)number;
                    break;
#endif
                }
                case _C_LNG:        *(long *)ptr = (long)number; break;
                case _C_ULNG:       *(unsigned long *)ptr = (unsigned long)number; break;
                case _C_LNG_LNG:    *(long long *)ptr = (long long)number; break;
                case _C_ULNG_LNG:   *(unsigned long long *)ptr = (unsigned long long)number; break;
                case _C_FLT:        *(float *)ptr = (float)number; break;
                case _C_DBL:        *(double *)ptr = (double)number; break;
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
    
    MORuntime *runtime = [MORuntime runtimeWithContext:ctx];
    
    switch (typeEncoding) {
        case _C_ID:    
        case _C_CLASS: {
            id object = (__bridge id)(*(void**)ptr);
            *value = [runtime JSValueForObject:object inContext:ctx];
            return YES;
        }
        case _C_PTR: {
            void * pointer = *(void**)ptr;
            MOPointerValue *object = [[[MOPointerValue alloc] initWithPointerValue:pointer typeEncoding:fullTypeEncoding] autorelease];
            *value = [runtime JSValueForObject:object inContext:ctx];
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
                case _C_CHR:        number = *(char *)ptr; break;
                case _C_UCHR:       number = *(unsigned char *)ptr; break;
                case _C_SHT:        number = *(short *)ptr; break;
                case _C_USHT:       number = *(unsigned short *)ptr; break;
                case _C_INT:        number = *(int *)ptr; break;
                case _C_UINT:       number = *(unsigned int *)ptr; break;
                case _C_LNG:        number = *(long *)ptr; break;
                case _C_ULNG:       number = *(unsigned long *)ptr; break;
                case _C_LNG_LNG:    number = *(long long *)ptr; break;
                case _C_ULNG_LNG:   number = *(unsigned long long *)ptr; break;
                case _C_FLT:        number = *(float *)ptr; break;
                case _C_DBL:        number = *(double *)ptr; break;
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
    
    int openedBracesCount = 1;
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
            
            [propertyName release];
            
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
    MORuntime *runtime = [MORuntime runtimeWithContext:ctx];
    
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
                        [propertyName release];
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
            
            id objValue = [runtime objectForJSValue:valueJS inContext:ctx];
            [memberNames addObject:propertyName];
            [memberValues setObject:objValue forKey:propertyName];
            
            [propertyName release];
        }
    }
    
    MOStruct *structure = [[MOStruct alloc] initWithName:structureName memberNames:memberNames];
    for (NSString *name in memberNames) {
        id memberValue = [memberValues objectForKey:name];
        [structure setObject:memberValue forMemberName:name];
    }
    
    JSValueRef jsValue = [runtime JSValueForObject:structure inContext:ctx];
    JSObjectRef jsObject = JSValueToObject(ctx, jsValue, NULL);
    
    if (!*value) {
        *value = jsObject;
    }
    
    return c - c0 - 1;
}


#pragma mark -
#pragma mark Type Signatures

+ (NSArray *)argumentsFromTypeSignature:(NSString *)typeSignature {
    NSMutableArray *argumentEncodings = [NSMutableArray array];
    char *argsParser = (char *)[typeSignature UTF8String];
    
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
                    MOFunctionArgument *argumentEncoding = [[MOFunctionArgument alloc] initWithTypeEncoding:encoding];
                    [encoding release];
                    
                    // Set return value
                    if ([argumentEncodings count] == 0) {
                        [argumentEncoding setReturnValue:YES];
                    }
                    
                    [argumentEncodings addObject:argumentEncoding];
                    
                    [argumentEncoding release];
                    
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
                        [argumentEncoding setTypeEncoding:encoding];
                        [encoding release];
                    }
                    else {
                        // Blocks are '@?', skip '?'
                        if (typeStart[0] == _C_ID && typeStart[1] == _C_UNDEF) {
                            NSString *encoding = [[NSString alloc] initWithBytes:typeStart length:sizeof(char) * 2 encoding:NSUTF8StringEncoding];
                            [argumentEncoding setTypeEncoding:encoding];
                            [encoding release];
                            
                            argsParser++;
                        }
                        else {
                            NSString *encoding = [[NSString alloc] initWithBytes:typeStart length:sizeof(char) encoding:NSUTF8StringEncoding];
                            [argumentEncoding setTypeEncoding:encoding];
                            [encoding release];
                        }
                    }
                    
                    [argumentEncodings addObject:argumentEncoding];
                    
                    [argumentEncoding release];
                }
            }
        }
        
        if (!*argsParser) {
            break;
        }
    }
    return argumentEncodings;
}

@end


NSString * MOJSValueToString(JSContextRef ctx, JSValueRef value, JSValueRef *exception) {
    if (value == NULL) {
        return nil;
    }
    JSStringRef resultStringJS = JSValueToStringCopy(ctx, value, exception);
    NSString *resultString = CFBridgingRelease(JSStringCopyCFString(kCFAllocatorDefault, resultStringJS));
    JSStringRelease(resultStringJS);
    return resultString;
}
