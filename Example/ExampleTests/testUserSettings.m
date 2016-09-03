//
//  testUserSettings.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"

#import "KTUser.h"
#import "KTGroup.h"


@interface testUserSettings : XCTestCase

@end

@implementation testUserSettings{
    KTManager* _webservice;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
        _webservice = [KTManager sharedManager];
    //_webservice.username = @"Admin";
    //_webservice.password = @"AdmiN2012";
    //[_webservice synchronizeServerCredentials];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}




/**
 Returns the groups in which a specific user is member.
 */
-(void)testGetGroupsForUser{

    
}




/**
 Returns a userlist which are meber of a specific group
 */
-(void)testGetUsersInGroupList{
   
    
}

@end







