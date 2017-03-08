//
//  MOBoxManagerBoxContext.m
//  
//
//  Created by Sam Deane on 14/01/2016.
//
//

#import "MOBoxManagerBoxContext.h"
#import "MOBoxManager.h"

@interface MOBoxManager(MOBoxManagerBoxContextSupport)
- (void)associateObject:(id)object jsObject:(JSObjectRef)jsObject;
@end

@interface MOBoxManagerBoxContext()
@property (strong, nonatomic) MOBoxManager* manager;
@property (strong, nonatomic) id object;
@end

@implementation MOBoxManagerBoxContext

- (id)initWithManager:(MOBoxManager*)manager object:(id)object {
    NSParameterAssert(manager);
    NSParameterAssert(object);

    self = [super init];
    if (self) {
        _manager = manager;
        _object = object;
    }

    return self;
}

- (void)finishMakingBoxForObject:(JSObjectRef)jsObject {
    [_manager associateObject:_object jsObject:jsObject];
}

@end
