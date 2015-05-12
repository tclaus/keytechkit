//
//  testSDKLicenses.m
//  keytechKit
//
//  Created by Thorsten Claus on 11.05.15.
//  Copyright (c) 2015 Claus-Software. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "testCase.h"
#import "KTLicenseData.h"

@interface testSDKLicenses : XCTestCase

@end

static NSString * const kSDKProductionKey = @"OdIxQkDaI6";
static NSString * const kSDKDevelopKey = @"0Bai9DsRDQ";
static NSString * const kSDKTestNotActiveKey = @"RumjV4fgte";
static NSString * const kSDKTestExpiredKey = @"g5Y1VNKSZn";
static NSString * const kSDKTestLowVersionKey = @"Ben8FjNs0m";
static NSString * const kSDKTestHighVersionKey = @"mzv2Gx9mEQ";
//static NSString * const kSDKTestInvalidURLKey = @"mzv2Gx9mEQ";

@implementation testSDKLicenses


- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    [testCase setUp];
    [[KTServerInfo sharedServerInfo]waitUnitlLoad];
}

// To Test:
// Connect to SDK License Server
// Check Production
// Check Debvelop Keys
// Check different rejection Methods

/// Valid API KEy
-(void)testCheckProductionAPIKey{
    [[KTLicenseData sharedLicenseData] setAPILicenseKey:kSDKProductionKey];
    XCTAssertTrue([KTLicenseData sharedLicenseData].isValidLicense,@"Production SDK key should be valid: %@",[KTLicenseData sharedLicenseData].licenseError);
    XCTAssertNil([KTLicenseData sharedLicenseData].licenseError,@"Error Object should be nil");
}

/// Valiud API Key
-(void)testCheckDevelopAPIKey{
    [[KTLicenseData sharedLicenseData] setAPILicenseKey:kSDKDevelopKey];
    XCTAssertTrue([KTLicenseData sharedLicenseData].isValidLicense,@"Develop SDK key should be valid: %@",[KTLicenseData sharedLicenseData].licenseError);
    XCTAssertNil([KTLicenseData sharedLicenseData].licenseError,@"Error Object should be nil");
    NSLog(@"Errortext: %@",[KTLicenseData sharedLicenseData].licenseError);
}

/// Invalid API Key (Expired)
-(void)testCheckExpiredAPIKey{
    [[KTLicenseData sharedLicenseData] setAPILicenseKey:kSDKTestExpiredKey];
    XCTAssertFalse([KTLicenseData sharedLicenseData].isValidLicense,@"Expired SDK key should be invalid: %@",[KTLicenseData sharedLicenseData].licenseError);
    XCTAssertNotNil([KTLicenseData sharedLicenseData].licenseError,@"Error Object should not be nil");
    NSLog(@"Errortext: %@",[KTLicenseData sharedLicenseData].licenseError);
}

/// Invalid APi Key (High Version)
-(void)testCheckHighAPIKey{
    [[KTLicenseData sharedLicenseData] setAPILicenseKey:kSDKTestHighVersionKey];
    XCTAssertFalse([KTLicenseData sharedLicenseData].isValidLicense,@"High SDK key should be invalid: %@",[KTLicenseData sharedLicenseData].licenseError);
    XCTAssertNotNil([KTLicenseData sharedLicenseData].licenseError,@"Error Object should not be nil");
    NSLog(@"Errortext: %@",[KTLicenseData sharedLicenseData].licenseError);
    
}

/// Invalid API Key (Low Version)
-(void)testCheckLowAPIKey{
    [[KTLicenseData sharedLicenseData] setAPILicenseKey:kSDKTestLowVersionKey];
    XCTAssertFalse([KTLicenseData sharedLicenseData].isValidLicense,@"Low SDK key should be invalid: %@",[KTLicenseData sharedLicenseData].licenseError);
    XCTAssertNotNil([KTLicenseData sharedLicenseData].licenseError,@"Error Object should not be nil");
    NSLog(@"Errortext: %@",[KTLicenseData sharedLicenseData].licenseError);
}

-(void)testCheckInactiveAPIKey{
    [[KTLicenseData sharedLicenseData] setAPILicenseKey:kSDKTestNotActiveKey];
    XCTAssertFalse([KTLicenseData sharedLicenseData].isValidLicense,@"Inactive SDK key should be invalid: %@",[KTLicenseData sharedLicenseData].licenseError);
    XCTAssertNotNil([KTLicenseData sharedLicenseData].licenseError,@"Error Object should not be nil");
    NSLog(@"Errortext: %@",[KTLicenseData sharedLicenseData].licenseError);
}

@end







