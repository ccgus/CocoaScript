//
//  MOAllocator.h
//  Mocha
//
//  Created by Logan Collins on 7/25/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOAllocator
 * @abstract A proxy used to represent the result of -alloc.
 * 
 * @discussion
 * Some Cocoa classes do not play well when the result of -alloc
 * is sent messages other than an initializer. As such, this object
 * serves as a proxy to delay allocation of the object until it is sent
 * its initialization message.
 * 
 * Any unimplemented message sent to this class will be forwarded to
 * the target object class. This will always be something along the lines
 * of -init or -initWith*:
 */
@interface MOAllocator : NSObject

/*!
 * @method allocator
 * @abstract Creates a new allocator
 * 
 * @result An MOAllocator object
 */
+ (MOAllocator *)allocator;

/*!
 * @property objectClass
 * @abstract The target object class
 * 
 * @result A Class object
 */
@property (unsafe_unretained) Class objectClass;

@end
