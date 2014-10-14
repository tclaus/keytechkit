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
#import "testResponseLoader.h"


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
    
    
}

KTManager* _webservice;

/**
 supports lazy loading
 */
    Boolean awaitingResponse;
    NSTimeInterval _timeout = 8; //* 8 Seconds Timeout


- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    _webservice = [KTManager sharedManager];
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
/**
 Observes for  KVO value changing
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    awaitingResponse = NO;
}
/**
 Waits until KVO signals datareceive
 */
- (void)waitForResponse {
    awaitingResponse = YES;
    NSDate *startDate = [NSDate date];
    
    NSLog(@"%@ Awaiting response loaded from for %f seconds...", self, _timeout);
    while (awaitingResponse) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        if ([[NSDate date] timeIntervalSinceDate:startDate] > _timeout) {
            NSLog(@"*** Operation timed out after %f seconds...",_timeout);
            awaitingResponse = NO;
        }
    }
}

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


/**
 Test to get a invalid Element. No element with this key should be found. But response array should not be nil.
 */
-(void)testGetInvalidElement{
    
    
    XCTestExpectation *expectation =[self expectationWithDescription:@"Load invalid element"];
    
    
    [KTElement loadElementWithKey:@"DummyItem" success:nil failure:^(NSError *error) {
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
    
    [KTElement loadElementWithKey:elementKeyWithStructure success:^(KTElement *theElement) {
        _theElement =theElement;
        [expectation fulfill];
    } failure:^(NSError *error) {
        NSLog(@"Error loading element: %@",error);
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
 Try to request a files list from an invaid elementkey. Should return a valid array object.
 */
-(void)testGetFilesFromInvalidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    // Fetching a files List with an invalid elementkey
    [keytech performGetFileList:@"invalidItemKey" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array!=nil) XCTFail(@"The results array should be nil");
    // if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",[array count]);
    
    
}

/**
 Try to request a files list from an well known element with files. Should return some files in a list.
 */
-(void)testGetFilesFromValidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    // Fetching a files List. Element 3DMISC_SLDASM:2220 should have some files
    [keytech performGetFileList:@"3DMISC_SLDASM:2220" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array==nil) XCTFail(@"The results array should not be nil");
    if ([array count]==0) XCTFail(@"At least one element was expected but we found %ld",(long)[array count]);
    
    
}


/**
 Performs deferred getting whereused data.
 */
- (void)testGetElementWhereUsed
{
    
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = elementKeyWithStructure;
    
    NSMutableArray* structure =  item.itemWhereUsedList;
    
    [item addObserver:self forKeyPath:@"itemWhereUsedList" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    
    [item removeObserver:self forKeyPath:@"itemWhereUsedList" context:nil];
    
    XCTAssertNotNil(structure, @"Wherused list should not be nil");
    XCTAssertTrue(structure.count>0, @"Whereused list should have some items");
    
}

/**
 Performs deferred getting filelist data.

 */
- (void)testGetElementFileList
{
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = elementKeyWithStructure;
    
    NSMutableArray* structure =  item.itemFilesList;
    
    [item addObserver:self forKeyPath:@"itemFilesList" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    
    [item removeObserver:self forKeyPath:@"itemFilesList" context:nil];
    
    XCTAssertNotNil(structure, @"itemFileList should not be nil");
    XCTAssertTrue(structure.count>0, @"itemFileList should have some items");
    
}


/**
 Fetching some notes from invalid element. Should not return a nil value
 */
-(void)testGetNotesFromInvalidElement{
    
    KTKeytech* keytech = [[KTKeytech alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    // Fetching a notes List. Element 3DMISC_SLDASM:2220 should have some files
    [keytech performGetElementNotes:@"invalidItemKey" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* array = [responseLoader objects];
    
    if (array!=nil) XCTFail(@"The results array should be nil");
    //if ([array count]==0) XCTFail(@"At least one element was expected but we found %d",[array count]);
    
    
}

/**
 Performs deferred getting notes data.
 */
- (void)testGetElementNotesList
{
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = elementKeyWithNotes;
    
    NSMutableArray* structure =  item.itemNotesList;
    
    [item addObserver:self forKeyPath:@"itemNotesList" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    [item removeObserver:self forKeyPath:@"itemNotesList" context:nil];
    
    XCTAssertNotNil(structure, @"itemNotesList should not be nil");
    XCTAssertTrue(structure.count>0, @"itemNotesList should have some items");
    
}



/**
Performs a GET on an Elements BOM (Bill of Material)s list.
 Every Element should return a non-NIL object. 
 Only Articles (Items) should have a BOM.
 */
- (void)testGetElementBOM
{
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = elementKeyWithBOM;
    
    NSMutableArray* structure =  item.itemBomList;
    
    [item addObserver:self forKeyPath:@"itemBomList" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    [item removeObserver:self forKeyPath:@"itemBomList" context:nil];
    
    XCTAssertNotNil(structure, @"itemBomList should not be nil");
    item=nil; // Not for use in further testing.
    
    
    // Now Test a real article with a bom list
    
    KTElement* bomitem = [[KTElement alloc]init];
    bomitem.itemKey = elementKeyItem;
    
    structure = bomitem.itemBomList;
    
    // Request the BOM
    [bomitem addObserver:self forKeyPath:@"itemBomList" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    [bomitem removeObserver:self forKeyPath:@"itemBomList" context:nil];
    
    XCTAssertNotNil(structure, @"itemBomList should not be nil");
    
    XCTAssertTrue(structure.count>0, @"itemBomList should have some items");
    
}

/**
 Performs deferred getting available status from current element.
 */
- (void)testGetElementNextAvailableStatus
{
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = elementKeyWithStateWork;
    
    NSMutableArray* structure =  item.itemNextAvailableStatusList;

    [item addObserver:self forKeyPath:@"itemNextAvailableStatusList" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    [item removeObserver:self forKeyPath:@"itemNextAvailableStatusList" context:nil];
    
    XCTAssertNotNil(structure, @"itemNextAvailableStatusList should not be nil");

    // Maybe the user dont have the right to make a status change
   // XCTAssertTrue(structure.count>0, @"itemNextAvailableStatusList should have some items");
    
}

/**
 Performs deferred getting available status from current element.
 */
- (void)testGetElementStatusHistory
{
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = @"3dmisc_sldprt:2156";
    
    NSMutableArray* structure =  item.itemStatusHistory;
    
    [item addObserver:self forKeyPath:@"itemStatusHistory" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    [item removeObserver:self forKeyPath:@"itemStatusHistory" context:nil];
    
    XCTAssertNotNil(structure, @"itemStatusHistory should not be nil");
    
     XCTAssertTrue(structure.count>0, @"itemStatusHistory should have some items");
    
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
    
    [item addObserver:self forKeyPath:@"itemThumbnail" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    
    [item removeObserver:self forKeyPath:@"itemThumbnail" context:nil];
    
    XCTAssertNotNil(item.itemThumbnail, @" Image should return a meaningful image in any case");

}


-(void)testGetElementStructure{
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Load element structure"];
    
    __block KTElement *_theElement;
    [KTElement loadElementWithKey:elementKeyWithStructure
                          success:^(KTElement *theElement) {
                              
                              _theElement = theElement;
                              [_theElement loadStructureList:0 size:0
                                                     success:^(NSArray *itemsList) {
                                                         XCTAssertNotNil(itemsList,@"The fetched structured list was empty");
                                                         [expectation fulfill];
                                                     } failure:nil];
                              
                          }
                          failure:nil];
    
     
                              
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if  (!error) {
            
            if (_theElement){
                if  (!_theElement.itemStructureList){
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



@end




