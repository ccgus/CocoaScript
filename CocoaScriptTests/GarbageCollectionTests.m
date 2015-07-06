//
//  GarbageCollectionTests.m
//  Cocoa Script
//
//  Created by Adam Fedor on 7/6/15.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "COScript.h"

@interface GarbageCollectionTests : XCTestCase

@end

@implementation GarbageCollectionTests
{
    COScript *jsContext;
    NSURL *testScriptURL;
}

- (void)setUp {
    [super setUp];
    testScriptURL = [[NSBundle bundleForClass: [self class]] resourceURL];
    jsContext = [[COScript alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark Simple Scripts
- (void)testCallFunctionWithName_WithSimpleAdd
{
    [jsContext executeString: @"function add() { return 1 + 1}"];
    
    id result = [jsContext executeString: @"add()"];
    XCTAssertTrue([result isEqualTo: @(2)], @"Adding doesnt work");
}

- (void)testCallFunctionWithName_WithSimpleAddMultipleTimes
{
    [jsContext executeString: @"function add() { return 1 + 1}"];
    
    id result;
    for (NSInteger i = 0; i < 1000; i++) {
        result = [jsContext executeString: @"add()"];
    }
    XCTAssertTrue([result isEqualTo: @(2)], @"Adding multiple doesnt work");
}

- (void)testCallFunctionWithName_WithObjectFunction
{
    [jsContext executeString: @"function myfunc() { var dict = NSMutableDictionary.dictionary(); \
     dict.setObject_forKey_(\"foobar\", \"string\"); return 2;}"];
    
    id result = [jsContext executeString: @"myfunc()"];
    XCTAssertTrue([result isEqualTo: @(2)], @"Myfunc doesnt work");
}

- (void)testCallFunctionWithName_WithObjectFunctionMultipleTimes
{
    [jsContext executeString: @"function myfunc() { var dict = NSMutableDictionary.dictionary(); \
     dict.setObject_forKey_(\"foobar\", \"string\"); return 2;}"];
    
    id result;
    for (NSInteger i = 0; i < 1000; i++) {
        result = [jsContext executeString: @"myfunc()"];
    }
    XCTAssertTrue([result isEqualTo: @(2)], @"Myfunc multiple doesnt work");
}

- (void)testCallFunctionWithName_WithIdenticalProperties_CanChangeEachPropertySeperately
{
    [jsContext executeString: @"function myfunc() { \
     var dict1 = NSMutableDictionary.dictionary(); \
     var dict2 = NSMutableDictionary.dictionary(); \
     dict1.setObject_forKey_(\"foobar\", \"string\"); \
     print(\"dict1 is \" + dict1); \
     print(\"dict2 is \" + dict2); \
     return dict2.count();}"];
    
    id result = [jsContext executeString: @"myfunc()"];
    XCTAssertTrue([result isEqualTo: @(0)], @"Setting mutable dictionary doesnt work");
}

#pragma mark Stored Scripts

- (void)testUsingCoreGraphicsScript_ShouldRun {
    NSURL *URL = [testScriptURL URLByAppendingPathComponent: @"CoreGraphics.js"];
    NSError *error = nil;
    NSString *testScript = [NSString stringWithContentsOfURL:URL usedEncoding:NULL error:&error];
    
    XCTAssertNotNil(testScript, @"Error loading test script: %@", error);
    
    [jsContext executeString:testScript];
    
    NSArray *result = [jsContext executeString:@"main()"];
    XCTAssertTrue([result[0] boolValue], @"%@", result[1]);
    result = nil;
}

#pragma mark Memory Allocation
- (void)test_10_UsingMemoryAllocationScript_ShouldRun {
    NSURL *URL = [testScriptURL URLByAppendingPathComponent: @"JSMemoryAllocation.js"];
    NSError *error = nil;
    NSString *testScript = [NSString stringWithContentsOfURL:URL usedEncoding:NULL error:&error];
    
    XCTAssertNotNil(testScript, @"Error loading test script: %@", error);
    
    [jsContext executeString:testScript];
    
    NSArray *result = [jsContext callFunctionNamed: @"main" withArguments: @[@(10)]];
    XCTAssertTrue([result[0] boolValue], @"%@", result[1]);
}

- (void)test_11_UsingMemoryAllocationScript_ShouldRun {
    NSURL *URL = [testScriptURL URLByAppendingPathComponent: @"MemoryAllocation.js"];
    NSError *error = nil;
    NSString *testScript = [NSString stringWithContentsOfURL:URL usedEncoding:NULL error:&error];
    
    XCTAssertNotNil(testScript, @"Error loading test script: %@", error);
    
    [jsContext executeString:testScript];
    
    NSArray *result = [jsContext callFunctionNamed:@"main" withArguments: @[@(10)]];
    XCTAssertTrue([result[0] boolValue], @"%@", result[1]);
}

- (void)test_12_UsingJSMemoryAllocationScript_WithMoreIterations_ShouldRunFast {
    NSURL *URL = [testScriptURL URLByAppendingPathComponent: @"JSMemoryAllocation.js"];
    NSError *error = nil;
    NSString *testScript = [NSString stringWithContentsOfURL:URL usedEncoding:NULL error:&error];
    
    XCTAssertNotNil(testScript, @"Error loading test script: %@", error);
    
    [jsContext executeString:testScript];
    
    __block NSArray *result;
    [self measureBlock:^{
        result = [jsContext callFunctionNamed:@"main" withArguments: @[@(5000)]];
    }];
    XCTAssertTrue([result[0] boolValue], @"%@", result[1]);
}

- (void)test_13_UsingMemoryAllocationScript_WithMoreIterations_ShouldRunFast {
    NSURL *URL = [testScriptURL URLByAppendingPathComponent: @"MemoryAllocation.js"];
    NSError *error = nil;
    NSString *testScript = [NSString stringWithContentsOfURL:URL usedEncoding:NULL error:&error];
    
    XCTAssertNotNil(testScript, @"Error loading test script: %@", error);
    
    [jsContext executeString:testScript];
    
    __block NSArray *result;
    [self measureBlock:^{
        result = [jsContext callFunctionNamed:@"main" withArguments: @[@(500)]];
    }];
    XCTAssertTrue([result[0] boolValue], @"%@", result[1]);
}

#pragma mark Garbage Collection
/* Takes ~.7 sec on a 2011 Mini  */
- (void)test_14_UsingJSMemoryAllocationScript_WithHugeNumberOfIterations_ShouldNotCrash {
    NSURL *URL = [testScriptURL URLByAppendingPathComponent: @"JSMemoryAllocation.js"];
    NSError *error = nil;
    NSString *testScript = [NSString stringWithContentsOfURL:URL usedEncoding:NULL error:&error];
    
    XCTAssertNotNil(testScript, @"Error loading test script: %@", error);
    
    [jsContext executeString:testScript];
    
    NSArray *result;
    result = [jsContext callFunctionNamed:@"main" withArguments: @[@(100000)]];
    XCTAssertTrue([result[0] boolValue], @"%@", result[1]);
}

/* Unfortunately this will just crash if it doesn't work. Takes ~70 sec on a 2011 Mini  */
- (void)test_15_UsingMemoryAllocationScript_WithHugeNumberOfIterations_ShouldNotCrash {
    NSURL *URL = [testScriptURL URLByAppendingPathComponent: @"MemoryAllocation.js"];
    NSError *error = nil;
    NSString *testScript = [NSString stringWithContentsOfURL:URL usedEncoding:NULL error:&error];
    
    XCTAssertNotNil(testScript, @"Error loading test script: %@", error);
    
    [jsContext executeString:testScript];
    
    NSArray *result;
    result = [jsContext callFunctionNamed:@"main" withArguments: @[@(100000)]];
    XCTAssertTrue([result[0] boolValue], @"%@", result[1]);
}

/* Unfortunately this will just crash if it doesn't work. Takes ~10 sec on a 2011 Mini  */
- (void)test_16_UsingGarbageCollect2Script_WithHugeNumberOfIterations_ShouldNotCrash {
    NSURL *URL = [testScriptURL URLByAppendingPathComponent: @"GarbageCollect2.js"];
    NSError *error = nil;
    NSString *testScript = [NSString stringWithContentsOfURL:URL usedEncoding:NULL error:&error];
    
    XCTAssertNotNil(testScript, @"Error loading test script: %@", error);
    [jsContext executeString: testScript];
    
    XCTAssertTrue(1, @"GarbageCollect2 Test did not run");
}

@end
