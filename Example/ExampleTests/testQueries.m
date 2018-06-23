
//
//  testQueries.m
//  keytechKit
//
//  Created by Thorsten Claus on 27.09.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "KTQuery.h"
#import "TestDefaults.h"
#import "KTSearchengineResult.h"

@interface testQueries : XCTestCase {
    TestDefaults *_testdefaults;
}
@end

@implementation testQueries {
    KTManager *_webservice;
    KTPagedObject *_pagedObject;
}

- (void)setUp {
    [super setUp];
    
    _testdefaults =[[TestDefaults alloc]init];
    [_testdefaults setUp];
    
    
    if (!_webservice) {
        [TestDefaults initialize];
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
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"Query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    [query queryByText:@"keytech" reload:YES paged:_pagedObject success:^(NSArray *results) {  // 'keytech' exist in most databases
        
        XCTAssertNotNil(results);
        [queryExpectation fulfill];
        
        if (results.count>0) {
            
        } else{
            XCTFail(@"Result query should have data");
        }
        
    } failure:^(NSError *error) {
        [queryExpectation fulfill];
        XCTFail(@"Error while waiting for data: %@",error);
        
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    XCTAssert(YES, @"Pass");
}

- (void)testQueryByTextWithField {
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"Query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    NSArray *queryFields = @[@"created_by=jgrant"];
    
    [query queryByText:@"keytech"
                fields:queryFields
             inClasses:nil
                reload:YES
                 paged:_pagedObject
               success:^(NSArray *results) {  // 'keytech' exist in most databases
                   
                   XCTAssertNotNil(results);
                   [queryExpectation fulfill];
                   
                   if (results.count>0) {
                       
                   } else{
                       XCTFail(@"Result query should have data");
                   }
                   
               } failure:^(NSError *error) {
                   [queryExpectation fulfill];
                   XCTFail(@"Error while waiting for data: %@",error);
                   
               }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    XCTAssert(YES, @"Pass");
}

- (void)testQueryByTextWithClasses {
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"Query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    NSString *inClasses = @"DEFAULT_DO";
    
    [query queryByText:@"keytech"
                fields:nil
             inClasses:@[inClasses]
                reload:YES
                 paged:_pagedObject
               success:^(NSArray *results) {  // 'keytech' exist in most databases
                   
                   XCTAssertNotNil(results);
                   [queryExpectation fulfill];
                   
                   if (results.count>0) {
                       
                   } else{
                       XCTFail(@"Result query should have data");
                   }
                   
               } failure:^(NSError *error) {
                   [queryExpectation fulfill];
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
-(void)testStartAndCancelQuery {
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    [query queryByText:@"keytech"
                reload:YES
                 paged:_pagedObject
               success:^(NSArray *results) {  // 'keytech' exist in most databases
                   [queryExpectation fulfill];
                   XCTAssertNotNil(results);
                   
                   if (results.count>0) {
                       
                   } else{
                       XCTFail(@"Result query should have data");
                   }
                   
               } failure:^(NSError *error) {
                   // Cancel is tested - so a failure is correct
                   [queryExpectation fulfill];
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
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    // Test by name
    [query queryByText:@"keytech"
                fields:nil
             inClasses:@[@"DOCCOMPANY_FILE",@"AB_FILE",@""]
                reload:YES
                 paged:_pagedObject
               success:^(NSArray *results){  // 'keytech' exist in most databases
                   [queryExpectation fulfill];
                   XCTAssertNotNil(results);
                   if (results.count>0) {
                       
                   } else{
                       XCTFail(@"Result query should have data");
                   }
                   
               } failure:^(NSError *error) {
                   [queryExpectation fulfill];
                   if (error) {
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

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

- (void)testQueryByPredicateLesserThanDate {
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // Date field lesser than
    
    NSPredicate *predicateDateLesserThan = [NSPredicate predicateWithFormat:@"created_at < %@",@"/Date(1411828338000)/"];
    
    
    [query queryByPredicate:predicateDateLesserThan
                  inClasses:nil
                      paged:_pagedObject
                    success:^(NSArray *results) {  // 'keytech' exist in most databases
                        [queryExpectation fulfill];
                        XCTAssertNotNil(results);
                        if (results.count>0) {
                            
                        } else{
                            XCTFail(@"Result query should have data");
                        }
                        
                    } failure:^(NSError *error) {
                        [queryExpectation fulfill];
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
#endif

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
- (void)testQueryByPredicateGreaterThanDate {
    // Date field greater than
    
    NSPredicate *predicateDateGreaterThan = [NSPredicate predicateWithFormat:@"created_at > %@",@"/Date(946995932000)/"];
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    [query queryByPredicate:predicateDateGreaterThan
                  inClasses:nil
                      paged:_pagedObject
                    success:^(NSArray *results) {  // 'keytech' exist in most databases
                        [queryExpectation fulfill];
                        XCTAssertNotNil(results);
                        if (results.count>0) {
                            
                        } else{
                            XCTFail(@"Result query should have data");
                        }
                        
                    } failure:^(NSError *error) {
                        [queryExpectation fulfill];
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
#endif

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
- (void)testQueryByPredicateItemNameEquals{
    
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // Exact Name
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"name==%@",@"ITM-100145"];
    
    [query queryByPredicate:predicateName
                  inClasses:nil
                     reload:YES
                      paged:_pagedObject
                    success:^(NSArray *results) {  // 'keytech' exist in most databases
                        XCTAssertNotNil(results);
                        [queryExpectation fulfill];
                        if (results.count>0) {
                        } else{
                            XCTFail(@"Result query should have data");
                        }
                        
                    } failure:^(NSError *error) {
                        [queryExpectation fulfill];
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
#endif
#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
- (void)testQueryByPredicateBeginsWith {
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // BeginsWith createdBy
    NSPredicate *predicateNameBeginsWith = [NSPredicate predicateWithFormat:@"created_by BEGINSWITH %@",@"jg"]; // jgrant..
    
    [query queryByPredicate:predicateNameBeginsWith
                  inClasses:nil
                     reload:YES
                      paged:_pagedObject
                    success:^(NSArray *results){
                        [queryExpectation fulfill];
                        XCTAssertNotNil(results);
                        if (results.count>0) {
                            
                        } else{
                            XCTFail(@"Result query should have data");
                        }
                        
                    } failure:^(NSError *error) {
                        [queryExpectation fulfill];
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
#endif

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
- (void)testQueryByPredicateEndsWith {
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // BeginsWith createdBy
    NSPredicate *predicateNameBeginsWith = [NSPredicate predicateWithFormat:@"created_by ENDSWITH %@",@"grant"]; // jgrant..
    
    [query queryByPredicate:predicateNameBeginsWith
                  inClasses:nil
                     reload:YES
                      paged:_pagedObject
                    success:^(NSArray *results){
                        [queryExpectation fulfill];
                        XCTAssertNotNil(results);
                        if (results.count>0) {
                            
                        } else{
                            XCTFail(@"Result query should have data");
                        }
                        
                    } failure:^(NSError *error) {
                        [queryExpectation fulfill];
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
#endif

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
- (void)testQueryByPredicateContains {
    XCTestExpectation *queryExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // BeginsWith createdBy
    NSPredicate *predicateNameBeginsWith = [NSPredicate predicateWithFormat:@"created_by CONTAINS %@",@"gran"]; // jgrant..
    
    [query queryByPredicate:predicateNameBeginsWith
                  inClasses:nil
                     reload:YES
                      paged:_pagedObject
                    success:^(NSArray *results){
                        [queryExpectation fulfill];
                        XCTAssertNotNil(results);
                        if (results.count>0) {
                            
                        } else{
                            XCTFail(@"Result query should have data");
                        }
                        
                    } failure:^(NSError *error) {
                        [queryExpectation fulfill];
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
#endif

- (void)testQueryWithPagedObject {
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    [query queryByText:@"keytech"
                reload:YES
                 paged:[KTPagedObject initWithPage:1 size:1]
               success:^(NSArray *results) {  // 'keytech' exist in most databases
                   [documentOpenExpectation fulfill];
                   XCTAssertNotNil(results);
                   if (results.count==1) {
                       
                   } else{
                       XCTFail(@"Result query should have data");
                   }
                   
               } failure:^(NSError *error) {
                   [documentOpenExpectation fulfill];
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

/// Test direct Solr vault fetch
-(void)testQueryWithSolr {
    
    if (![KTServerInfo sharedServerInfo].isIndexServerEnabled) {
        NSLog(@"Test Server dont supports Solr indexing");
        return;
    }
    
    
    XCTestExpectation *solrsearchexpectation = [self expectationWithDescription:@"Solr search returned"];
    
    
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
    [KTSearchengineResult mappingWithManager:[RKObjectManager sharedManager]];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"searchengine"
                                           parameters:@{@"q": @"keytech"}
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [solrsearchexpectation fulfill];
                                                  KTSearchengineResult *firstelement = [mappingResult firstObject];
                                                  
                                                  XCTAssertNotNil(firstelement,@"Response was nil");
                                                  KTElement *element = firstelement.element;
                                                  
                                                  XCTAssertNotNil(element,@"Element was nil");
                                                  
                                                  NSLog(@"OK");
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [solrsearchexpectation fulfill];
                                                  NSLog(@"Failure");
                                              }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Error while fetching data: %@",error);
        }
    }];
    
    
}

/**
 Test a Solr search.
 Gets any files from Solr Search engine with a given searchtext
 */
- (void)testQueryWithSolrVaults {
    
    if (![KTServerInfo sharedServerInfo].isIndexServerEnabled) {
        NSLog(@"Test Server dont supports Solr indexing");
        return;
    }
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"Solr search returned"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    
    [query queryInVaultsByText:@"keytech"
                        reload:YES
                         paged:[KTPagedObject initWithPage:1 size:1]
                       success:^(NSArray *results) {  // 'keytech' exist in most databases
                           [documentOpenExpectation fulfill];
                           XCTAssertNotNil(results);
                           if (results.count==1) {
                               
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

/**
 Starts a query that will return only 1 element by specifiying the pages and size attributes
 */
-(void)testStoredQuery{
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"query returned with data"];
    
    KTQuery *query = [[KTQuery alloc]init];
    
    // Queries are user-defined: /user/{userid}/queries
    
    [query queryByStoredSearch:[@759 integerValue] // Stores query ID for user jgrant
                        reload:YES
                         paged:_pagedObject
                       success:^(NSArray *results) {  // a Query with this ID must exist in database
                           [documentOpenExpectation fulfill];
                           XCTAssertNotNil(results);
                           
                           if (results.count>0) {
                               
                           } else{
                               XCTFail(@"Result query should have data");
                           }
                           
                       } failure:^(NSError *error) {
                           [documentOpenExpectation fulfill];
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



