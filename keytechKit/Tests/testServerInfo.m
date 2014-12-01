//
//  testServerInfo.m
//  keytechKit
//
//  Created by Thorsten Claus on 07.08.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "KTServerInfo.h"
#import "testCase.h"

@interface testServerInfo : XCTestCase {
    KTManager *_webService;
}

@end

@implementation testServerInfo

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [testCase initialize];
    
    _webService = [KTManager sharedManager];
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/// Reloads the ServerInfo
- (void)testReloadServerInfo {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Serverinfo reloaded"];
    
    [[KTServerInfo serverInfo] reloadWithCompletionBlock:^(NSError *error) {
        [expectation fulfill];
        if (!error) {
            KTServerInfo *serverInfo = [KTServerInfo serverInfo];
            XCTAssertNotNil(serverInfo.serverID,@"ServerID should not be nil");
            
        } else {
            XCTFail(@"Error reloading ServerInfo: %@",error);
        }
        
    }];
    
    
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Failed fetching a file: %@",error);
        }
        
    }];
    
}

- (void)testLoadServerInfo {
    KTServerInfo *serverInfo = [[KTServerInfo alloc]init];

    XCTAssertNil(serverInfo.serverID,@"ServerID Info should be nil when not loaded");
    
    [serverInfo reload];
    
    XCTAssertNotNil(serverInfo.serverID,@"ServerID should not be nil");
    XCTAssertNotNil(serverInfo.databaseVersion,@"Databaseversion should not be nil");
    XCTAssertNotNil(serverInfo.APIVersion,@"Version should not be nil");
    XCTAssertNotNil(serverInfo.licencedCompany,@"licencedCompany should not be nil");

    
}



@end
