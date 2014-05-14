//
//  webservice.m
//  keytech search ios
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import "KTManager.h"
#import "KTElement.h"
#import "KTNotifications.h"
#import "KTUser.h"
#import "KTResponseLoader.h"
#import "KTServerInfo.h"


@implementation KTManager{
    
    KTKeytech *_ktKeytech;
    BOOL _connectionIsValid;
    KTPreferencesConnection* _preferences;
    NSString *_serverVersion;
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

-(void)serverInfo:(void (^)(KTServerInfo* serverInfo))resultBlock failure:(void(^)(NSError* error))failureBlock{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTServerInfo mappingWithManager:manager];
    
    
    [manager getObject:nil path:@"serverinfo" parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   if (resultBlock) {
                       KTServerInfo *serverInfo = mappingResult.firstObject;
                       
                       resultBlock(serverInfo);
                   }
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error while getting the API version: %@",error.localizedDescription);
                   if(failureBlock){
                       failureBlock(error);
                   }
               }];
    
    
    
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
   
    if (![self servername]) {
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
        NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        cacheDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
    }
    
    return cacheDirectory;
}

-(NSString *) createTemporaryDirectory {
    // Create a unique directory in the system temporary directory
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
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
        NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        if (!appBundleID){
            appDirectory = systemTemp;
            
            
        }else{
            appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
            [sharedFM createDirectoryAtURL:appDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            
            
        }
    }
    
    return appDirectory;
}



- (id)init
{
    self = [super init];

        _preferences = [[KTPreferencesConnection alloc]init];
        
        // (Deleted stuff): Make no assume about user preferences. Caller has to take care about user credentials.
        
        // Defaults to demo-Server
        if (self.servername ==nil) self.servername = @"https://api.keytech.de";
        if (self.username ==nil) self.username =@"jgrant";
        if (self.password ==nil) self.password =@"";

        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.servername]]] ;// @"http://192.168.0.10:8080/keytech"];
        
        [objectManager.HTTPClient setAuthorizationHeaderWithUsername:self.username password:self.password];
        [[RKValueTransformer defaultValueTransformer]addValueTransformer:[RKDotNetDateFormatter dotNetDateFormatterWithTimeZone:[NSTimeZone localTimeZone]]];
        
        // Suchprovider angeben
        _ktKeytech= [[KTKeytech alloc]init];
        
        // Logging für RestKit definieren
        RKLogConfigureFromEnvironment();
        
        // Timeout definieren
      //  manager.client.timeoutInterval = 20.0; // 20 seconds

    
    return self;
}

/// Returns the current BaseURL
-(NSURL*)baseURL{
    return [RKObjectManager sharedManager].baseURL;
}



-(KTPreferencesConnection*)preferences{
    return _preferences;
}


// Forward search provider class
-(KTKeytech*)ktKeytech{
    return _ktKeytech;
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
/**
 Simply check if current user credentials has right to login
 Waits until keytech responds
 */
-(BOOL)currentUserHasLoginRight{
   
     KTResponseLoader *loader = [[KTResponseLoader alloc]init];
    
    [self.ktKeytech performGetUser:self.username loaderDelegate:loader];
    [loader waitForResponse];
    
    
    if (loader.firstObject){
        KTUser* user = (KTUser*)loader.firstObject;
        
        if ((user.isActive) ) {  // Check login.User must have at least 'BASE' login right.
            return YES;
        }
    }
    return NO;
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
    
    
    // Save at locale datastructure
    KTPreferencesConnection* preferences  = [[KTPreferencesConnection alloc]init];
    preferences.servername = Servername;
    preferences.username = Username;
    preferences.password = Password;
    
    bool objectsAreEqual =     [[RKObjectManager sharedManager].HTTPClient.baseURL isEqual:[NSURL URLWithString:Servername]];
    if (!objectsAreEqual){
        // Remove all queries
        [self.ktKeytech cancelAllQueries];
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:Servername]];
        [RKObjectManager setSharedManager:objectManager];
    }
    
    // Set new Authorization
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:Username password:Password];
    
}


@end
