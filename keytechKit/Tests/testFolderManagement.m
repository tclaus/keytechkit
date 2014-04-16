//
//  testFolderManagement.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 04.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"

@interface testFolderManagement : XCTestCase

@end

@implementation testFolderManagement
{
    KTManager* webservice;
}
- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    webservice = [KTManager sharedWebservice];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

/**
 Getting folders without any parents. => Top level folder
 */
- (void)testGetRootFolderes
{
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];

    [[webservice ktKeytech] performGetRootFolder:responseLoader];
    [responseLoader waitForResponse];
    
    NSArray* foldersArray = [responseLoader objects];
    
    XCTAssertNotNil(foldersArray, @"root folders array was empty. At least a ampty array should be returned");
   // XCTAssertTrue(foldersArray.count>0, @"root folders list should not be empty.");

    
}

@end
