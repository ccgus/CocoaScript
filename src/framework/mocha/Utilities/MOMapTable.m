//
//  MOMapTable.m
//  Mocha
//
//  Created by Logan Collins on 8/6/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOMapTable.h"

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
    
//    if ([[(id)value1 class] isSubclassOfClass:[NSDistantObject class]]) {
//        return NO;
//    }
    
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
