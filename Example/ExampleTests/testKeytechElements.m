//
//  testKeytechElements.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 02.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "KTElement.h"
//#import "testResponseLoader.h"
#import "TestDefaults.h"

@interface testKeytechElements : XCTestCase

@end

@implementation testKeytechElements
{
@private
    NSString* elementKeyWithStructure;// = @"3DMISC_SLDASM:2220"; //* Element with structure on Test API
    NSString* elementKeyWithBOM; //DEFAULT_MI:2007
    NSString* elementKeyWithNotes;// = @"2DMISC_SLDDRW:2221"; //* Element with notes on Test API
    NSString* elementKeyWithStatusHistory;// = @"3dmisc_sldprt:2156"; //* Element with some status changed´s in the past. Will provide a status history
    NSString* elementKeyWithStateWork; // = 3DMISC_SLDPRT:2133 // Sollte "In Arbeit" sein.
    NSString* elementKeyItem; //* DEFAULT_MI:2088  // Item with BOM List
    TestDefaults *_testdefaults;
    
}


NSTimeInterval _timeout = 8; //* 8 Seconds Timeout


- (void)setUp
{
    [super setUp];
    
    _testdefaults =[[TestDefaults alloc]init];
     [_testdefaults setUp];
     
    // Put setup code here; it will be run once, before the first test case.
    
    
    elementKeyWithStructure = @"3DMISC_SLDASM:2220"; //* Element with structure on Test API
    elementKeyWithNotes = @"2DMISC_SLDDRW:2221"; //* Element with notes on Test API
    elementKeyWithStatusHistory = @"3dmisc_sldprt:2156"; //* Element with some status changed´s in the past. Will provide a status history
    elementKeyItem = @"DEFAULT_MI:2088";  //* Represents an item with bom structure
    elementKeyWithStateWork = @"3DMISC_SLDPRT:2133";
    elementKeyWithBOM = @"DEFAULT_MI:2007";
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


#pragma mark Getting data collections


#pragma mark Simple tests


-(void)testGenerateClassKeyFromElementKey{
    KTElement* item = [[KTElement alloc]init];
    
    item.itemKey = @"3dmisc_SLDPRW:1234"; // DO ;
    XCTAssertTrue( [item.itemClassType isEqualToString:@"DO"],@"Document did not return 'DO' as classtype");
    
    item.itemKey = @"Files_WF:1234"; // FD
    XCTAssertTrue( [item.itemClassType isEqualToString:@"FD"],@"Folder did not return 'FD' as classtype");
    
    item.itemKey = @"%_MI:12345";  //MI
    XCTAssertTrue( [item.itemClassType isEqualToString:@"MI"],@"Masteritem did not return 'MI' as classtype");
    
    item.itemKey = @"Default_MI:12345";  //MI
    XCTAssertTrue( [item.itemClassType isEqualToString:@"MI"],@"Masteritem did not return 'MI' as classtype");
    
    
    
}

-(void)testPostElement
{
    // Create a new element
    KTElement *element = [KTElement elementWithElementKey:@"MISC_FILE"];
    XCTestExpectation *elementFileExpectation = [self expectationWithDescription:@"Element Created"];
    
    
    [element saveItem:^(KTElement *element) {
        [elementFileExpectation fulfill];
        
        
        //
    } failure:^(KTElement *element, NSError *error) {
        [elementFileExpectation fulfill];
        
    }];
    
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Failed uploading a file: %@",error);
        }
        
    }];
    
}

/**
 Test to get a invalid Element. No element with this key should be found. But response array should not be nil.
 */
-(void)testGetInvalidElement{
    
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"Load invalid element"];
    
    
    [KTElement loadElementWithKey:@"DummyItem" success:^(KTElement* element){
        XCTFail(@"Shuld not return an element");
        [expectation fulfill];
    }
     failure:^(NSError *error) {
        NSLog(@"Error: %@",error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Error in expectation: %@",error);
            XCTFail(@"Error in expectation");
        }
        
    }];
    
    
}

/**
 Tests for returning a valid element. At least one element should be found.
 */
-(void)testGetValidElement{
    
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"Load element"];
    
    __block KTElement *_theElement;
    
    [KTElement loadElementWithKey:elementKeyWithStructure
                          success:^(KTElement *theElement) {
                              _theElement =theElement;
                              [expectation fulfill];
                          } failure:^(NSError *error) {
                              
                              XCTFail(@"Error loading element: %@",error);
                              [expectation fulfill];
                          }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error){
            NSLog(@"error: %@",error);
        } else {
            if (_theElement==nil) XCTFail(@"The result should not be nil");
        }
    }];
    
}

