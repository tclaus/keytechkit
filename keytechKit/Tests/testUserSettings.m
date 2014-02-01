//
//  testUserSettings.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Webservice.h"
#import "Restkit/Restkit.h"
#import "ResponseLoader.h"
#import "keytechKit/KTUser.h"
#import "keytechKit/KTGroup.h"


@interface testUserSettings : XCTestCase

@end

@implementation testUserSettings{
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



/**
 Gets the permissions directly set to the user
 */
-(void)testGetDirectPermissionsForUser{
    
    KTKeytech* keytech  = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    
    NSLog(@"Get permissionslist for %@",[Webservice sharedWebservice].username);
    
    [keytech performGetPermissionsForUser:[Webservice sharedWebservice].username findPermissionName:nil findEffective:NO loaderDelegate:responseLoader];
    
    
    [responseLoader waitForResponse];
    NSArray* permissionList = [responseLoader objects];
    
    if (permissionList==nil) XCTFail(@"The results array should not be nil");
    // It might be the case, that the user has no direct rights
    
}

-(void)testGetIndirectPermissionsForUser{
    
    KTKeytech* keytech  = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    [keytech performGetPermissionsForUser:[Webservice sharedWebservice].username findPermissionName:nil findEffective:YES loaderDelegate:responseLoader];
    
    
    [responseLoader waitForResponse];
    NSArray* permissionList = [responseLoader objects];
    
    if (permissionList==nil) XCTFail(@"The results array should not be nil");
    // It might be the case, that the user has no direct rights
    if (permissionList.count==0) XCTFail(@"User should have indirect set permissions. (Set by group membership)");
}


-(void)testGetGroupList{
    KTKeytech* keytch = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    [keytch performGetGroupList:responseLoader];
    [responseLoader waitForResponse];
    
    NSArray* result = [responseLoader objects];
    XCTAssert(result!=nil, @"Grouplist should not be nil");
    XCTAssert(result.count>0, @"There should be any groups.");
    
}


/**
 Returns the groups in which a specific user is member.
 */
-(void)testGetGroupsForUser{
    KTKeytech* keytch = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    [keytch performGetGroupsWithUser:@"jgrant" loaderDelegate:responseLoader];
    [responseLoader waitForResponse];
    
    NSArray* result = [responseLoader objects];
    XCTAssert(result!=nil, @"Group list should not be nil");
    XCTAssert(result.count>0, @"The user should be member of at least one group.");
    
}




/**
 Returns a userlist which are meber of a specific group
 */
-(void)testGetUsersInGroupList{
    KTKeytech* keytch = [[KTKeytech alloc]init];
    ResponseLoader* responseLoader = [[ResponseLoader alloc]init];
    
    // GRP_DMS, GRP_RELEASE, GRP_RESEARCH
    [keytch performGetUsersInGroup:@"GRP_DMS" loaderDelegate:responseLoader];
    
    [responseLoader waitForResponse];
    
    NSArray* result = [responseLoader objects];
    XCTAssert(result!=nil, @"User list should not be nil");
    XCTAssert(result.count>0, @"There should be any users.");
    
}

@end







