//
//  testClasses.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 24.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Webservice.h"
#import "Restkit/Restkit.h"
#import "ResponseLoader.h"

@interface testClasses : XCTestCase


@end

/**
 Tests keytech classes: Classlayouts / Bom Layouts, Lister configuration
 */
@implementation testClasses
{
    Webservice* _webservice;
    NSString* elementKeyWithStructure;
    NSString* classKey;
    KTKeytech* keytech;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    _webservice = [Webservice sharedWebservice];
    elementKeyWithStructure = @"3DMISC_SLDASM:2220"; //* Element with structure on Test API}
    classKey = @"3DMISC_SLDASM";
    
    keytech = [[KTKeytech alloc]init];
    
}

- (void)tearDown
{
    
    keytech = nil;
    
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

/// Gets a editorlayout for the requested element.
-(void)testGetEditorLayoutForElement{
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];

    
    [keytech performGetClassEditorLayoutForClassKey:classKey loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");

    
}

/// Gets a Lister layout for the requested Element
-(void)testGetListerLayoutForElement{
    
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    [keytech performGetClassListerLayout:classKey loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");

    
}

/// Gets the default BOM lister layout for the element.
-(void)testGetBomListerlayout{
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    [keytech performGetClassBOMListerLayout:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");
 
}

@end






