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

+ (void)initialize{
    
    KTManager* webservice = [[KTManager alloc]init];
    webservice.servername = @"http://10.0.246.14:8080/keytech";
    [webservice synchronizeServerCredentials];
    
    
}

@end
