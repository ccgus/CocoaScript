//
//  MOInstanceVariableDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOInstanceVariableDescription
 * @abstract A description of an Objective-C instance variable
 */
@interface MOInstanceVariableDescription : NSObject

/*!
 * @method instanceVariableWithName:typeEncoding:
 * @abstract Creates a new instance variable
 * 
 * @param name
 * The name of the instance variable
 * 
 * @param typeEncoding
 * The type encoding of the instance variable
 * 
 * @result An MOInstanceVariableDescription object
 */
+ (MOInstanceVariableDescription *)instanceVariableWithName:(NSString *)name typeEncoding:(NSString *)typeEncoding;


/*!
 * @property name
 * @abstract The name of the instance variable
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *name;

/*!
 * @property typeEncoding
 * @abstract The type encoding of the instance variable
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *typeEncoding;

@end
