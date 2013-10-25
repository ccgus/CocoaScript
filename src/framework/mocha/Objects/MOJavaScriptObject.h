//
//  MOJavaScriptObject.h
//  Mocha
//
//  Created by Logan Collins on 5/28/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


/*!
 * @class MOJavaScriptObject
 * @abstract A thin wrapper around a pure JavaScript object
 */
@interface MOJavaScriptObject : NSObject

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
+ (MOJavaScriptObject *)objectWithJSObject:(JSObjectRef)jsObject context:(JSContextRef)ctx;


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
