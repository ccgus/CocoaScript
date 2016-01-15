//
//  MOBoxManager.h
//  
//
//  Created by Sam Deane on 16/12/2015.
//
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class MOBox;


/**
 Manages the boxing and un-boxing of non-JS objects.
 
 For each object, we keep a "box", which ties together a JS object reference and an Objective C object.
 
 The JS object's private data pointer points to an MOBox instance. This allows us to take a JS object ref
 and look up the corresponding Obj-C object. It also ensures that the Obj-C object lives as long as the JS ref.
 
 The MOBox instances are stored in a strong map, keyed with the Obj-C object, which allows us to go in
 the other direction and look up a JS object ref from the Obj-C object.
 
 The MOBox has a strong reference to the Obj-C object, and also an unprotected reference to the JS object.
 
 When a JS reference is no longer needed, it should be garbage collected, at which point our finalize callback
 will be called and we will remove the corresponding box (thus potentially releasing the Obj-C object).
 
 When an Obj-C object is longer referenced externally, we will continue to retain it, until such time as there
 are no more JS references to it.
 
 Note that the JS object does not increment the retain count for the MOBox object. 
 We ensure that there's a retain cycle MOBox -> object -> index -> MOBox, which keeps the box and its object
 alive whilst the JS object is alive.
 */

@interface MOBoxManager : NSObject

- (instancetype)initWithContext:(JSGlobalContextRef)context;
- (void)cleanup;
- (MOBox*)boxForObject:(id)object;
- (JSObjectRef)makeBoxForObject:(id)object jsClass:(JSClassRef)jsClass;
- (void)removeBoxForObject:(id)object;
@end
