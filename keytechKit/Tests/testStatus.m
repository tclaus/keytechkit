//
//  testStatus.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.08.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Webservice.h"
#import "KTSystemManagement.h"

#import "Restkit/Restkit.h"
#import "testResponseLoader.h"
#import "KTStatusItem.h"

@interface testStatus : XCTestCase

@end

@implementation testStatus{
    Webservice* webservice;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    webservice  = [Webservice sharedWebservice];
    
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
// Test Status actions


-(void)testGetElementStatusHistory{

    KTKeytech *keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [keytech performGetElementStatusHistory:@"3dmisc_sldprt:2156" loaderDelegate:responseLoader];
    [responseLoader waitForResponse];
    
    
    NSArray* results = [responseLoader objects];
    
    XCTAssert(results!=nil, @"Results should not be nil");
    XCTAssert(results.count>0, @"Status History list should have some items");
    
}

@end
