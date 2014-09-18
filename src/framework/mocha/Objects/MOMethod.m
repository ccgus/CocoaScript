//
//  MOMethod.m
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOMethod.h"

#import "MOBridgeSupportController.h"
#import "MOBridgeSupportSymbol.h"

#import "MOFunctionInvocation.h"


@interface MOMethod ()

@property (strong, readwrite) id target;
@property (readwrite) SEL selector;

@end


@implementation MOMethod

+ (MOMethod *)methodWithTarget:(id)target selector:(SEL)selector {
    MOMethod *method = [[self alloc] init];
    method.target = target;
    method.selector = selector;
    
    // Determine the retain semantics of the method via BridgeSupport
    BOOL matchFound = NO;
    Class searchClass = [target class];
    while (searchClass != Nil) {
        MOBridgeSupportClass *aClass = [[MOBridgeSupportController sharedController] symbolWithName:NSStringFromClass(searchClass) type:[MOBridgeSupportClass class]];
        MOBridgeSupportMethod *bridgeMethod = [aClass methodWithSelector:selector];
        if (method != nil) {
            matchFound = YES;
            method.returnsRetained = [[bridgeMethod returnValue] isAlreadyRetained];
            method.variadic = [bridgeMethod isVariadic];
            break;
        }
        searchClass = [searchClass superclass];
    }
    if (!matchFound) {
        // Compare method names with standard Cocoa conventions
        NSString *methodName = NSStringFromSelector(selector);
        if ([methodName hasPrefix:@"init"]) {
            // -init...
            if ([methodName length] > 4 && [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[methodName characterAtIndex:4]]) {
                method.returnsRetained = YES;
            }
            else if ([methodName length] == 4) {
                method.returnsRetained = YES;
            }
        }
        else if ([methodName hasPrefix:@"copy"]) {
            // -copy...
            if ([methodName length] > 4 && [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[methodName characterAtIndex:4]]) {
                method.returnsRetained = YES;
            }
            else if ([methodName length] == 4) {
                method.returnsRetained = YES;
            }
        }
    }
    
    return method;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : target=%@, selector=%@>", [self class], self, [self target], NSStringFromSelector([self selector])];
}

@end
