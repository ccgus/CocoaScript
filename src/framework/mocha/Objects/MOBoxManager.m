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
    NSAssert([NSThread isMainThread], @"should be main thread");
    self = [super init];
    if (self) {
        _index = [NSMapTable strongToStrongObjectsMapTable];
        _context = context;
        JSGlobalContextRetain(context);
    }

    return self;
}

- (void)cleanup {
    NSAssert([NSThread isMainThread], @"should be main thread");

    // break any retain cycles between the boxed objects and the things that they are boxing
    for (NSValue* key in _index) {
        MOBox* box = [_index objectForKey:key];
        [box disassociateObject];
    }
    _index = nil;
    JSGlobalContextRelease(_context);
    _context = nil;
}

- (MOBox*)boxForObject:(id)object {
    debug(@"added box for %p %@", object, [object className]);
    NSAssert([NSThread isMainThread], @"should be main thread");
    NSAssert(![object isKindOfClass:[MOBox class]], @"shouldn't box a box");
    MOBox* box = [_index objectForKey:object];
    return box;
}

- (JSObjectRef)makeBoxForObject:(id)object jsClass:(JSClassRef)jsClass {
    NSAssert([NSThread isMainThread], @"should be main thread");
    NSAssert(![object isKindOfClass:[MOBox class]], @"shouldn't box a box");
    NSDictionary* context = @{ @"manager" : self, @"object" : object };
    JSObjectRef jsObject = JSObjectMake(_context, jsClass, (__bridge void *)(context));
    return jsObject;
}

- (void)associateObject:(id)object jsObject:(JSObjectRef)jsObject {
    NSAssert([_index objectForKey:object] == nil, @"shouldn't already have an entry for the object");
    MOBox* box = [[MOBox alloc] initWithManager:self object:object jsObject:jsObject];
    [_index setObject:box forKey:object];
}

- (void)removeBoxForObject:(id)object {
    debug(@"removing box for %p %@", object, object);
    NSAssert([NSThread isMainThread], @"should be main thread");
    MOBox* box = [_index objectForKey:object];
    if (box) {
        [box disassociateObject];
        [_index removeObjectForKey:object];
    } else {
        debug(@"shouldn't be asked to unbox something that has no box (the object was %p %@)", object, [object className]);
        for (id key in _index) {
            box = [_index objectForKey:key];
            if (box.representedObject == object) {
                NSLog(@"found orphaned box");
            }
        }
    }
}

@end
