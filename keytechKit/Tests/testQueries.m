
//
//  testQueries.m
//  keytechKit
//
//  Created by Thorsten Claus on 27.09.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "KTQuery.h"
#import "testCase.h"

@interface testQueries : XCTestCase

@end

@implementation testQueries{
    KTManager *_webservice;
    KTPagedObject *_pagedObject;
}

- (void)setUp {
    [super setUp];
    if (!_webservice) {
        [testCase initialize];
        _webservice = [KTManager sharedManager];
    }
    
    if (!_pagedObject) {
        _pagedObject = [[KTPagedObject alloc]init];
        _pagedObject.page=1;
        _pagedObject.size = 10;
    }
    
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/**
 Tests the /Search ressource withthe q=<text> parameter to query some server side attributes directly
 */
- (void)testQueryByText {
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    [query queryByText:@"keytech" paged:_pagedObject block:^(NSArray *results) {  // 'keytech' exist in most databases
        
        XCTAssertNotNil(results);
        
        if (results.count>0) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        XCTFail(@"Error while waiting for data: %@",error);
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
        XCTAssert(YES, @"Pass");
}

/// A search request is canceled immediately
-(void)testStartAndCancelQuery{
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    [query queryByText:@"keytech" paged:_pagedObject block:^(NSArray *results) {  // 'keytech' exist in most databases
        XCTAssertNotNil(results);
        if (results.count>0) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        // Cancel is tested - so a failure is correct
            [documentOpenExpectation fulfill];
    }];
    
    [query cancelSearches];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
        XCTAssert(YES, @"Pass");
}

/// Test by given searchword and class restriction
- (void)testQueryByTextWithClassRestriction {
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    // Test by name
    [query queryByText:@"keytech"  inClasses:@[@"PROPOSAL_WF",@"AB_FILE",@""] paged:_pagedObject block:^(NSArray *results) {  // 'keytech' exist in most databases
        XCTAssertNotNil(results);
        if (results.count>0) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        if (!error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
        XCTAssert(YES, @"Pass");
}



- (void)testQueryByPredicateLesserThanDate{
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // Date field lesser than

    NSPredicate *predicateDateLesserThan = [NSPredicate predicateWithFormat:@"created_at < %@",@"/Date(1411828338000)/"];
    
    [query queryByPredicate:predicateDateLesserThan inClasses:nil paged:_pagedObject block:^(NSArray *results) {  // 'keytech' exist in most databases
        XCTAssertNotNil(results);
        if (results.count>0) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        if (!error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];

}

- (void)testQueryByPredicateGreaterThanDate{
    // Date field greater than
    
    NSPredicate *predicateDateGreaterThan = [NSPredicate predicateWithFormat:@"created_at > %@",@"/Date(946995932000)/"];
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    [query queryByPredicate:predicateDateGreaterThan inClasses:nil paged:_pagedObject block:^(NSArray *results) {  // 'keytech' exist in most databases
        XCTAssertNotNil(results);
        if (results.count>0) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        if (!error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
}


- (void)testQueryByPredicateItemNameEquals{

    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // Exact Name
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"name==%@",@"ITM-100145"];
    
    [query queryByPredicate:predicateName inClasses:nil paged:_pagedObject block:^(NSArray *results) {  // 'keytech' exist in most databases
        XCTAssertNotNil(results);
        [documentOpenExpectation fulfill];
        if (results.count>0) {
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        [documentOpenExpectation fulfill];
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
        
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];

}

- (void)testQueryByPredicateBeginsWith{
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // BeginsWith createdBy
    NSPredicate *predicateNameBeginsWith = [NSPredicate predicateWithFormat:@"created_by BEGINSWITH %@",@"jg"]; // jgrant..
    
    [query queryByPredicate:predicateNameBeginsWith inClasses:nil paged:_pagedObject block:^(NSArray *results){
        XCTAssertNotNil(results);
        if (results.count>0) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];

    
}

- (void)testQueryByPredicateEndsWith{
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // BeginsWith createdBy
    NSPredicate *predicateNameBeginsWith = [NSPredicate predicateWithFormat:@"created_by ENDSWITH %@",@"grant"]; // jgrant..
    
    [query queryByPredicate:predicateNameBeginsWith inClasses:nil paged:_pagedObject block:^(NSArray *results){
        XCTAssertNotNil(results);
        if (results.count>0) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    
}

- (void)testQueryByPredicateContains{
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // BeginsWith createdBy
    NSPredicate *predicateNameBeginsWith = [NSPredicate predicateWithFormat:@"created_by CONTAINS %@",@"gran"]; // jgrant..
    
    [query queryByPredicate:predicateNameBeginsWith inClasses:nil paged:_pagedObject block:^(NSArray *results){
        XCTAssertNotNil(results);
        if (results.count>0) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    
}

- (void)testQueryWithPagedObject {
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    [query queryByText:@"keytech" paged:[KTPagedObject initWithPage:1 size:1] block:^(NSArray *results) {  // 'keytech' exist in most databases
        XCTAssertNotNil(results);
        if (results.count==1) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        if (!error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    XCTAssert(YES, @"Pass");
}

/**
Starts a query that will return only 1 element by specifiying the pages and size attributes
 */
-(void)testStoredQuery{
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    [query queryByStoredSearch:[@380 integerValue] paged:_pagedObject block:^(NSArray *results) {  // a Query with the IS'42' must exist in database
        
        XCTAssertNotNil(results);
        
        if (results.count>0) {
            [documentOpenExpectation fulfill];
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        XCTFail(@"Error while waiting for data: %@",error);
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    // Ist das assert hier korrekt?
    XCTAssert(YES, @"Pass");

    
}




@end
