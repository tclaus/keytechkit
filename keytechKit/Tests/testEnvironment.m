//
//  testEnvironment.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 07.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Webservice.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"

@interface testEnvironment : XCTestCase

@end

@implementation testEnvironment
{
    Webservice* _webservice;
    NSString* testSearchString;
    KTKeytech* keytech;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    _webservice = [Webservice sharedWebservice];
    testSearchString = @"dampf"; //* a Search String 'dampf' or 'keytech'
    
    keytech = [[KTKeytech alloc]init];
    
}
- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

/// Performs a global Search.
-(void)testPerformSearch{
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [keytech performSearch:testSearchString loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");
    
}

/// Performs a global Search with minimal Pagesize of 1.
-(void)testPerformSearchWithMinimalPageSize{
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    [keytech performSearch:testSearchString page:1 withSize:2 withScope:KTScopeAll loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");
    // just 1 element!
}

/// Performs a Search with user defined query with minimal Pagesize of 1.
-(void)testPerformSearchByUserQuery{
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    [keytech performSearchByQuery:380 page:1 withSize:500 loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");
    // just 1 element!
}

@end
