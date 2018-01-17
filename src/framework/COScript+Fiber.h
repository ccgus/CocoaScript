//
//  COScript+Fiber.h
//  Cocoa Script
//
//  Created by Mathieu Dutour on 12/04/17.
//
//

#import <Foundation/Foundation.h>
#import <CocoaScript/COScript.h>

@class COSFiber;

@interface COScript (FiberAdditions)
- (void)addFiber:(COSFiber*)fiber;
- (void)cleanupFibers;
- (void)removeFiber:(COSFiber*)fiber;
@end

