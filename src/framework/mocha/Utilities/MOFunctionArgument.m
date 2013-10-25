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
#import "MochaRuntime_Private.h"
#import "MOPointer.h"
#import "MOPointerValue.h"
#import "MOStruct.h"
#import "MOUndefined.h"
#import "MOBridgeSupportController.h"
#import "MOBridgeSupportSymbol.h"
#import "MOUtilities.h"

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
