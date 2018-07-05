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
#import "KTTargetLink.h"
#import "TestDefaults.h"
#import "KTQueryDetail.h"

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
        
        [documentOpenExpectation fulfill];
        
    } failure:^(NSError *error) {
        XCTFail("Failed loading user");
        [documentOpenExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        
    }];
    
}

-(void)testUserFavorites {
    XCTestExpectation *loadUserExpectation = [self expectationWithDescription:@"load user"];
    
    __block KTUser * jgrantUser;
    
    [KTUser loadUserWithKey:@"jgrant"success:^(KTUser *user) {
        jgrantUser = user;
        [loadUserExpectation fulfill];
    } failure:^(NSError *error) {
        
        XCTFail(@"Could not load a test user for loading favorites");
        [loadUserExpectation fulfill];
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

/**
 Tests user defined queries, some are with parameters
 */
-(void)testUserQueries {
    XCTestExpectation *loadUserExpectation = [self expectationWithDescription:@"load user"];
    
    __block KTUser * jgrantUser;
    
    [KTUser loadUserWithKey:@"jgrant"success:^(KTUser *user) {
        jgrantUser = user;
        [loadUserExpectation fulfill];
    } failure:^(NSError *error) {
        XCTFail(@"Could not load a test user for loading queries");
        [loadUserExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    XCTestExpectation *loadFavorites = [self expectationWithDescription:@"load queries"];
    if (jgrantUser) {
        
        [jgrantUser loadQueriesSuccess:^(NSArray <KTTargetLink*> *targetLinks) {
            if (!targetLinks) {
                XCTFail(@"Queries Links was empty");
            } else {
                // OK
            }
            [loadFavorites fulfill];
            
        } failure:^(NSError *error) {
            
            XCTFail(@"Queries loaded with errors");
            [loadFavorites fulfill];
        }];
    }
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}

/**
Tests user defined custom queries, some are with parameters
*/
-(void)testLoadUserQueries {
    
    XCTestExpectation *loadAllQueriesDetails = [self expectationWithDescription:@"load user query"];
    
    int customQuery = 759;
    
    [KTQueryDetail loadQueryDetailsUserKey:@"jgrant"
                                 queryID: customQuery
                                success:^(KTQueryDetail *ktQueryDetails) {
                                    
                                    if (!ktQueryDetails) {
                                        XCTFail(@"Failed loading query details");
                                    }
                                    [loadAllQueriesDetails fulfill];
                                    
                                } failure:^(NSError *error) {
                                    XCTFail(@"Error loading queries: %@", error);
                                    [loadAllQueriesDetails fulfill];
                                }];
    
     [self waitForExpectationsWithTimeout:30 handler:nil];
}


@end
