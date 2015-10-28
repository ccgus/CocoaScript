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


/*!
 * @class MOBox
 * @abstract A boxed Objective-C object
 */
@interface MOBox : NSObject

- (id)initWithRuntime:(Mocha*)runtime;
- (void)associateObject:(id)object jsObject:(JSObjectRef)jsObject context:(JSContextRef)context;
- (void)disassociateObjectInContext:(JSContextRef)context;

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
 * @property runtime
 * @abstract The runtime for the object
 *
 * @result A Mocha object
 */
@property (weak, readonly) Mocha *runtime;

@end
