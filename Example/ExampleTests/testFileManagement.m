//
//  testFileManagement.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 07.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"
#import "KTFileInfo.h"
#import "KTElement.h"
#import "TestDefaults.h"
//#import "Restkit/RKTestFixture.h"

static NSBundle *fixtureBundle = nil;

/**
 Tests file related thinks
 */
@interface testFileManagement : XCTestCase

@end

@implementation testFileManagement
{
    KTManager* webservice;
    NSString* elementKeyWithStructure;
    BOOL awaitingResponse;
}


NSTimeInterval _timeOut = 25;

-(NSBundle *)fixtureBundle
{
    NSAssert(fixtureBundle != nil, @"Bundle for fixture has not been set. Use setFixtureBundle: to set it.");
    return fixtureBundle;
}

-(NSURL*)urlForFixture:(NSString*)fixtureName{
    
    NSString *path= [[self fixtureBundle] pathForResource:fixtureName ofType:nil];
    NSURL *fixtureURL = [NSURL fileURLWithPath:path];
    return fixtureURL;
}

- (void)setUp
{
    [super setUp];
    [TestDefaults initialize];
    // Put setup code here; it will be run once, before the first test case.
    webservice = [KTManager sharedManager];
    elementKeyWithStructure = @"3DMISC_SLDASM:500308"; //* "Steamroller"
    
    fixtureBundle = [NSBundle bundleForClass:[testFileManagement class]];
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


#pragma mark Getting data collections
/**
 Observes for KVO value changing
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
    
    NSLog(@"%@ Awaiting response loaded from for %f seconds...", self, _timeOut);
    while (awaitingResponse) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        if ([[NSDate date] timeIntervalSinceDate:startDate] > _timeOut) {
            XCTFail(@"*** Operation timed out after %f seconds...",_timeOut);
            awaitingResponse = NO;
        }
    }
}

#pragma mark The Tests

-(void)testUploadFileInBackground
{
    // Create a new element
    KTElement *element = [KTElement elementWithElementKey:@"MISC_FILE"];
    XCTestExpectation *elementFileExpectation = [self expectationWithDescription:@"File Loaded"];
    
    [element saveItem:^(KTElement *element) {
        
        
        KTFileInfo *newFile = [KTFileInfo fileInfoWithElement:element];
        newFile.fileName = @"Aerial04.jpg";
        newFile.fileStorageType = FileTypeMaster;
        
        NSURL *fileURL = [self urlForFixture:@"Aerial04.jpg"];
        [newFile saveFile:fileURL success:^{
            // do nothing
            [elementFileExpectation fulfill];
        } failure:^(NSError * _Nonnull error) {
            // Do nothing
            [elementFileExpectation fulfill];
        }];
        
        //
    } failure:^(NSError *error) {
        XCTFail("Failed saving element");
        [elementFileExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
}

/**
 Test for a filellist in this Element
*/
- (void)testElementHasFiles
{
    KTElement* element = [[KTElement alloc] initWithElementKey:elementKeyWithStructure];
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"Filelist Loaded"];
    
    [element loadFileListSuccess:^(NSArray *itemsList) {
        
        XCTAssertNotNil(itemsList, @"Filelist list should not be nil");
        XCTAssertTrue(itemsList.count>0, @"Filelist list should have some items");
        XCTAssertTrue(element.itemFilesList.count>0,@"Element property should not be empty");
        [documentOpenExpectation fulfill];
        
    } failure:^(NSError *error) {
        XCTFail(@"Failed loading filelist: %@",error);
        [documentOpenExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Failed fetching a file: %@",error);
        }

    }];
    
}

/**
 Fetching a file
 */
-(void)testFetchingFile{
   
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithStructure];
    
    
    XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"Filelist Loaded"];
    
    [element loadFileListSuccess:^(NSArray *itemsList) {
        
        XCTAssertNotNil(itemsList, @"Filelist list should not be nil");
        XCTAssertTrue(itemsList.count>0, @"Filelist list should have some items");
        XCTAssertTrue(element.itemFilesList.count>0,@"Element property should not be empty");
        [documentOpenExpectation fulfill];
        
    } failure:^(NSError *error) {
        XCTFail(@"Failed loading filelist: %@",error);
        [documentOpenExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Failed fetching a file: %@",error);
        }
        
    }];
    
    KTFileInfo* firstFile = element.itemFilesList[0];

    [firstFile loadRemoteFile];
    
    [firstFile addObserver:self forKeyPath:@"localFileURL" options:NSKeyValueObservingOptionNew context:nil];
    
    // Wait until file is loaded
    [self waitForResponse];
    
    NSURL * targetURL = [firstFile localFileURL];
    
    [firstFile removeObserver:self forKeyPath:@"localFileURL" context:nil];
    
    XCTAssertNotNil(targetURL,@"targetURl was nil. expected a valid target URL");
    
    
}


@end
