//
//  testLayout.m
//  keytechKit
//
//  Created by Thorsten Claus on 02.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"
#import "KTLayouts.h"
#import "TestDefaults.h"
#import "KTLayouts.h"

@interface testLayout : XCTestCase

@end

@implementation testLayout
{
    KTManager* _webservice;
    TestDefaults* _testcase;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    _testcase = [[TestDefaults alloc]init];
    [_testcase setUp];
    
    _webservice = [KTManager sharedManager];
    
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/// Test loading multiple layouts
-(void)testLoadLayout{
    KTLayouts *layoutClass = [[KTLayouts alloc]init];
    [layoutClass loadLayoutForClassKey:@"DEFAULT_DO"];
    [layoutClass loadLayoutForClassKey:@"DEFAULT_MI"];
    [layoutClass loadLayoutForClassKey:@"DEFAULT_FD"];

    // Wait until layout is loaded
    
#define POLL_INTERVAL 0.2 // 200ms
#define N_SEC_TO_POLL 3.0 // poll for 3s
#define MAX_POLL_COUNT N_SEC_TO_POLL / POLL_INTERVAL
    
    KTLayout *doLayout = [layoutClass layoutForClassKey:@"DEFAULT_DO"];
    KTLayout *fdLayout = [layoutClass layoutForClassKey:@"DEFAULT_FD"];
    KTLayout *miLayout = [layoutClass layoutForClassKey:@"DEFAULT_MI"];
    
    
    NSUInteger pollCount = 0;
    while (!([doLayout isLoaded] && [fdLayout isLoaded] && [miLayout isLoaded]) && (pollCount < MAX_POLL_COUNT)) {
        NSDate* untilDate = [NSDate dateWithTimeIntervalSinceNow:POLL_INTERVAL];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
        pollCount++;
    }
    
    XCTAssertTrue([doLayout isLoaded] && [fdLayout isLoaded] && [miLayout isLoaded],
                  @"Layouts are not loaded. ");
    
    
}

/// Loads bom layout
-(void)testLoadBomListerLayout{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Layout loaded" ];
    
    
    [[KTLayouts sharedLayouts] loadListerLayoutForBOM:^(NSArray *controls) {
        XCTAssertNotNil(controls,@"Bom Lister controls should not be empty");
        [expectation fulfill];
        
    } failure:^(NSError *error) {
        XCTFail(@"An error occured loading layouts: %@",error);
        [expectation fulfill];

    }];
    
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);

        }
    }];
    
}


/// Loads globl lister layout
-(void)testLoadGlobalListerLayout{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Layout loaded" ];
    
    
    [[KTLayouts sharedLayouts] loadLayoutForClassKey:@"DEFAULT_DEFAULT"
                                             success:^(KTLayout *layout) {
                                                 XCTAssertNotNil(layout.listerLayout,@"Global lister layout should not be empty");
                                                 [expectation fulfill];
                                                 
                                             } failure:^(NSError *error) {
                                                 XCTFail(@"An error occured loading flobal layout: %@",error);
                                                 [expectation fulfill];
                                                 //
                                             }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
            
        }
    }];
    
}

@end
