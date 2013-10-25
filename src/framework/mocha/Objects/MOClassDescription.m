//
//  MOClassDescription.m
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOClassDescription.h"

#import "MochaRuntime_Private.h"
#import "MOUtilities.h"
#import "MOFunctionArgument.h"
#import "MOJavaScriptObject.h"

#import "MOInstanceVariableDescription_Private.h"
#import "MOMethodDescription_Private.h"
#import "MOPropertyDescription.h"
#import "MOProtocolDescription_Private.h"

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
