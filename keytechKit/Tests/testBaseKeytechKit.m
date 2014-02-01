//
//  keytechKitFramework_Tests.m
//  keytechKitFramework Tests
//
//  Created by Thorsten Claus on 01.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Webservice.h"
#import "Restkit/Restkit.h"
#import "ResponseLoader.h"


/**
 Basic keytech framework tests.
 */
@interface testBaseKeytechKit : XCTestCase

@end

@implementation testBaseKeytechKit
{
        Webservice* _webservice;
        NSString* elementKeyWithStructure;
}
- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    // Webservice startet initiale Verbindung zum Dienst
    _webservice = [Webservice sharedWebservice];
    elementKeyWithStructure = @"3DMISC_SLDASM:2220"; //* Element with structure on Test API}
}


- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}







- (void)testExample
{
    XCTAssertTrue(YES, @"True");
}

-(void)testAllocWebservice
{
    Webservice* web = [[Webservice alloc]init];
    
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
    
    XCTAssertNotNil([RKObjectManager sharedManager].client.username,@"default username should not be nil");
    XCTAssertNotNil([RKObjectManager sharedManager].client.password,@"default password should not be nil");
}

/**
 Test to get a invalid Element. No element with this key should be found. But response array should not be nil.
 */
-(void)testGetInvalidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    
    [keytech performGetElement:@"dummyItem" withMetaData:YES loaderDelegate:responseLoader];
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");

    
}

/**
 Tests for returning a valid element. At least one element should be found.
 */
-(void)testGetValidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    

    [keytech performGetElement:elementKeyWithStructure withMetaData:NO loaderDelegate:responseLoader];
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");
    
    
}


/**
 Performs a search for 'dampf'..
 */
-(void)testSearch{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    [keytech performSearch:@"dampf" page:1 withSize:25 withScope:KTScopeAll loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",(int)[array count]);
    
    
}

/**
 Try to request a search Result with page number 0. Should return the first page.
 */
-(void)testSearchWithPageNumberZero{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    // Page:0 should return the first page
    [keytech performSearch:@"dampf" page:0 withSize:25 withScope:KTScopeAll loaderDelegate:responseLoader];

    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",(int)[array count]);
    
    
}

/**
 Try to request a files list from an invaid elementkey. Should return a valid array object.
 */
-(void)testGetFilesFromInvalidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    // Fetching a files List with an invalid elementkey
    [keytech performGetFileList:@"invalidItemKey" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
   // if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",[array count]);
    
    
}

/**
 Try to request a files list from an well known element with files. Should return some files in a list.
 */
-(void)testGetFilesFromValidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    // Fetching a files List. Element 3DMISC_SLDASM:2220 should have some files
    [keytech performGetFileList:@"3DMISC_SLDASM:2220" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
     if ([array count]==0) XCTFail(@"At least one element was expected but we found %ld",(long)[array count]);
    
    
}

/**
 Fetching some notes from invalid element. Should not return a nil value
 */
-(void)testGetNotesFromInvalidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    // Fetching a notes List. Element 3DMISC_SLDASM:2220 should have some files
    [keytech performGetElementNotes:@"invalidItemKey" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    //if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",[array count]);
    
    
}

/**
 Fetching some notes
 */
-(void)testGetElementNotes{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    // Fetching a notes List. Element 3DMISC_SLDASM:2220 should have some files
    [keytech performGetElementNotes:@"2DMISC_SLDDRW:2221" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one note was expected but we found %ld",(long)[array count]);
    
    
}




@end
