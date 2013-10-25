//
//  MOMethodDescription.h
//  Mocha
//
//  Created by Logan Collins on 5/26/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOMethodDescription
 * @abstract A description of an Objective-C method
 */
@interface MOMethodDescription : NSObject

/*!
 * @method methodWithSelector:typeEncoding:
 * @abstract Creates a new method
 * 
 * @param selector
 * The selector of the method
 * 
 * @param typeEncoding
 * The type encoding of the method
 * 
 * @result An MOMethodDescription object
 */
+ (MOMethodDescription *)methodWithSelector:(SEL)selector typeEncoding:(NSString *)typeEncoding;

/*!
 * @property selector
 * @abstract The selector of the method
 * 
 * @result A SEL value
 */
@property (readonly) SEL selector;

/*!
 * @property typeEncoding
 * @abstract The type encoding of the method
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *typeEncoding;

@end
