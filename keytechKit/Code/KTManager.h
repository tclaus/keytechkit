//
//  KTManager
//  keytech PLM
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//
//  Manages BaseURLs, Login names and Managing Data
//
#import <Foundation/Foundation.h>

#import "KTPreferencesConnection.h"
#import "KTServerInfo.h"

/**
 Provides basic initialization
 */
@interface KTManager : NSObject
// Formaly known as "Webservice"


/**
 Returns the shared instance
 */
+(instancetype) sharedManager;

/**
 Returns the default application data directory
 */
- (NSURL*)applicationDataDirectory;
/**
 Returns the default application cache directory
 */
- (NSURL*)applicationCacheDirectory;

@property (nonatomic,copy) NSString* servername;
@property (nonatomic,copy) NSString* username;
@property (nonatomic,copy) NSString* password;

/**
 A page and size structure to identify a specific page in multi page responses
 */
typedef struct {int page; int size;} PageDefinition;

/**
 Returns the current baseURL
 */
-(NSURL*)baseURL;

/**
 Sets a default header with the given settings.
 @param headerName The nbame of a header
 @param value the headers value to transmit.
 */
-(void)setDefaultHeader:(NSString*)headerName withValue:(NSString*)value;

/**
 Adds default headers to mutable request
 @param request This request will get a set of default headers before proceeding.
 */
-(void)setDefaultHeadersToRequest:(NSMutableURLRequest*)request;

/**
 Returns a dictionary with current defualt header values
 */
-(NSDictionary*)defaultHeaders;

/*
 If any error occured on the server side. This value retuns the original server error description
 */
-(NSString*) lastServerErrorText;

/**
 Returns YES if the user identified by its credentials has an active admin role
 */
-(BOOL)currentUserHasActiveAdminRole;

/**
 Simply check if current user credentials has right to login.
 @Returns A value If username or password failed (402), or license violation (403) or 400 if unknown.
 */
-(BOOL)currentUserHasLoginRight;


@property (readonly) KTPreferencesConnection* preferences;

//@property (nonatomic,weak) NSArray *simpleItemsList;


-(BOOL)needsInitialSetup;

/// Synchonizes changed user credentials with the api level.
-(void)synchronizeServerCredentials;

/**
 Translates a error respnse to a error object and extracts the API Respone error header description message
 @param response The response will be parsed by its X-Errordescription Header.
 @returns A error object with the http error code and a text extracted from the API's response header
 */
+(NSError*)translateErrorFromResponse:(NSHTTPURLResponse*)response;

#pragma mark License Management

/**
 Sets the license key value. Must be set at first before any other actions.
 @param licenceKey The licence code provided by vendor
 */
+(void)setLicenceKey:(NSString*)licenseKey;


@end




