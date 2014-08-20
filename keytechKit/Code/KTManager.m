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
#import "KTResponseLoader.h"
#import "KTServerInfo.h"


#define keytechDefaultServerURL @"https://api.vm-kt-explorer.keytech.de/keytech"  // internal default URL )(for testing)
#define keytechDefaultServerUser @"jgrant"
#define keytechDefaultServerPassword @""

@implementation KTManager{
    
    KTKeytech *_ktKeytech;
    BOOL _connectionIsValid;
    KTPreferencesConnection* _preferences;
    NSString *_serverVersion;
    NSString *_serverErrorDescription;
    
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
    if (self.servername ==nil) self.servername = keytechDefaultServerURL; // @"https://api.keytech.de";
    if (self.username ==nil) self.username = keytechDefaultServerUser; // @"jgrant";
    if (self.password ==nil) self.password =@"";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.servername]]] ;// @"http://192.168.0.10:8080/keytech"];
    
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:self.username password:self.password];
    [[RKValueTransformer defaultValueTransformer]addValueTransformer:[RKDotNetDateFormatter dotNetDateFormatterWithTimeZone:[NSTimeZone localTimeZone]]];
    
    [RKMIMETypeSerialization registerClass:[RKMIMETypeTextXML class] forMIMEType:@"text/html"];
    [RKMIMETypeSerialization registerClass:[RKMIMETypeTextXML class] forMIMEType:@"text/plain"];
    [objectManager setRequestSerializationMIMEType: RKMIMETypeJSON];
    
    
    //RKXMLReaderSerialization, RKMIMETypeJSON
    
    // Suchprovider angeben
    _ktKeytech= [[KTKeytech alloc]init];
    
    // Logging für RestKit definieren
    
#ifdef DEBUG
    RKLogConfigureByName("RestKit/Network", RKLogLevelInfo);
    RKLogConfigureFromEnvironment();
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
    
    for (NSString* headerKey in [self.defaultHeaders allKeys]){
        NSString *headerValue = [self.defaultHeaders objectForKey:headerKey];
        [request setValue:headerValue forHTTPHeaderField:headerKey];
    }
    
}

-(NSDictionary*)defaultHeaders{
    return [[RKObjectManager sharedManager].HTTPClient defaultHeaders];
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

/// Returns last known server error description
-(NSString*) lastServerErrorText{
    return _serverErrorDescription;
}

/**
 Simply check if current user credentials has right to login
 Waits until keytech responds
 */
-(NSUInteger)currentUserHasLoginRight{
    
    KTResponseLoader *loader = [[KTResponseLoader alloc]init];
    

    
    [self.ktKeytech performGetUser:self.username loaderDelegate:loader];
    _serverErrorDescription = nil;
    [loader waitForResponse];
    
    _serverErrorDescription = @"API not found. Check Path to Server";
    
    if (loader.requestTimeout){
        _serverErrorDescription = @"API Timeout";
        return 400;
    }
    
    if (loader.loaderInfo.errorCode >= 400) { // License violation, Normally send a notification ? => Multiple error messages can occur
        _serverErrorDescription = loader.loaderInfo.errorDescription;
        return loader.loaderInfo.errorCode;
    }
    
    
    if (loader.firstObject){
        KTUser* user = (KTUser*)loader.firstObject;
        
        if ((user.isActive) ) {  // Check login.User must have an 'active' - state
            return 200;
        }
    }
    
    if (loader.error) {
        _serverErrorDescription = loader.error.localizedDescription;
        return 400; // Not really known error
    }
    
    
    return 400; // Unknown error
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
        [objectManager setRequestSerializationMIMEType: RKMIMETypeJSON];
        [RKObjectManager setSharedManager:objectManager];
    }
    
    // Set new Authorization
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:Username password:Password];
    
}


@end
