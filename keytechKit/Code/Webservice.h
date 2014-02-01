//
//  webservice.h
//  keytech search ios
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KTKeytech.h"
#import "KTPreferencesConnection.h"

/**
 Provides basic initialization
 */
@interface Webservice : NSObject

+(Webservice*) sharedWebservice;
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
 Returns YES if the user identified by its credentials has an active admin role
 */
-(BOOL)currentUserHasActiveAdminRole;

/**
 Simply check if current user credentials has right to login
 */
-(BOOL)currentUserHasLoginRight;

@property (readonly) KTKeytech* ktKeytech;

@property (readonly) KTPreferencesConnection* preferences;

@property (nonatomic,weak) NSArray *simpleItemsList;


-(BOOL)needsInitialSetup;

/// Synchonizes changed user credentials with the api level.
-(void)synchronizeServerCredentials;



@end
