//
//  testUser.m
//  keytechKit
//
//  Created by Thorsten Claus on 21.09.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTUser.h"
#import "KTManager.h"
#import "TestDefaults.h"

@interface testUser : XCTestCase

@end

@implementation testUser
static KTManager  *_webservice;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if (!_webservice) {
        [TestDefaults initialize];
        
        _webservice = [KTManager sharedManager];
    }
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadUser {

    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"userdata Loaded"];
    
    
    [KTUser loadUserWithKey:@"jgrant" success:^(KTUser *user) {
        
        XCTAssert(YES, @"Pass");
        [documentOpenExpectation fulfill];
        
    } failure:^(NSError *error) {
        XCTAssert(NO, @"Failure");
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        
    }];
    
    // This is an example of a functional test case.
    
}

-(void)testUserFavorites {
    XCTestExpectation *loadUserExpectation = [self expectationWithDescription:@"load user"];
    
    __block KTUser * jgrantUser;
    
    [KTUser loadUserWithKey:@"jgrant"success:^(KTUser *user) {
        jgrantUser = user;
        [loadUserExpectation fulfill];
    } failure:^(NSError *error) {
        [loadUserExpectation fulfill];
        XCTFail(@"Could not load a test user for loading favorites");
    }];

    [self waitForExpectationsWithTimeout:30 handler:nil];

    XCTestExpectation *loadFavorites = [self expectationWithDescription:@"loadFavorites"];
    if (jgrantUser) {
        
        [jgrantUser loadFavoritesSuccess:^(NSArray *targetLinks) {
            if (!targetLinks) {
                XCTFail(@"Favoites Links was empty");
               
            } else {
                // OK
            }
            
            [loadFavorites fulfill];
        } failure:^(NSError *error) {
            
            XCTFail(@"Favoites Links was empty");
            [loadFavorites fulfill];
        }];
    }
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
