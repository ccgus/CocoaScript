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


/*!
 * @class MOBox
 * @abstract A boxed Objective-C object
 */
@interface MOBox : NSObject

- (id)initWithManager:(MOBoxManager*)manager;
- (void)associateObject:(id)object jsObject:(JSObjectRef)jsObject;
- (void)disassociateObject;

/*!
 * @property representedObject
 * @abstract The boxed Objective-C object
 *
 * @result An object
 */
@property (strong, readonly) id representedObject;

@property (weak) id representedObjectCanary;
@property (strong) NSString *representedObjectCanaryDesc;

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

@end
