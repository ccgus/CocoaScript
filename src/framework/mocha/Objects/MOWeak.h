//
//  MOWeak.h
//  Mocha
//
//  Created by Logan Collins on 12/10/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MOWeak : NSObject

/*!
 * @method initWithValue:
 * @abstract Creates a new weak reference
 *
 * @param value
 * The value for the weak reference
 *
 * @result An MOWeak object
 */
- (id)initWithValue:(id)value;


/*!
 * @property value
 * @abstract The value of the weak reference
 *
 * @result An object, or nil
 */
@property (readonly) id value;

@end
