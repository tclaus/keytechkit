//
//  KTLicenseData.h
//  keytechKit
//
//  Created by Thorsten Claus on 08.05.15.
//  Copyright (c) 2015 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 Checks for a valid keytechKit SDK License.
 */
@interface KTLicenseData : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>


/**
 Returns the shared singelton licenseData class
 */
+(KTLicenseData*)sharedLicenseData;

/**
 In case of  invalid license this error contains a error text with more specific information
 */
-(NSError*)licenseError;

/**
 Checks aginst current ServerInfo
 @return
  True if licence data is valid. returns also true if license server can not be reached for a period of time. Switches to NO after prox. 1hour.
 */
-(BOOL)isValidLicense;

/**
 Force treading of license data. Call this first after set API Key and API URL
 */
-(void)readLicenceData;


/**
 Sets the API URL to check the License
 @param APIURL The target URL for the API. License may be linked to a specific API URL target.
 */
-(void)setAPIURL:(NSString*)APIURL;


/**
 Sets the APi license key. Needs to be set before any other methos is called
 */
@property (copy,nonatomic) NSString* APILicenseKey;


@property (readonly) BOOL isActive;
@property (readonly,copy) NSString* targetURL;
@property (readonly,copy) NSString* note;
@property (readonly,copy) NSDate* endDate;
@property (readonly,copy) NSString* APIVersion;


@end