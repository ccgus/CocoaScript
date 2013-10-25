//
//  MOUndefined.h
//  Mocha
//
//  Created by Logan Collins on 5/15/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOUndefined
 * @abstract Represents an "undefined" value, as passed from JavaScript to Objective-C
 * 
 * @discussion
 * Syntactically, the undefined value represents the return value of a function that returns 'void' in C.
 */
@interface MOUndefined : NSObject

/*!
 * @method undefined
 * @abstract Gets the singleton undefined instance
 * 
 * @result An MOUndefined object
 */
+ (MOUndefined *)undefined;

@end
