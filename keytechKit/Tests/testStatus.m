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
   
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Status load"];
    
    
    __block NSArray *_statusList;
    
    [KTStatusItem loadStatusListSuccess:^(NSArray *statusList) {
        [expectation fulfill];
        _statusList = statusList;
        
    } failure:^(NSError *error) {
        [expectation fulfill];
         XCTFail(@"Error loading statuslist: %@",error);
    } ];

    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
    
        if (error){
            NSLog(@"error: %@",error);
        } else {
            if (_statusList==nil) XCTFail(@"The result should not be nil");
            if (_statusList.count==0) {
                XCTFail(@"Statuslist should have some statusitems");
            }
        }
    }];
    
    
}

-(void)testStatus{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Status load"];
    
    
    __block NSArray *_statusList;
    
    [KTStatusItem loadStatusListSuccess:^(NSArray *statusList) {
        [expectation fulfill];
        _statusList = statusList;
        
    } failure:^(NSError *error) {
        [expectation fulfill];
        XCTFail(@"Error loading statuslist: %@",error);
    } ];
    
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        
        if (error){
            NSLog(@"error: %@",error);
        } else {
            if (_statusList==nil) XCTFail(@"The result should not be nil");
            if (_statusList.count==0) {
                XCTFail(@"Statuslist should have some statusitems");
            }
        }
    }];
    
    
    KTStatusItem *statusItem = _statusList[0];

    XCTAssertNotNil(statusItem.statusID,@"StatusID should not be nil");
    XCTAssertNotNil(statusItem.statusImageName,@"statusImageNAme should not be nil");
    XCTAssertNotNil(statusItem.statusRestriction,@"statusRestriction shoud not be nil");
    
}



@end
