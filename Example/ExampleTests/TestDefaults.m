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

                         
    //[KTManager sharedManager].servername = @"https://api.keytech.de:4233";
    [KTManager sharedManager].servername = @"http://claus-pc.keytech.de:8080/keytech";
    [KTManager sharedManager].username = @"jgrant";
    [[KTManager sharedManager]  synchronizeServerCredentials];
    [[KTServerInfo sharedServerInfo] waitUnitlLoad];
    
    [[KTManager sharedManager] setLicenceKey:kTESTAPIKey];
    
}

@end
