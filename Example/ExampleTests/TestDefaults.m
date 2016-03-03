//
//  testCase.m
//  keytechKit
//
//  Created by Thorsten Claus on 05.02.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "TestDefaults.h"
#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"


static NSString * const kTESTAPIKey = @"0Bai9DsRDQ";


@implementation TestDefaults
-(void)setUp{

    [KTManager sharedManager].servername =[[[NSProcessInfo processInfo]environment] objectForKey:@"APIURL"];
    [KTManager sharedManager].username = [[[NSProcessInfo processInfo]environment] objectForKey:@"APIUserName"];
    [[KTManager sharedManager]  synchronizeServerCredentials];
    [[KTServerInfo sharedServerInfo] waitUnitlLoad];
    

    
}

@end