/// Load element with the full set of attributes
-(void)testGetElementWithFullAttributes{
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"Load element"];
    
    __block KTElement *_theElement;
    
    [KTElement loadElementWithKey:elementKeyWithStructure withMetaData:KTResponseFullAttributes
                          success:^(KTElement *theElement) {
                              
                              _theElement =theElement;
                              if (_theElement.keyValueList.count==0){
                                  XCTFail(@"Element key value list was empty. A full keyvalue list was expcted");
                              }
                              [expectation fulfill];
                          } failure:^(NSError *error) {
                              XCTFail(@"Element key value list was empty. A full keyvalue list was expcted. Error: %@",error);
                              [expectation fulfill];
                          }] ;
    
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error){
            NSLog(@"error: %@",error);
        } else {
            if (_theElement==nil) XCTFail(@"The result should not be nil");
        }
    }];
    
}



/**
 Performs deferred getting whereused data.
 */
- (void)testGetElementWhereUsed
{
    
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithStructure];
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"WhereUsed Loaded"];
    
    [element loadWhereUsedListPage:0 withSize:0
                           success:^(NSArray *itemsList) {
                               
                               XCTAssertNotNil(itemsList, @"Wherused list should not be nil");
                               XCTAssertTrue(itemsList.count>0, @"Whereused list should have some items");
                               XCTAssertTrue(element.itemWhereUsedList.count>0,@"Element property should not be empty");
                               
                               [documentOpenExpectation fulfill];
                               
                           } failure:^(NSError *error) {
                               XCTFail(@"Failed loading whereUsed: %@",error);
                               [documentOpenExpectation fulfill];
                           }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
    }];
    
    
}

/**
 Performs deferred getting filelist data.
 
 */
- (void)testGetElementFileList
{
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithStructure];
    
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"Filelist Loaded"];
    
    [element loadFileListSuccess:^(NSArray *itemsList) {
        [documentOpenExpectation fulfill];
        XCTAssertNotNil(itemsList, @"Fiellist list should not be nil");
        XCTAssertTrue(itemsList.count>0, @"Filelist list should have some items");
        XCTAssertTrue(element.itemFilesList.count>0,@"Element property should not be empty");

        
    } failure:^(NSError *error) {
        [documentOpenExpectation fulfill];
        XCTFail(@"Failed loading filelist: %@",error);
        
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    
}

/// Gets the list of version from the given element
- (void)testGetElementVersionsList
{
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithStructure];
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"Filelist Loaded"];
    
    [element loadVersionListSuccess:^(NSArray *itemsList) {
        
        XCTAssertNotNil(itemsList, @"Fiellist list should not be nil");
        XCTAssertTrue(itemsList.count>0, @"Filelist list should have some items");
        XCTAssertTrue(element.itemVersionsList.count>0,@"Element property should not be empty");
        [documentOpenExpectation fulfill];
        
    } failure:^(NSError *error) {
        XCTFail(@"Failed loading filelist: %@",error);
        [documentOpenExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
    }];
    
    
}

/**
 Performs deferred getting notes data.
 */
- (void)testGetElementNotesList
{
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithNotes];
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"Noteslist loaded"];
    
    [element loadNotesListSuccess:^(NSArray *itemsList) {
        
        XCTAssertNotNil(itemsList, @"Noteslist list should not be nil");
        XCTAssertTrue(itemsList.count>0, @"Noteslist list should have some items");
        XCTAssertTrue(element.itemNotesList.count>0,@"Element property should not be empty");
        
        NSLog(@"Loaded %lu notes",(unsigned long)itemsList.count);
        
        [documentOpenExpectation fulfill];
        
    } failure:^(NSError *error) {
        XCTFail(@"Failed loading noteslist: %@",error);
        [documentOpenExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        
    }];
    
}



/**
 Performs a GET on an Elements BOM (Bill of Material)s list.
 Every Element should return a non-NIL object.
 Only Articles (Items) should have a BOM.
 */
