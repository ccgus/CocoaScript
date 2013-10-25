//
//  MOPropertyDescription.m
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOPropertyDescription.h"


@implementation MOPropertyDescription

@synthesize name=_name;
@synthesize typeEncoding=_typeEncoding;
@synthesize ivarName=_ivarName;
@synthesize getterSelector=_getterSelector;
@synthesize setterSelector=_setterSelector;
@synthesize ownershipRule=_ownershipRule;
@synthesize dynamic=_dynamic;
@synthesize nonAtomic=_nonAtomic;
@synthesize readOnly=_readOnly;
@synthesize weak=_weak;

- (NSString *)description {
    NSMutableArray *attributeValues = [NSMutableArray array];
    
    if (self.ownershipRule == MOObjCOwnershipRuleAssign) {
        [attributeValues addObject:@"assign"];
    }
    else if (self.ownershipRule == MOObjCOwnershipRuleCopy) {
        [attributeValues addObject:@"copy"];
    }
    else if (self.ownershipRule == MOObjCOwnershipRuleRetain) {
        [attributeValues addObject:@"retain"];
    }
    
    if (self.dynamic) {
        [attributeValues addObject:@"dynamic"];
    }
    if (self.nonAtomic) {
        [attributeValues addObject:@"nonatomic"];
    }
    if (self.readOnly) {
        [attributeValues addObject:@"readonly"];
    }
    if (self.weak) {
        [attributeValues addObject:@"weak"];
    }
    
    if (self.getterSelector != NULL) {
        [attributeValues addObject:[NSString stringWithFormat:@"getter=%@", NSStringFromSelector(self.getterSelector)]];
    }
    if (self.setterSelector != NULL) {
        [attributeValues addObject:[NSString stringWithFormat:@"setter=%@", NSStringFromSelector(self.setterSelector)]];
    }
    
    NSString *attributes = [attributeValues componentsJoinedByString:@","];
    
    return [NSString stringWithFormat:@"<%@: %p : name=%@, typeEncoding=%@, ivar=%@, attributes=(%@)>", [self class], self, self.name, self.typeEncoding, self.ivarName, attributes];
}

@end
