//
//  testStatus.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.08.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "KTSystemManagement.h"

#import "Restkit/Restkit.h"
#import "testResponseLoader.h"
#import "KTStatusItem.h"
#import "testCase.h"


@interface testStatus : XCTestCase

@end

@implementation testStatus{
    KTManager* webservice;
}

- (void)setUp
{
    [super setUp];
    [testCase initialize];
    
    webservice  = [KTManager sharedManager];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


// /status
// / Status transitions
-(void)testGetStatusList{
    KTSystemManagement* systemManagement = [[KTSystemManagement alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [systemManagement performGetAvailableStatusList:responseLoader ];
    [responseLoader waitForResponse];
    
    
    NSArray* results = [responseLoader objects];
    
    XCTAssert(results!=nil, @"Results should not be nil");
    XCTAssert(results.count>0, @"Status list should have some items");
    
}


-(void)testGetStatusChangeActions{
    KTSystemManagement* systemManagement = [[KTSystemManagement alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [systemManagement performGetStatusChangeActionList:responseLoader];
    [responseLoader waitForResponse];
    
    
    NSArray* results = [responseLoader objects];
    
    XCTAssert(results!=nil, @"Results should not be nil");
    XCTAssert(results.count>0, @"StatusChangeAction list should have some items");
    
}


@end
