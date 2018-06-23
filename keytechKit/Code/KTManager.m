//
//  KTManager
//  keytech plm
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import "KTManager.h"
#import "KTElement.h"
#import "KTNotifications.h"
#import "KTUser.h"
#import "KTServerInfo.h"
#import "KTSendNotifications.h"

@implementation KTManager{
    
    BOOL _connectionIsValid;
    KTPreferencesConnection* _preferences;
    NSString *_serverVersion;
    NSString *_serverErrorDescription;
    KTServerInfo *_sharedServerInfo;
}


-(NSString*) servername{
    return _preferences.servername;
}

-(void)setServername:(NSString *)servername{
    _preferences.servername = servername;
}

-(NSString*)username{
    return _preferences.username;
}

-(void)setUsername:(NSString *)username{
    _preferences.username = username;
}

-(NSString*)password{
    return _preferences.password;
}

-(void) setPassword:(NSString *)password{
    _preferences.password = password;
}

/// Creates the singelton class
+(instancetype) sharedManager{
    
    static KTManager *_sharedInstance;
    static dispatch_once_t one_token=0;
    
    dispatch_once(&one_token,^{
        _sharedInstance = [[self alloc]init];
    });
    
    return _sharedInstance;
}

/// returns true if no servername was given. User interaction is required
-(BOOL)needsInitialSetup{
    
    if (!self.servername) {
        return YES;
    }
    else {
        return NO;
    }
}

// Returns the apps cache directory
- (NSURL*)applicationCacheDirectory {
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    
    NSError* err;
    NSURL* cacheDirectory;
    NSURL* appSupportDir = [sharedFM URLForDirectory:NSCachesDirectory
                                            inDomain:NSUserDomainMask
                                   appropriateForURL:nil create:YES error:&err];
    
    // If a valid app support directory exists, add the
    // app's bundle ID to it to specify the final directory.
    if (appSupportDir) {
        NSString* appBundleID = [NSBundle mainBundle].bundleIdentifier;
        cacheDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
    }
    
    return cacheDirectory;
}

-(NSString *) createTemporaryDirectory {
    // Create a unique directory in the system temporary directory
    NSString *guid = [NSProcessInfo processInfo].globallyUniqueString;
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:guid];
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]) {
        return nil;
    }
    return path;
}

// Returns the dictionary for caching loaded files.
- (NSURL*)applicationDataDirectory {
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    
    NSError* err;
    NSURL* appDirectory;
    NSURL* appSupportDir = [sharedFM URLForDirectory:NSApplicationSupportDirectory
                                            inDomain:NSUserDomainMask
                                   appropriateForURL:nil create:YES error:&err];
    
    NSURL* systemTemp = [NSURL URLWithString:[self createTemporaryDirectory]];
    
    // If a valid app support directory exists, add the
    // app's bundle ID to it to specify the final directory.
    if (appSupportDir) {
        NSString* appBundleID = [NSBundle mainBundle].bundleIdentifier;
        if (!appBundleID){
            appDirectory = systemTemp;
            
        } else {
            appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
            [sharedFM createDirectoryAtURL:appDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return appDirectory;
}

- (instancetype)init
{
    self = [super init];
    
    _preferences = [[KTPreferencesConnection alloc]init];
    
    // (Deleted stuff): Make no assume about user preferences. Caller has to take care about user credentials.
    
    // Defaults to demo-Server
    if (self.servername == nil) self.servername = [NSProcessInfo processInfo].environment[@"APIURL"]; // @"demo URL"
    if (self.username == nil) self.username = [NSProcessInfo processInfo].environment[@"APIUserName"]; // @"jgrant";
    if (self.password == nil) self.password = @"";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.servername]]] ;
    
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:self.username password:self.password];
    [[RKValueTransformer defaultValueTransformer]addValueTransformer:[RKDotNetDateFormatter dotNetDateFormatterWithTimeZone:[NSTimeZone localTimeZone]]];
    
    [RKMIMETypeSerialization registerClass:[RKMIMETypeTextXML class] forMIMEType:@"text/html"];
    [RKMIMETypeSerialization registerClass:[RKMIMETypeTextXML class] forMIMEType:@"text/plain"];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    
    //RKXMLReaderSerialization, RKMIMETypeJSON
    
    
    // Logging für RestKit definieren
    
#ifdef DEBUG
    RKLogConfigureByName("RestKit/Network", RKLogLevelWarning);
    // RKLogConfigureFromEnvironment();
#endif
    
    // Timeout definieren
    //  manager.client.timeoutInterval = 20.0; // 20 seconds
    
    
    return self;
}

/// Returns the current BaseURL
-(NSURL*)baseURL{
    return [RKObjectManager sharedManager].baseURL;
}

-(void)setDefaultHeader:(NSString*)headerName withValue:(NSString*)value{
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:headerName value:value];
}

