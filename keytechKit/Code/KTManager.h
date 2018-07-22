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

#define dispatch_main_sync_safeKT(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safeKT(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


/**
 Provides basic initialization
 */
@interface KTManager : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
// Formaly known as "Webservice"


/**
 Returns the shared instance
 */
+(instancetype) sharedManager;

/**
 Returns the default application data directory
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSURL *applicationDataDirectory;

/**
 Returns the default application cache directory
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSURL *applicationCacheDirectory;

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
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSURL *baseURL;

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
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *lastServerErrorText;

/**
 Returns YES if the user identified by its credentials has an active admin role
 */
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL currentUserHasActiveAdminRole;

/**
 Simply check if current user credentials has right to login.
 @Returns A value If username or password failed (402), or license violation (403) or 400 if unknown.
 */
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL currentUserHasLoginRight;


@property (readonly) KTPreferencesConnection* preferences;

//@property (nonatomic,weak) NSArray *simpleItemsList;


@property (NS_NONATOMIC_IOSONLY, readonly) BOOL needsInitialSetup;

/// Synchonizes changed user credentials with the api level.
-(void)synchronizeServerCredentials;

/**
 Translates a error response to a error object and extracts the API Respone error header description message
 @param response The response will be parsed by its X-ErrorDescription Header.
 @param error This is the incomming error from failed request. Will be parsed and repacked bevore returned.
 @returns A error object with the http error code and a text extracted from the API's response header
 */
+(NSError*)translateErrorFromResponse:(NSHTTPURLResponse*)response error:(NSError*)error;

#pragma mark License Management


@end




