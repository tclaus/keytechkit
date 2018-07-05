//
//  keytechKitFramework_Tests.m
//  keytechKitFramework Tests
//
//  Created by Thorsten Claus on 01.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"
#import "TestDefaults.h"

/**
 Basic keytech framework tests.
 */
@interface testBaseKeytechKit : XCTestCase

@end

@implementation testBaseKeytechKit
{
        KTManager* _webservice;
        NSString* elementKeyWithStructure;
}
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    [TestDefaults initialize];
    
    // Initialize webservice for tests
    _webservice = [KTManager sharedManager];
    elementKeyWithStructure = @"3DMISC_SLDASM:2220"; //* Element with structure on Test API
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

-(void)testAllocWebservice
{
    KTManager* web = [KTManager sharedManager];
    if (!web) XCTFail(@"could not allocate webservice Class");
}

@end
