//
//  MOBoxManager.m
//  
//
//  Created by Sam Deane on 16/12/2015.
//
//

#import "MOBoxManager.h"
#import "MOBox.h"

@implementation MOBoxManager {
    JSGlobalContextRef _context;
    NSMutableDictionary *_index;
}

- (instancetype)initWithContext:(JSGlobalContextRef)context {
    self = [super init];
    if (self) {
        _index = [NSMutableDictionary new];
        _context = context;
    }

    return self;
}

- (void)cleanup {
    [_index enumerateKeysAndObjectsUsingBlock:^(id key, MOBox *box, BOOL *stop) {
        JSValueUnprotect(_context, box.JSObject);
        [box disassociateObjectInContext:_context];
    }];
    _index = nil;
    _context = nil;
}

- (id)keyForObject:(id)object {
    NSValue *objectPointerValue = [NSValue valueWithPointer:(__bridge const void *)(object)];
    return objectPointerValue;
}

- (MOBox*)boxForObject:(id)object {
    id key = [self keyForObject:object];
    MOBox* box = [_index objectForKey:key];
    return box;
}

- (JSObjectRef)makeBoxForObject:(id)object jsClass:(JSClassRef)jsClass {
    MOBox* box = [[MOBox alloc] initWithManager:self];
    JSObjectRef jsObject = JSObjectMake(_context, jsClass, (__bridge void *)(box));
    [box associateObject:object jsObject:jsObject];
    JSValueProtect(_context, jsObject); // TODO: this is a temporary hack. It will fix the script crash, but only at the expense of leaking all JS objects during a script run. Which is not good...
    [_index setObject:box forKey:[self keyForObject:object]];
    return jsObject;
}

- (void)removeBoxForObject:(id)object {
    id key = [self keyForObject:object];
    MOBox* box = [_index objectForKey:key];
    if (box) {
        [box disassociateObjectInContext:_context];
        [_index removeObjectForKey:key];
    }
}

@end
