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
 Fetches the API ServerInfo
 */
-(void)serverInfo:(void (^)(KTServerInfo* serverInfo))resultBlock failure:(void(^)(NSError* error))failureBlock;

/**
 Returns YES if the user identified by its credentials has an active admin role
 */
-(BOOL)currentUserHasActiveAdminRole;

/**
 Simply check if current user credentials has right to login
 */
-(BOOL)currentUserHasLoginRight;

@property (readonly) KTKeytech* ktKeytech;

@property (readonly) KTPreferencesConnection* preferences;

//@property (nonatomic,weak) NSArray *simpleItemsList;


-(BOOL)needsInitialSetup;

/// Synchonizes changed user credentials with the api level.
-(void)synchronizeServerCredentials;



@end
