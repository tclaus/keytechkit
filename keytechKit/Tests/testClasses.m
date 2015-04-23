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
#import "testCase.h"
#import "KTClass.h"


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

}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    [testCase setUp];
    _webservice = [KTManager sharedManager];
    elementKeyWithStructure = @"3DMISC_SLDASM:2220"; //* Element with structure on Test API}
    classKey = @"3DMISC_SLDASM";
  
    
}

- (void)tearDown
{
 
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}



/// Gets a full classlist
-(void)testGetClasslist{

    __block NSArray *_results;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Classlist Loaded"];
    
    [KTClass loadClassListSuccess:^(NSArray *classList) {
        _results = classList;
        [expectation fulfill];
        
    } failure:^(NSError *error) {
        [expectation fulfill];
        
    }];
    

    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    XCTAssertNotNil(_results,@"Classlist should not be nil");
    XCTAssert((_results.count>0),@"Classlist should have at least one class");
              

}

-(void)testGetClass{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Classlist Loaded"];
    __block KTClass *_class;
    
    [KTClass loadClassByKey:@"DEFAULT_MI"
                    success:^(KTClass *ktclass) {
                        _class = ktclass;
                        [expectation fulfill];
                    } failure:^(NSError *error) {
                        [expectation fulfill];
                        
                    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    XCTAssertNotNil(_class,@"A default_MI class should have been loaded");
    XCTAssertNotNil(_class.classKey,@"a classkey should fe filled");
    
}



@end






