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

@interface testServerInfo : XCTestCase {
    KTManager *_webService;
}

@end

@implementation testServerInfo

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
    _webService = [KTManager sharedManager];
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadServerInfo {
    KTServerInfo *serverInfo = [[KTServerInfo alloc]init];

    XCTAssertNil(serverInfo.serverID,@"ServerID Info should be nil when not loaded");
    
    [serverInfo reload];
    
    XCTAssertNotNil(serverInfo.serverID,@"ServeID should not be nil");
    XCTAssertNotNil(serverInfo.APIKernelVersion,@"KerbnelVersion should not be nil");
    XCTAssertNotNil(serverInfo.APIVersion,@"API Version should not be nil");
    XCTAssertNotNil(serverInfo.licencedCompany,@"licencedCompany should not be nil");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end