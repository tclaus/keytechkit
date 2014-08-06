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
    
    // Webservice startet initiale Verbindung zum Dienst
    _webservice = [KTManager sharedManager];
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
    
}

/**
 Test to get a invalid Element. No element with this key should be found. But response array should not be nil.
 */
-(void)testGetInvalidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [keytech performGetElement:@"dummyItem" withMetaData:YES loaderDelegate:responseLoader];
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array!=nil) XCTFail(@"The results array should be nil");

    
}

/**
 Tests for returning a valid element. At least one element should be found.
 */
-(void)testGetValidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    

    [keytech performGetElement:elementKeyWithStructure withMetaData:NO loaderDelegate:responseLoader];
    [responseLoader waitForResponse];
    
    NSObject *theElement = [responseLoader firstObject];
    
    if (theElement==nil) XCTFail(@"The result should not be nil");

}

-(void)testGetValidElementWithFullAttributes{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    
    [keytech performGetElement:elementKeyWithStructure withMetaData:KTResponseFullAttributes loaderDelegate:responseLoader];
    [responseLoader waitForResponse];
    
    NSObject *theResponse = [responseLoader firstObject];
    
    if (theResponse==nil) XCTFail(@"The result should not be nil");
    
    KTElement *theElement = (KTElement*)theResponse;
    
    if (theElement.keyValueList.count==0) {
        XCTFail(@"Key Value LIst should not be empty");
    }
        
    
    
}


/**
 Performs a search for 'dampf'..
 */
-(void)testSearch{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];

    [keytech performSearch:@"dampf" loaderDelegate:responseLoader];
    
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

/**
 Try to request a files list from an invaid elementkey. Should return a valid array object.
 */
-(void)testGetFilesFromInvalidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    // Fetching a files List with an invalid elementkey
    [keytech performGetFileList:@"invalidItemKey" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array!=nil) XCTFail(@"The results array should be nil");
   // if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",[array count]);
    
    
}

/**
 Try to request a files list from an well known element with files. Should return some files in a list.
 */
-(void)testGetFilesFromValidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
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
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    // Fetching a notes List. Element 3DMISC_SLDASM:2220 should have some files
    [keytech performGetElementNotes:@"invalidItemKey" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array!=nil) XCTFail(@"The results array should be nil");
    //if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",[array count]);
    
    
}

/**
 Fetching the whereused list
 */
-(void)testGetElementWhereUsed{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [keytech performGetElementWhereUsed:@"2DMISC_SLDDRW:2221" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one note was expected but we found %ld",(long)[array count]);
    
    
}

-(void)testGetElementNotes{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    // Fetching a notes List. Element 3DMISC_SLDASM:2220 should have some files
    [keytech performGetElementNotes:@"2DMISC_SLDDRW:2221" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one note was expected but we found %ld",(long)[array count]);
    
    
}
-(void)testGetElementBOM{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [keytech performGetElementBom:@"Default_MI:2088" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one note was expected but we found %ld",(long)[array count]);
    
    
}

-(void)testGetElementNextAvailableStatus{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [keytech performGetElementNextAvailableStatus:@"DEFAULT_MI:2088"  loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one note was expected but we found %ld",(long)[array count]);
    
    
}

-(void)testGetElementStructure{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    // Fetching a notes List. Element 3DMISC_SLDASM:2220 should have some files
    [keytech performGetElementStructure:@"2DMISC_SLDDRW:2221" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one note was expected but we found %ld",(long)[array count]);
    
    
}



@end
