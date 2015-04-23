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
#import  "KTElement.h"
#import  "testCase.h"

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
    [testCase initialize];
    
    // Webservice startet initiale Verbindung zum Dienst
    _webservice = [KTManager sharedManager];
    elementKeyWithStructure = @"3DMISC_SLDASM:2220"; //* Element with structure on Test API}
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




/**
 Test if simple credentials (default values) are set
 */
-(void)testHasSimpleCredentials{
    NSString *username = _webservice.username;
    NSString *password = _webservice.password;
    NSString *serverURL = _webservice.servername;
    
    XCTAssertNotNil(username,@"Username should not be nil");
    XCTAssertNotNil(password,@"Password should not be nil");
    XCTAssertNotNil(serverURL,@"ServerURL should not be nil");
    
}







@end
