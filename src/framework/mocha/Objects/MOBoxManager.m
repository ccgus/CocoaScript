//
//  MOBoxManager.m
//  
//
//  Created by Sam Deane on 16/12/2015.
//
//

#import "MOBoxManager.h"
#import "MOBoxManagerBoxContext.h"
#import "MOBox.h"

@implementation MOBoxManager {
    JSGlobalContextRef _context;
    NSMapTable *_index;
}

- (instancetype)initWithContext:(JSGlobalContextRef)context {
    NSAssert([NSThread isMainThread], @"should be main thread");
    self = [super init];
    if (self) {
        // we want to use NSMapTableObjectPointerPersonality for the keys, since we are associating boxes with specific objects
        // and not with the underlying values of them (if two objects are equal according to isEqual:, we still want a box for both)
        _index = [[NSMapTable alloc] initWithKeyOptions:NSMapTableObjectPointerPersonality | NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
        _context = context;
        JSGlobalContextRetain(context);
    }

    return self;
}

- (void)dealloc {
    debug(@"dealloced manager");
}

- (void)cleanup {
    NSAssert([NSThread isMainThread], @"should be main thread");

    // break any retain cycles between the boxed objects and the things that they are boxing
    NSEnumerator* enumerator = [_index objectEnumerator];
    MOBox* box = nil;
    while (box = [enumerator nextObject]) {
        debug(@"cleaned %p %ld", box, box.count);
        [box disassociateObject];
    }

    // throw away the index, which will release any boxes still in it, which in turn should release the objects they were boxing
    _index = nil;

    // throw the context away, which should clean up any remaining JS objects
    // (these should all have had their boxes removed by now, and their private pointers cleaned out)
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
    MOBoxManagerBoxContext* context = [[MOBoxManagerBoxContext alloc] initWithManager:self object:object];
    JSObjectRef jsObject = JSObjectMake(_context, jsClass, (__bridge void *)(context));
    return jsObject;
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
    }
}

@end


@implementation MOBoxManager(MOBoxManagerBoxContextSupport)

- (void)associateObject:(id)object jsObject:(JSObjectRef)jsObject {
    NSAssert([_index objectForKey:object] == nil, @"shouldn't already have an entry for the object");
    MOBox* box = [[MOBox alloc] initWithManager:self object:object jsObject:jsObject];
    [_index setObject:box forKey:object];
}

@end