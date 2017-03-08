//
//  MOBoxManagerBoxContext.h
//
//
//  Created by Sam Deane on 14/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class MOBoxManager;

/**
 Represents the setup informaton for a box.

 An instance of this class is initially assigned as the private data
 for a new javascript object that is going to be boxed. When the
 javascript object's initialize callback is called, the context is used
 to finish making the box object.

 */

@interface MOBoxManagerBoxContext : NSObject
- (id)initWithManager:(MOBoxManager*)manager object:(id)object;
- (void)finishMakingBoxForObject:(JSObjectRef)jsObject;
@end
