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
 Simply allocates the base keytech class. Basic initialiation of variables.
 */
-(void)testAllocKeytechClass{
    KTKeytech* keytech = [[KTKeytech alloc]init];
    if (!keytech) XCTFail(@"Could not allocate keytech class");
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


/**
 Performs a search for 'dampf'..
 */
-(void)testSearch{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];

    [keytech performSearch:@"keytech" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",(int)[array count]);
    
}

-(void)testSearchByFields{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    NSArray *fields = @[@"as_do__status=in Arbeit",@"as_do__version=-"];
    
    
    [keytech performSearch:nil fields:fields inClass:nil page:1 pageSize:25 loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",(int)[array count]);
    
    // Response should only have items with this fields
    for (KTElement* element in array) {
        
        if (![element.itemVersion isEqualToString:@"-"]) {
            XCTFail(@"An invalid element (version) was returned");
            return;
        }
        if (![element.itemStatus isEqualToString:@"in Arbeit"]) {
            XCTFail(@"An invalid element (status) was returned");
            return;
        }
        
    }
}

-(void)testSearchByFieldsAndFullText{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    NSArray *fields = @[@"as_do__status=in Arbeit",@"as_do__version=-"];
    
    
    [keytech performSearch:@"dampf" fields:fields inClass:nil page:1 pageSize:25 loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",(int)[array count]);
    
    // Response should only have items with this fields
    for (KTElement* element in array) {
        
        if (![element.itemVersion isEqualToString:@"-"]) {
            XCTFail(@"An invalid element (version) was returned");
            return;
        }
        if (![element.itemStatus isEqualToString:@"in Arbeit"]) {
            XCTFail(@"An invalid element (status) was returned");
            return;
        }
        
    }

    
}


-(void)testSearchByFieldsAndFullTextAndInClasses{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    NSArray *fields = @[@"as_do__status=in Arbeit",@"as_do__version=-"];
    
    
    [keytech performSearch:@"dampf" fields:fields inClass:@"" page:1 pageSize:25 loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",(int)[array count]);
    
    // Response should only have items with this fields
    for (KTElement* element in array) {
        
        if (![element.itemVersion isEqualToString:@"-"]) {
            XCTFail(@"An invalid element (version) was returned");
            return;
        }
        if (![element.itemStatus isEqualToString:@"in Arbeit"]) {
            XCTFail(@"An invalid element (status) was returned");
            return;
        }
        
        if(![element.itemClassType isEqualToString:@"DO"]){
            XCTFail(@"An invalid element (Classtype!=DO) was returned");
            return;
            
        }
        
    }
    
    
}







@end
