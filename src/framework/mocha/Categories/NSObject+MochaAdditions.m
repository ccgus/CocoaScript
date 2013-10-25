//
//  NSObject+MochaAdditions.m
//  Mocha
//
//  Created by Logan Collins on 5/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "NSObject+MochaAdditions.h"

#import "MOClassDescription.h"

#import <objc/runtime.h>


@implementation NSObject (MochaAdditions)

+ (void)mo_swizzleAdditions {
    Class metaClass = object_getClass(self);
    
    SEL classDescriptionSelector = @selector(mocha);
    if (!class_respondsToSelector(self, classDescriptionSelector)) {
        IMP imp = class_getMethodImplementation(metaClass, @selector(mo_mocha));
        class_addMethod(metaClass, classDescriptionSelector, imp, "@@:");
    }
}

+ (MOClassDescription *)mo_mocha {
    return [MOClassDescription descriptionForClass:self];
}

@end
