//
//  testGlobalSettings.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.08.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Webservice.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"
#import "keytechKit/KTSystemManagement.h"

@interface testGlobalSettings : XCTestCase

@end

@implementation testGlobalSettings{
    Webservice* _webservice;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _webservice = [Webservice sharedWebservice];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testLoadGlobalSettingContextList{
    KTSystemManagement* ktSystemManagement = [[KTSystemManagement alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    [ktSystemManagement performGetGlobalSettingContexts:responseLoader];
    
    [responseLoader waitForResponse];
    NSArray* results = [responseLoader objects];
    
    XCTAssert(results==nil, @"Results should not be nil");
    XCTAssert(results.count>0, @"Results should have member");
    
}

-(void)testLoadGlobalSettingsBySearch{
    KTSystemManagement* ktSystemManagement = [[KTSystemManagement alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    
    [ktSystemManagement performGetGlobalSettingsBySearchString:@"acad" returnFullResults:NO loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    NSArray* results = [responseLoader objects];
    
    XCTAssert(results!=nil, @"Results should not be nil");
    XCTAssert(results.count>0, @"Results should have member");
    
}

// Loads globalsetings by contextlist
-(void)testLoadGlobalSettingsListByContexts{
    KTSystemManagement* ktSystemManagement = [[KTSystemManagement alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    
    [ktSystemManagement performGetGlobalSettingContexts:responseLoader];
    [responseLoader waitForResponse];
    
    NSArray* contextList = [responseLoader objects];  // Liste der Kontexte holen
    
    
    for (id context in contextList){
        
        [ktSystemManagement performGetGlobalSettingsByContext:(NSString*)contextList loaderDelegate:responseLoader];
        [responseLoader waitForResponse];
        
        NSArray* settingsList = [responseLoader objects];
        
        XCTAssert(settingsList!=Nil, @"Results should not be nil");
        
    }
}

- (void)testLoadGlobalSettingsForUser
{
    KTSystemManagement* ktSystemManagement = [[KTSystemManagement alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    
    [ktSystemManagement performGetGlobalSetting:@"PR0JMAIN_WF_1stVersion" forUser:@"jgrant" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    NSArray* results = [responseLoader objects];
    
    XCTAssert(results!=nil, @"Results should not be nil");
    XCTAssert(results.count>0, @"Results should have member");
    
}

@end