-(void)setDefaultHeadersToRequest:(NSMutableURLRequest*)request{
    
    for (NSString* headerKey in (self.defaultHeaders).allKeys){
        NSString *headerValue = (self.defaultHeaders)[headerKey];
        [request setValue:headerValue forHTTPHeaderField:headerKey];
    }
    
}

-(NSDictionary*)defaultHeaders{
    return ([RKObjectManager sharedManager].HTTPClient).defaultHeaders;
}

-(KTPreferencesConnection*)preferences{
    return _preferences;
}


/// Checks for Admin role by asking the API directly and wait for result
-(BOOL)currentUserHasActiveAdminRole{
    //TODO:  Store value for a short period of time
    /*
     ResponseLoader *loader = [[ResponseLoader alloc]init];
     
     [ktKeytech performGetUser:self.username loaderDelegate:loader];
     [loader waitForResponse];
     
     
     if (loader.objects.count>0){
     KTUser* user = (KTUser*)loader.objects[0];
     
     if ((user.isAdmin && user.isActive) ) {
     return YES;
     }
     }
     */
    return NO;
    
}

/// Returns last known server error description
-(NSString*) lastServerErrorText{
    return _serverErrorDescription;
}

/**
 Simply check if current user credentials has right to login
 Waits until keytech responds
 */
-(BOOL)currentUserHasLoginRight{
    
    KTUser *currentUser = [KTUser loadUserWithKey:self.username];
    
    if (currentUser.isLoaded) {
        _serverErrorDescription = nil;
        return currentUser.isActive;
    } else {
        // username not found?
        // Server not found?
        _serverErrorDescription = currentUser.latestLocalizedServerMessage;
        return NO;
    }
    
}

/// Synchonizes changed user credentials with the api level.
-(void)synchronizeServerCredentials{
    NSString *Servername;
    NSString *Username;
    NSString *Password;
    
    Servername = self.servername;
    Username = self.username;
    Password = self.password;
    
    if (![Servername hasSuffix:@"/"])
        Servername = [Servername stringByAppendingString:@"/"];
    
    
    
    bool objectsAreEqual =     [[RKObjectManager sharedManager].HTTPClient.baseURL isEqual:[NSURL URLWithString:Servername]];
    if (!objectsAreEqual){
        // Remove all queries
        
        // Cancel only, if a base URL was ever set
        
        
        @try {
            [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodAny matchingPathPattern:@"" ];
        }
        @catch (NSException *exception) {
            //
        }
        @finally {
            //
        }
        
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:Servername]];
        objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
        [RKObjectManager setSharedManager:objectManager];
        
        // Set new authorization for new SharedObjectManager
        [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:Username password:Password];
        
        // If server changed, then reload serverInfo
        [KTServerInfo mappingWithManager:objectManager];
        [[KTServerInfo serverInfo] loadWithSuccess:^(KTServerInfo *serverInfo) {
            
            [KTSendNotifications sharedSendNotification].serverID = serverInfo.serverID;
            
            // Server responds
            // Init CurrentUser
            [KTUser loadCurrentUser:^(KTUser *user) {
                
                // Init NotificationService
                [KTSendNotifications sharedSendNotification].userName = user.userKey;
                 [KTSendNotifications sharedSendNotification].userNameLong = user.userLongName;
                [[KTSendNotifications sharedSendNotification] setupService];
                
            } failure:^(NSError *error) {
                //
            }];
            
        } failure:nil];
        
    } else {
        // Set new Authorization
        [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:Username password:Password];
    }
    
}


+(NSError*)translateErrorFromResponse:(NSHTTPURLResponse*)response error:(NSError *)error{
    
    
    if (error) {
        NSLog(@"An error occured: %@",error);
        
        if (response) {
            NSString *ErrorDescription = response.allHeaderFields[@"X-ErrorDescription"];
            NSError *transcodedError = [NSError errorWithDomain:@"keytech"
                                                           code:response.statusCode
                                                       userInfo:@{NSLocalizedDescriptionKey:ErrorDescription,
                                                                  NSLocalizedFailureReasonErrorKey:error.localizedDescription}];
            
            NSLog(@" Error translated to: %@", transcodedError);
            return transcodedError;
        }
        
        NSLog(@"An error occured: %@",error);
        return error;
    }
    
    
    if (response) {
        NSString *ErrorDescription = response.allHeaderFields[@"X-ErrorDescription"];
        NSError *transcodedError = [NSError errorWithDomain:@"keytech"
                                                       code:response.statusCode
                                                   userInfo:@{NSLocalizedDescriptionKey:ErrorDescription}];
        return transcodedError;
    } else {
        // An unknown error occured
        return [NSError errorWithDomain:@"keytech" code:1000 userInfo:@{NSLocalizedDescriptionKey:@"An unknown error occured"}];
    }
    
}


@end





