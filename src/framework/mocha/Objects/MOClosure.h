//
//  MOClosure.h
//  Mocha
//
//  Created by Logan Collins on 5/19/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOClosure
 * @abstract A thin wrapper around a block object
 */
@interface MOClosure : NSObject

/*!
 * @method closureWithBlock:
 * @abstract Creates a new closure
 * 
 * @param block
 * The block object
 *
 * @result An MOClosure object
 */
+ (MOClosure *)closureWithBlock:(id)block;

/*!
 * @method initWithBlock:
 * @abstract Creates a new closure
 *
 * @param block
 * The block object
 *
 * @result An MOClosure object
 */
- (id)initWithBlock:(id)block;


/*!
 * @property block
 * @abstract The block object
 * 
 * @result A block object
 */
@property (copy, readonly) id block;

/*!
 * @property callAddress
 * @abstract The address of the block's function pointer
 * 
 * @result A void pointer value
 */
@property (readonly) void * callAddress;

/*!
 * @property typeEncoding
 * @abstract The type encoding of the block
 * 
 * @result A const char * value
 */
@property (readonly) const char * typeEncoding;

@end
