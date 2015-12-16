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

@interface MOBoxManager : NSObject
- (instancetype)initWithContext:(JSGlobalContextRef)context;
- (void)cleanup;
- (MOBox*)boxForObject:(id)object;
- (JSObjectRef)makeBoxForObject:(id)object jsClass:(JSClassRef)jsClass;
- (void)removeBoxForObject:(id)object;
@end
