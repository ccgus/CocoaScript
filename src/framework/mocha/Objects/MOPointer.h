//
//  MOPointer.h
//  Mocha
//
//  Created by Logan Collins on 7/31/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOPointer
 * @abstract A pointer to a value
 */
@interface MOPointer : NSObject

/*!
 * @method initWithValue:
 * @abstract Creates a new pointer
 * 
 * @param value
 * The value for the pointer
 * 
 * @result An MOPointer object
 */
- (id)initWithValue:(id)value;


/*!
 * @property value
 * @abstract The value of the pointer
 * 
 * @result An object, or nil
 */
@property (strong, readonly) id value;

@end
