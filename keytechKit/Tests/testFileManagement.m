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

/**
 Tests file related thinks
 */
@interface testFileManagement : XCTestCase

@end

@implementation testFileManagement
{
    KTManager* webservice;
    NSString* elementKeyWithStructure;
}

BOOL awaitingResponse;
NSTimeInterval _timeOut = 12;


 


- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    webservice = [KTManager sharedManager];
    elementKeyWithStructure= @"3DMISC_SLDASM:2220"; //* Element with structure on Test API
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






/**
 Test for a filellist in this Element
*/
- (void)testElementHasFiles
{
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = elementKeyWithStructure;
    
    NSMutableArray* filesList =  item.itemFilesList;
    XCTAssertNotNil(filesList, @"FilesList should not be empty on first fetching"); // All layzy loaded arrays should point to a array structure.

    [item addObserver:self forKeyPath:@"itemFilesList" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    
    [item removeObserver:self forKeyPath:@"itemFilesList" context:nil];
    
    XCTAssertTrue(item.itemFilesList.count>0, @"Filelist shuld not be Empty.");
    
    KTFileInfo* firstFile = filesList[1];

    XCTAssertTrue([firstFile.shortFileName length]>0, @"Short filename sould not be empty.");
    
}

/**
 Fetching a file
 */
-(void)testFetchingFile{
    KTElement* item = [[KTElement alloc]init];
    item.itemKey = elementKeyWithStructure;
    
    NSMutableArray* filesList =  item.itemFilesList;
    XCTAssertNotNil(filesList, @"FilesList should not be empty on first fetching"); // All layzy loaded arrays should point to a array structure.
    
    [item addObserver:self forKeyPath:@"itemFilesList" options:NSKeyValueObservingOptionNew context:nil];
    
    [self waitForResponse];
    
    [item removeObserver:self forKeyPath:@"itemFilesList" context:nil];
    XCTAssertTrue(filesList.count>0, @"Filelist shuld not be Empty.");
    
    KTFileInfo* firstFile = filesList[1];

    [firstFile loadRemoteFile];
    
    [firstFile addObserver:self forKeyPath:@"localFileURL" options:NSKeyValueObservingOptionNew context:nil];
    
    // Wait until file is loaded
    [self waitForResponse];
    
    NSURL * targetURL = [firstFile localFileURL];
    
    [firstFile removeObserver:self forKeyPath:@"localFileURL" context:nil];
    
    
}


@end
