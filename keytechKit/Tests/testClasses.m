//
//  testClasses.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 24.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"

@interface testClasses : XCTestCase


@end

/**
 Tests keytech classes: Classlayouts / Bom Layouts, Lister configuration
 */
@implementation testClasses
{
    KTManager* _webservice;
    NSString* elementKeyWithStructure;
    NSString* classKey;
    KTKeytech* keytech;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    _webservice = [KTManager sharedWebservice];
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



/// Gets a full classlist
-(void)testGetClasslist{

    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [[keytech ktSystemManagement]performGetClasslist:responseLoader];
    
    [responseLoader waitForResponse];
    XCTAssertNotNil(responseLoader.objects, @"Classlist should not be NIL");

    XCTAssertTrue(responseLoader.objects.count>0, @"Classlist should have some classes");

}

-(void)testGetClass{
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    // Test get the base Document class (with %_DO notation)
    [[keytech ktSystemManagement]performGetClass:@"%_DO" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    XCTAssertNotNil(responseLoader.firstObject, @"Class (FirstObject) should not be NIL");
    
    
    // Test get the base Document class (with default_DO notation)
    [[keytech ktSystemManagement]performGetClass:@"DEFAULT_DO" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    XCTAssertNotNil(responseLoader.firstObject, @"Class (FirstObject) should not be NIL");
    
    
    
}

-(void)testClassArchiving{

    NSArray *listOfClasses;
    
    // Get some Classes
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    [[keytech ktSystemManagement]performGetClasslist:responseLoader];
    [responseLoader waitForResponse];
    XCTAssertNotNil(responseLoader.objects, @"Classlist should not be NIL");
    XCTAssertTrue(responseLoader.objects.count>0, @"Classlist should have some classes");
    
    listOfClasses = responseLoader.objects;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:listOfClasses];
    XCTAssertNotNil(data, @"Archived Data should not be nil");
    
    NSArray *target = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(target, @"Unacrhived classlist should not be nil");
    
    
    
}

/// Gets a editorlayout for the requested element.
-(void)testGetEditorLayoutForElement{
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];

    [keytech performGetClassEditorLayoutForClassKey:classKey loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");

    
}

/// Gets a Lister layout for the requested Element
-(void)testGetListerLayoutForElement{
    
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    [keytech performGetClassListerLayout:classKey loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");

    
}

/// Gets the default BOM lister layout for the element.
-(void)testGetBomListerlayout{
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    [keytech performGetClassBOMListerLayout:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"One Element was expected");
 
}

@end






