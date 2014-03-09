//
//  testLayout.m
//  keytechKit
//
//  Created by Thorsten Claus on 02.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Webservice.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"

@interface testLayout : XCTestCase

@end

@implementation testLayout
{
    Webservice* _webservice;
    KTKeytech* keytech;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    _webservice = [Webservice sharedWebservice];
    
    keytech = [[KTKeytech alloc]init];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLayoutArchiving
{
    NSArray *listOfClasses;
    
    // Get some Classes
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    [[keytech ktSystemManagement]performGetClasslist:responseLoader];
    [responseLoader waitForResponse];
    
    
    XCTAssertNotNil(responseLoader.objects, @"Layoutlist should not be NIL");
    XCTAssertTrue(responseLoader.objects.count>0, @"Layoutlist should have some classes");
    
    listOfClasses = responseLoader.objects;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:listOfClasses];
    XCTAssertNotNil(data, @"Archived Data should not be nil");
    
    NSArray *target = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(target, @"Unacrhived classlist should not be nil");
    

}

@end
