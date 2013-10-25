//
//  MOPointerValue.h
//  Mocha
//
//  Created by Logan Collins on 7/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOPointerValue
 * @abstract An object representation of a C pointer value
 */
@interface MOPointerValue : NSObject

/*!
 * @method initWithPointerValue:typeEncoding:
 * @abstract Creates a new pointer value
 * 
 * @param pointerValue
 * The C pointer value
 * 
 * @param typeEncoding
 * The type encoding of the pointer
 * 
 * @result An MOPointerValue object
 */
- (id)initWithPointerValue:(void *)pointerValue typeEncoding:(NSString *)typeEncoding;


/*!
 * @property pointerValue
 * @abstract The C pointer value
 * 
 * @result A void pointer value
 */
@property (readonly) void * pointerValue;

/*!
 * @property typeEncoding
 * @abstract The type encoding of the pointer
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *typeEncoding;

@end
