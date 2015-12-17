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
    NSMapTable *_index;
}

- (instancetype)initWithContext:(JSGlobalContextRef)context {
    self = [super init];
    if (self) {
        _index = [NSMapTable strongToStrongObjectsMapTable];
        _context = context;
    }

    return self;
}

- (void)cleanup {
    NSAssert([NSThread isMainThread], @"should be main thread");
    for (NSValue* key in _index) {
        MOBox* box = [_index objectForKey:key];
//        NSLog(@"cleaned up box %@ for %@", box, [box.representedObject class]);
        [box disassociateObject];
    }
    _index = nil;
    _context = nil;
}

- (MOBox*)boxForObject:(id)object {
    NSAssert([NSThread isMainThread], @"should be main thread");
    MOBox* box = [_index objectForKey:object];
    return box;
}

- (JSObjectRef)makeBoxForObject:(id)object jsClass:(JSClassRef)jsClass {
    NSAssert([NSThread isMainThread], @"should be main thread");
    MOBox* box = [[MOBox alloc] initWithManager:self];
    JSObjectRef jsObject = JSObjectMake(_context, jsClass, (__bridge void *)(box));
    [box associateObject:object jsObject:jsObject];
    NSAssert([_index objectForKey:object] == nil, @"shouldn't already have an entry for the object");
    [_index setObject:box forKey:object];
    return jsObject;
}

- (void)removeBoxForObject:(id)object {
    NSAssert([NSThread isMainThread], @"should be main thread");
    MOBox* box = [_index objectForKey:object];
    if (box) {
        [box disassociateObject];
        [_index removeObjectForKey:object];
    }
}

@end
