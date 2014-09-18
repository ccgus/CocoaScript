//
//  MOMethod.h
//  Mocha
//
//  Created by Logan Collins on 5/12/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOMethod
 * @abstract An object representation of an object method
 */
@interface MOMethod : NSObject

/*!
 * @method methodWithTarget:selector:
 * @abstract Creates a new method object from a target and selector
 * 
 * @param target
 * The target of the method call
 * 
 * @param selector
 * The selector called on the method target
 * 
 * @result An MOMethod object
 */
+ (MOMethod *)methodWithTarget:(id)target selector:(SEL)selector;


/*!
 * @property target
 * @abstract The target of the method call
 * 
 * @result An object
 */
@property (strong, readonly) id target;

/*!
 * @property selector
 * @abstract The selector called on the method target
 * 
 * @result A SEL value
 */
@property (readonly) SEL selector;

/*!
 * @property variadic
 * @abstract Whether this method consumes nil-terminated variable arguments
 *
 * @result A BOOL value
 */
@property (assign, getter=isVariadic) BOOL variadic;

/*!
 * @property returnsRetained
 * @abstract Whether this method returns a retained object
 * 
 * @discussion
 * By default, the bridge can automatically release retained objects
 * when they fall out of scope. In order for this to work, methods that return
 * retained objects must have this property set to YES.
 * 
 * Methods loaded from BridgeSupport libraries that have proper retain
 * semantic annotations will have this property set automatically.
 * 
 * In addition, methods that follow the standard Cocoa ownership conventions will
 * have this method set automatically. This includes any method that begins with
 * -copy..., -init..., -new..., etc.
 * 
 * @result A BOOL value
 */
@property (assign) BOOL returnsRetained;

@end
