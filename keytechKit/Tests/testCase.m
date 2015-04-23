//
//  testCase.m
//  keytechKit
//
//  Created by Thorsten Claus on 05.02.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "testCase.h"
#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"

@implementation testCase

+ (void)setUp{

    KTManager* webservice = [KTManager sharedManager];
                             
    webservice.servername = @"https://demo.keytech.de";
    //webservice.servername = @"http://claus-pc.keytech.de:8080/keytech";
    webservice.username = @"jgrant";
    [webservice synchronizeServerCredentials];
    
}

@end
