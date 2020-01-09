//
//  MochaRuntimeObjectStorateTests.m
//  Cocoa Script
//
//  Created by Adam Fedor on 5/23/16.
//
//

#import <XCTest/XCTest.h>
#import "COScript.h"

static NSInteger deallocCalled = 0;

@interface GCObject : NSObject
@end
@implementation GCObject
- (void)dealloc
{
    deallocCalled += 1;
}
@end

@interface MochaRuntimeObjectStorateTests : XCTestCase

@end

@implementation MochaRuntimeObjectStorateTests
{
    COScript *jsContext;
}

- (void)setUp {
    [super setUp];
    jsContext = [[COScript alloc] init];
    deallocCalled = 0;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testStoreAndRemoveObject_ShouldDeallocateIt {
    @autoreleasepool {
        NSObject *object = [[GCObject alloc] init];
        [jsContext pushObject: object withName: @"testObject"];
        [jsContext executeString: @"function add() { var newObject = testObject; return newObject}"];
        [jsContext callFunctionNamed: @"add" withArguments: nil];
        [jsContext deleteObjectWithName: @"testObject"];
        object = nil;
    }
    
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.5]];

    XCTAssert(deallocCalled == 1, @"Object not deallocated");
}

@end
