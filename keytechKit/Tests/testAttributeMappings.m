//
//  testAttributeMappings.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 18.10.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "Restkit/Restkit.h"
#import "testResponseLoader.h"
@interface testAttributeMappings : XCTestCase

@end

@implementation testAttributeMappings{
    KTManager *_webService;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _webService = [KTManager sharedManager];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}




@end
