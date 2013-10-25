//
//  MOObjCRuntime.h
//  Mocha
//
//  Created by Logan Collins on 5/16/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MochaDefines.h"


/*!
 * @enum MOObjcOwnershipRule
 * @abstract Objective-C ownership rules
 * 
 * @constant MOObjCOwnershipRuleAssign      Assigned (unretained)
 * @constant MOObjCOwnershipRuleRetain      Retained
 * @constant MOObjCOwnershipRuleCopy        Copied/retained
 */
typedef MOCHA_ENUM(NSUInteger, MOObjCOwnershipRule) {
    MOObjCOwnershipRuleAssign = 0,
    MOObjCOwnershipRuleRetain,
    MOObjCOwnershipRuleCopy,
};


/*!
 * @class MOObjCRuntime
 * @abstract Interface bridge to the Objective-C runtime
 */
@interface MOObjCRuntime : NSObject

/*!
 * @method sharedRuntime
 * @abstract Gets the shared runtime instance
 * 
 * @result An MOObjCRuntime object
 */
+ (MOObjCRuntime *)sharedRuntime;


/*!
 * @property classes
 * @abstract Gets the names of all classes registered with the runtime
 * 
 * @discussion
 * This method will ignore any classes that begin with an underscore, as
 * convention is that they are considered private.
 * 
 * @result An NSArray of NSString objects
 */
@property (copy, readonly) NSArray *classes;

/*!
 * @property protocols
 * @abstract Gets the names of all protocols registered with the runtime
 * 
 * @discussion
 * This method will ignore any protocols that begin with an underscore, as
 * convention is that they are considered private.
 * 
 * @result An NSArray of NSString objects
 */
@property (copy, readonly) NSArray *protocols;

@end
