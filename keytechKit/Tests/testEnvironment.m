//
//  testEnvironment.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 07.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"
#import "testCase.h"
#import "KTQuery.h"

@interface testEnvironment : XCTestCase

@end

@implementation testEnvironment
{
    KTManager* _webservice;

}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    [testCase initialize];
    _webservice = [KTManager sharedManager];
    
    
}
- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}




@end
