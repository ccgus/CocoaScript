//
//  MOProtocolDescription.m
//  Mocha
//
//  Created by Logan Collins on 5/18/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOProtocolDescription.h"
#import "MOProtocolDescription_Private.h"

#import "MOMethodDescription_Private.h"
#import "MOPropertyDescription.h"

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
