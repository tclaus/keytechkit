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

#import "KTKeytech.h"
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
 Returns the current baseURL
 */
-(NSURL*)baseURL;

/**
 Sets a default header with the given settings
 */
-(void)setDefaultHeader:(NSString*)headerName withValue:(NSString*)value;

/**
 Adds default headers to mutable request
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
 Fetches a new API ServerInfo
 */
-(void)serverInfo:(void (^)(KTServerInfo* serverInfo))resultBlock failure:(void(^)(NSError* error))failureBlock;

/**
 After @serverInfo^resultBlock is called a valid serverInfo object can be fetched here;
 */
-(KTServerInfo*)serverInfo;

/**
 Returns YES if the user identified by its credentials has an active admin role
 */
-(BOOL)currentUserHasActiveAdminRole;

/**
 Simply check if current user credentials has right to login.
 @Returns A value If username or password failed (402), or license violation (403) or 400 if unknown.
 */
-(NSUInteger)currentUserHasLoginRight;

@property (readonly) KTKeytech* ktKeytech;

@property (readonly) KTPreferencesConnection* preferences;

//@property (nonatomic,weak) NSArray *simpleItemsList;


-(BOOL)needsInitialSetup;

/// Synchonizes changed user credentials with the api level.
-(void)synchronizeServerCredentials;



@end
