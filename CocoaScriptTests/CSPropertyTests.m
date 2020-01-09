//
//  MochaPropertyTests.m
//  Mocha
//
//  Created by Adam Fedor on 4/24/15.
//  Copyright (c) 2015 Sunflower Softworks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "Mocha.h"
#import <objc/runtime.h>
#import <CoreData/CoreData.h>

@interface Product : NSManagedObject
@property (nonatomic, retain) NSString * name;
@end
@implementation Product
@dynamic name;

@end

@interface MochaTestDynamicProperty : NSObject
@property NSString *testProperty;
@end
@implementation MochaTestDynamicProperty
@dynamic testProperty;

id dynamicMethodIMP(id self, SEL _cmd) {
  return [self valueForUndefinedKey: NSStringFromSelector(_cmd)];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
  if (aSEL == @selector(testProperty)) {
    class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "@@:");
    return YES;
  }
  return [super resolveInstanceMethod:aSEL];
}

- (id)valueForUndefinedKey:(NSString *)key
{
  return @"testValue";
}

@end

@interface MochaPropertyTests : XCTestCase
@end

@implementation MochaPropertyTests
{
  Mocha *runtime;
  NSURL *testModelURL;
  NSManagedObjectContext *moContext;
}

- (void)setUp {
  [super setUp];
  testModelURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"Model" withExtension:@"momd"];
  runtime = [[Mocha alloc] init];

  NSError *error = nil;
  NSPersistentStoreCoordinator *coordinator = nil;
  NSManagedObjectModel *model = nil;
  moContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  model = [[NSManagedObjectModel alloc] initWithContentsOfURL: testModelURL];
  coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    
  [coordinator addPersistentStoreWithType: NSInMemoryStoreType
                              configuration: nil
                                        URL: [NSURL fileURLWithPath: @"/tmp/testmodel"]
                                    options: 0
                                                               error: &error];
  [moContext setPersistentStoreCoordinator: coordinator];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCallDynamicProperty_ShouldReturnSimpleObject
{
  MochaTestDynamicProperty *dynamicObject = [[MochaTestDynamicProperty alloc] init];
  
  [runtime evalString: @"function getTestProperty(object) { return object.testProperty() }"];
  
  id result = [runtime callFunctionWithName:@"getTestProperty" withArgumentsInArray: @[dynamicObject]];
  XCTAssertEqual(result, @"testValue", @"Property not correct");
}

#pragma mark Managed Object Properties
- (void)testCallSubclassedManagedObjectProperty_ShouldReturnSimpleObject
{
  NSManagedObject *modelObject = [NSEntityDescription insertNewObjectForEntityForName: @"Product" inManagedObjectContext: moContext];
  [modelObject setValue: @"testValue" forKey: @"name"];
  
  [runtime evalString: @"function getTestProperty(object) { return object.name() }"];
  id result = [runtime callFunctionWithName:@"getTestProperty" withArgumentsInArray: @[modelObject]];
  
  XCTAssertEqual(result, @"testValue", @"Property not correct");
}

- (void)testSetSubclassedManagedObjectProperty_ShouldReturnSimpleObject
{
  NSManagedObject *modelObject = [NSEntityDescription insertNewObjectForEntityForName: @"Product" inManagedObjectContext: moContext];  
  [runtime evalString: @"function setTestProperty(object) { object.name = \"testValue\" }"];
  [runtime callFunctionWithName:@"setTestProperty" withArgumentsInArray: @[modelObject]];
  
  XCTAssertTrue([[modelObject valueForKey: @"name"] isEqualToString: @"testValue"], @"Property not set");
}

@end
