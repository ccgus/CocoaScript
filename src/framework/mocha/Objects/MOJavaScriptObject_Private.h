//
//  MOJavaScriptObject_Private.h
//  Mocha
//
//  Created by Logan Collins on 11/27/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import "MOJavaScriptObject.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface MOJavaScriptObject ()

/*!
 * @method objectWithJSObject:context:
 * @abstract Creates a new JavaScript wrapper object
 *
 * @param jsObject
 * @abstract The JavaScript object reference
 *
 * @param context
 * The JavaScript context reference
 *
 * @result An MOJavaScriptObject object
 */
+ (instancetype)objectWithJSObject:(JSObjectRef)jsObject context:(JSContextRef)ctx;


/*!
 * @property JSObject
 * @abstract The JavaScript object reference
 *
 * @result A JSObjectRef value
 */
@property (readonly) JSObjectRef JSObject;

/*!
 * @property JSContext
 * @abstract The JavaScript context reference
 *
 * @result A JSContextRef value
 */
@property (readonly) JSContextRef JSContext;

@end
