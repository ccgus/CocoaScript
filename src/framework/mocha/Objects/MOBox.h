//
//  MOBox.h
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


@class Mocha;
@class MOBoxManager;

#define DEBUG_CRASHES 0

/*!
 * @class MOBox
 * @abstract A boxed Objective-C object
 */
@interface MOBox : NSObject

- (id)initWithManager:(MOBoxManager *)manager object:(id)object jsObject:(JSObjectRef)jsObject;
- (void)disassociateObject;

/*!
 * @property representedObject
 * @abstract The boxed Objective-C object
 *
 * @result An object
 */
@property (strong, readonly) id representedObject;

/*!
 * @property JSObject
 * @abstract The JSObject representation of the box
 *
 * @result A JSObjectRef value
 */
@property (assign, readonly) JSObjectRef JSObject;

/*!
 * @property manager
 * @abstract The manager for the object
 *
 * @result A MOBoxManager object
 */
@property (weak, readonly) MOBoxManager *manager;

#if DEBUG_CRASHES
@property (strong) NSString *representedObjectCanaryDesc;
#endif

@end
