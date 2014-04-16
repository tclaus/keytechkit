//
//  testGlobalSettings.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.08.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"
#import "keytechKit/KTSystemManagement.h"
#import "KTGlobalSettingContext.h"

@interface testGlobalSettings : XCTestCase

@end

@implementation testGlobalSettings{
    KTManager* _webservice;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _webservice = [KTManager sharedWebservice];
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
    KTGlobalSettingContext* results = (KTGlobalSettingContext*)[responseLoader firstObject];
    
    XCTAssert(results!=nil, @"Results should not be nil");
    XCTAssert(results.contexts.count>0, @"Results should have member");
    
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

// Loads globalsetings defined by a contextname
// Admin Role needed
-(void)testLoadGlobalSettingsListByContexts{
    KTSystemManagement* ktSystemManagement = [[KTSystemManagement alloc]init];
    testResponseLoader* responseLoader = [testResponseLoader responseLoader];
    
    
    [ktSystemManagement performGetGlobalSettingContexts: responseLoader];
    [responseLoader waitForResponse];
    
    KTGlobalSettingContext* contextList = (KTGlobalSettingContext*) [responseLoader firstObject];  // Liste der Kontexte holen

    [responseLoader setObjects:nil];
    
    for (NSString* context in contextList.contexts){
        
       [ktSystemManagement performGetGlobalSettingsByContext:context loaderDelegate:responseLoader];
        [responseLoader waitForResponse];
        
        NSArray* settingsList = [responseLoader objects];
        
        XCTAssert(settingsList!=Nil, @"Results should not be nil (To Test, a admin role might be needed)");
        
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
