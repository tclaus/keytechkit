//
//  testSendNotification.m
//  keytechKit
//
//  Created by Thorsten Claus on 06.08.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCTest/XCTextCase+AsynchronousTesting.h>
#import "KTElement.h"
#import "KTSendNotifications.h"
#import "KTManager.h"

@interface testSendNotification : XCTestCase

@end

@implementation testSendNotification{
    KTElement *testElement;
    KTManager *_webService;
}

- (void)setUp {
    [super setUp];
    
     _webService = [KTManager sharedManager];
    
    testElement = [[KTElement alloc]init];
    testElement.itemName = @"ITM-0001234";
    testElement.itemClassDisplayName = @"Artikel";
    testElement.itemDescription = @"Schraubzwinge, 42";
    testElement.itemDisplayName = @"Schraubzwinge 42 - Version 1";
    testElement.itemKey = @"DEFAULT_MI:123456";
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}




-(void)testElementAdded{
    testElement = [[KTElement alloc]init];
    
    KTKeyValue *keyValue = [[KTKeyValue alloc]init];
    keyValue.key = @"as_mi__desciption";
    keyValue.value = @"testElememt";
    
    testElement.itemKey = @"DEFAULT_MI";
    [testElement.keyValueList addObject:keyValue];

    [testElement saveItem:^(KTElement *element) {
        // elememnt was created
        NSLog(@"Elememt cerated");
        
    } failure:nil];
    

    
    
    
}


-(void)testRegisterDevice{
    NSString* deviceID =@"123456789";
    NSString* hWID = @"HW: 12345";
    
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    [sendNotfifications registerDevice:deviceID uniqueID:hWID];
    
    
}

-(void)testSendToPushWoosh{
    
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    [sendNotfifications sendMessageToPushWoosh];
    
    
}


- (void) testSendingElementChangeNotifications{
    
    // Put the code you want to measure the time of here.
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    //sendNotfifications.serverID = @"ServerID";
    //sendNotfifications.userID = @"Jgrant";
    [sendNotfifications sendElementHasBeenChanged:testElement];


    XCTAssert(YES, @"Pass");
}

- (void) testSendingElementDeleteNotifications{
    
    // Put the code you want to measure the time of here.
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    //sendNotfifications.serverID = @"ServerID";
    //sendNotfifications.userID = @"Jgrant";
    [sendNotfifications sendElementHasBeenDeleted:testElement];
    
    
    XCTAssert(YES, @"Pass");
}

- (void) testSendingFileUploadedNotifications{
    
    // Put the code you want to measure the time of here.
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    //sendNotfifications.serverID = @"ServerID";
    //sendNotfifications.userID = @"Jgrant";
    [sendNotfifications sendElementFileUploaded:@"DEFAULT_MI:1234"];
    
    
    XCTAssert(YES, @"Pass");
}


- (void) testSendingFileDeleteNotifications{
    
    // Put the code you want to measure the time of here.
    KTSendNotifications *sendNotfifications =[[KTSendNotifications alloc]init];
    sendNotfifications.serverID = @"ServerID";
    sendNotfifications.userID = @"Jgrant";
    [sendNotfifications sendElementFileHasBeenRemoved:@"DEFAULT_MI:1234"];
    
    
    XCTAssert(YES, @"Pass");
}




@end