- (void)testGetElementBOM
{
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithBOM];
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"BOM Loaded"];
    
    [element loadBomListPage:1
                          withSize:100
                           success:^(NSArray *itemsList) {
                               [documentOpenExpectation fulfill];
                               XCTAssertNotNil(itemsList);
                               XCTAssertTrue(itemsList.count>0);
                               XCTAssertTrue(element.itemBomList.count>0,@"Element property should not be empty");
                               
                               
                               
                           } failure:^(NSError *error) {
                               [documentOpenExpectation fulfill];
                               XCTAssert(NO);

                           }];
    
    
    // Expectation
    // The test will pause here, running the run loop, until the timeout is hit
    // or all expectations are fulfilled.
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // Clean up test
        if (error){
            NSLog(@"%@",error);
        }
    }];
    
    
    
}

/**
 Performs deferred getting available status from current element.
 */
- (void)testGetElementNextAvailableStatus
{
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = elementKeyWithStateWork;
    
    NSMutableArray* structure =  item.itemNextAvailableStatusList;
    

    
}

/**
 Performs getting the status history
 */
- (void)testGetElementStatusHistory
{
    KTElement* element = [[KTElement alloc]initWithElementKey:@"3dmisc_sldprt:2156"];
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"Status history Loaded"];
    
    [element loadStatusHistoryListSuccess:^(NSArray *itemsList) {
        
        XCTAssertNotNil(itemsList);
        XCTAssertTrue(itemsList.count>0);
        XCTAssertTrue(element.itemStatusHistory.count>0,@"Element property should not be empty");
        
        [documentOpenExpectation fulfill];
        
    } failure:^(NSError *error) {
        XCTFail(@"Failed with: %@",error);
        [documentOpenExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        // Clean up test
        if (error){
            NSLog(@"%@",error);
        }
    }];
    
    
}

/**
 Get a defered thumbnail or classimage for a test element.
 */
-(void)testGetElementThumbnail{
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = elementKeyWithStructure;
#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
    NSImage* image = item.itemThumbnail;
#else
    UIImage* image =item.itemThumbnail;
#endif
    
    image=nil;
    
 
}


-(void)testGetElementStructure{
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Load element structure"];
    
    KTElement *element = [[KTElement alloc] initWithElementKey:elementKeyWithStructure];
    
    [element loadStructureListPage:0 withSize:0
                           success:^(NSArray *itemsList) {
                               
                               XCTAssertNotNil(itemsList,@"The fetched structured list was empty");
                               XCTAssertTrue(itemsList.count>0,@"The structurelist should have some items");
                               XCTAssertTrue(element.itemStructureList.count>0,@"Element property should not be empty");
                               
                               [expectation fulfill];
                               
                           } failure:^(NSError *error) {
                               XCTFail(@"Element returned no tructure");
                               [expectation fulfill];
                           }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if  (!error) {
            
            if (element){
                if  (!element.itemStructureList){
                    XCTFail(@"The structure list was empty");
                } else {
                    // OK
                }
            } else {
                XCTFail(@"The element was empty");
            }
            
        }else {
            // Error occured
            XCTFail(@"Error while loading structure: %@",error);
        }
    }];
    
}

/// Starts moving a elemnet to another class
-(void)testMoveElement{
    // Create a dummy element
    // Move it to another class
    
    XCTestExpectation *elementSavedExpectation = [self expectationWithDescription:@"Element saved"];
    
    
    KTElement *element = [KTElement elementWithElementKey:@"MISC_FILE"];
    [element saveItem:^(KTElement *element) {
        [elementSavedExpectation fulfill];
        NSLog(@"Element created with ID: %@",element.itemKey);
        
    } failure:^(KTElement *element, NSError *error) {
        NSLog(@"Creation failed");
        XCTFail(@"Could not store a new element");
        [elementSavedExpectation fulfill];
    }];
    
        [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
            if (error) {
                XCTFail(@"Could not cerate a new element");
            }
        }];
    
    XCTestExpectation *elementMovedExpectation = [self expectationWithDescription:@"Element moved"];
    
    NSString *newExpectedID = [NSString stringWithFormat:@"TEST_FILE:%D",element.itemID];
    
    [element moveToClass:@"TEST_FILE"
                 success:^(NSString *newElementkey) {
                     
                    XCTAssert([newElementkey isEqualToString:newExpectedID]);
                     
                      [elementMovedExpectation fulfill];

                 } failure:^(NSError *error) {
                     XCTFail(@"Element move server failure: %@",error);
                      [elementMovedExpectation fulfill];
                 }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if  (error) {
             XCTFail(@"Element could not be moved: %@",error);
        }
    }];

    
}


@end




