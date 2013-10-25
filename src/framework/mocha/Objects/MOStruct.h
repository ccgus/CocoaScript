//
//  MOStruct.h
//  Mocha
//
//  Created by Logan Collins on 5/15/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class MOStruct
 * @abstract An object representation of a C struct
 */
@interface MOStruct : NSObject

/*!
 * @method structureWithName:memberNames:
 * @abstract Creates a new structure
 * 
 * @param name
 * The name of the structure
 * 
 * @param memberNames
 * The ordered list of member names of the structure
 * 
 * @result An MOStruct object
 */
+ (MOStruct *)structureWithName:(NSString *)name memberNames:(NSArray *)memberNames;

/*!
 * @method initWithName:memberNames:
 * @abstract Creates a new structure
 * 
 * @param name
 * The name of the structure
 * 
 * @param memberNames
 * The ordered list of member names of the structure
 * 
 * @result An MOStruct object
 */
- (id)initWithName:(NSString *)name memberNames:(NSArray *)memberNames;


/*!
 * @property name
 * @abstract The name of the structure
 * 
 * @result An NSString object
 */
@property (copy, readonly) NSString *name;

/*!
 * @property memberNames
 * @abstract The ordered list of member names of the structure
 * 
 * @result An NSArray of NSString objects
 */
@property (copy, readonly) NSArray *memberNames;


/*!
 * @method objectForMemberName:
 * @abstract Gets the value for a specified member name
 * 
 * @param memberName
 * The member name
 * 
 * @discussion
 * This method raises an MORuntime exception if the structure has
 * no member named name.
 * 
 * @result An object, or nil
 */
- (id)objectForMemberName:(NSString *)name;

/*!
 * @method setObject:forMemberName:
 * @abstract Sets the value for a specified member name
 * 
 * @param obj
 * The new value
 * 
 * @param name
 * The member name
 * 
 * @discussion
 * This method raises an MORuntime exception if the structure has
 * no member named name.
 */
- (void)setObject:(id)obj forMemberName:(NSString *)name;

@end
