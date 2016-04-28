//
//  testSendNotification.m
//  keytechKit
//
//  Created by Thorsten Claus on 06.08.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import <XCTest/XCTextCase+AsynchronousTesting.h>
#import "KTElement.h"
#import "KTSendNotifications.h"
#import "KTManager.h"
#import "TestDefaults.h"


@interface testSendNotification : XCTestCase

@end

@implementation testSendNotification{
    KTElement *testElement;
    KTManager *_webService;
}
static KTElement *testElement;


- (void)setUp {
    [super setUp];
    [TestDefaults initialize];
    
     _webService = [KTManager sharedManager];
    
    if (!testElement) {
        
        testElement = [[KTElement alloc]init];
        testElement.itemName = @"ITM-0001234";
        testElement.itemClassDisplayName = @"Artikel";
        testElement.itemDescription = @"Schraubzwinge, 42";
        testElement.itemDisplayName = @"Schraubzwinge 42 - Version 1";
        testElement.itemKey = @"DEFAULT_MI:123456";
        testElement.itemCreatedBy =@"Gandalf";
        testElement.itemCreatedByLong =@"Gandald the white";
    }
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



-(void)testRegisterDevice{
    
    [KTSendNotifications sharedSendNotification].APNAPIToken = @"";
    [KTSendNotifications sharedSendNotification].APNApplictionID = @"";
    [[KTSendNotifications sharedSendNotification] setupService];
    
}


-(void)testSendPushNotificationOpend{
  
    [KTSendNotifications sharedSendNotification].APNAPIToken = @"";
    [KTSendNotifications sharedSendNotification].APNApplictionID = @"";
    [[KTSendNotifications sharedSendNotification] setupService];
    
    [[KTSendNotifications sharedSendNotification] sendPushOpend:@"HashValue"];
}

/// Sends a information that
-(void)testSendToPushWoosh{
    
    [KTSendNotifications sharedSendNotification].APNAPIToken = @"";
    [KTSendNotifications sharedSendNotification].APNApplictionID = @"";
    [[KTSendNotifications sharedSendNotification] setupService];

    [[KTSendNotifications sharedSendNotification] sendElementFileUploaded:@"FILE_File:123"];
    
}

/// Tests if a push is send when an element was changed
-(void)testElementChanged{
    testElement = [[KTElement alloc]init];
    
    KTKeyValue *keyValue = [[KTKeyValue alloc]init];
    keyValue.key = @"as_mi__description";
    keyValue.value = @"testElememt";
    
    testElement.itemKey = @"DEFAULT_MI";
    [testElement.keyValueList addObject:keyValue];
    
    [testElement saveItem:^(KTElement *element) {
        // elememnt was created
        NSLog(@"Element created");
        
    } failure:nil];
    
    
}


- (void) testSendingElementChangeNotifications{
    
    // Put the code you want to measure the time of here.
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    sendNotfifications.serverID = @"Test-Server";
    // sendNotfifications setUser: = @"Jgrant";
    [sendNotfifications sendElementHasBeenChanged:testElement];


    XCTAssert(YES, @"Pass");
}

- (void) testSendingElementDeleteNotifications{
    
    // Put the code you want to measure the time of here.
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    sendNotfifications.serverID = @"Test-Server";
    //sendNotfifications.userID = @"Jgrant";
    [sendNotfifications sendElementHasBeenDeleted:testElement];
    
    
    XCTAssert(YES, @"Pass");
}

- (void) testSendingFileUploadedNotifications{
    
    // Put the code you want to measure the time of here.
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    sendNotfifications.serverID = @"Test-Server";
    //sendNotfifications.userID = @"Jgrant";
    [sendNotfifications sendElementFileUploaded:@"DEFAULT_MI:1234"];
    
    
    XCTAssert(YES, @"Pass");
}


- (void) testSendingFileDeleteNotifications{
    
    // Put the code you want to measure the time of here.
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    sendNotfifications.serverID = @"Test-Server";

    [sendNotfifications sendElementFileHasBeenRemoved:@"DEFAULT_MI:1234"];
    
    
    XCTAssert(YES, @"Pass");
}




@end
