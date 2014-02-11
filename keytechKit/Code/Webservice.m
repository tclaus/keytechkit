//
//  webservice.m
//  keytech search ios
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import "Webservice.h"
#import "KTElement.h"
#import "KTNotifications.h"
#import "KTUser.h"
#import "KTResponseLoader.h"



@implementation Webservice{
    
    KTKeytech *ktKeytech;
    BOOL connectionIsValid;
    KTPreferencesConnection* _preferences;
    // Privater Manager
    RKObjectManager* manager;
}

static Webservice* _sharedWebservice = nil;

-(NSString*) servername{
    return _preferences.servername;
}

-(void)setServername:(NSString *)servername{
    _preferences.servername = servername;
}
-(NSString*) username{
    return _preferences.username;
}
-(void)setUsername:(NSString *)username{
    _preferences.username = username;
}

-(NSString*) password{
    return _preferences.password;
}
-(void) setPassword:(NSString *)password{
    _preferences.password = password;
}



/// Creates the singelton class
+(Webservice*) sharedWebservice{
    if (_sharedWebservice == nil) {
        @synchronized(self){
            if (_sharedWebservice == nil) {
                _sharedWebservice = [[super allocWithZone:nil]init];
            }
        }
    }
    return _sharedWebservice;
}

/// Supports singelton Class
+(id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedWebservice];
}
+(void)initialize{
    _sharedWebservice = [[super allocWithZone:nil]init];
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
    if (self && _sharedWebservice==nil) {

        _preferences = [[KTPreferencesConnection alloc]init];
        
        // (Deleted stuff): Make no assume about user preferences. Caller has to take care about user credentials.
        
        // Defaults to demo-Server
        if (self.servername ==nil) self.servername = @"https://api.keytech.de";
        if (self.username ==nil) self.username =@"jgrant";
        if (self.password ==nil) self.password =@"";

        manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.servername]]] ;// @"http://192.168.0.10:8080/keytech"];
        
        [[RKValueTransformer defaultValueTransformer]addValueTransformer:[RKDotNetDateFormatter dotNetDateFormatterWithTimeZone:[NSTimeZone localTimeZone]]];
        

        
        [manager.HTTPClient setAuthorizationHeaderWithUsername:self.username password:self.password];
        
        // Suchprovider angeben
        ktKeytech= [[KTKeytech alloc]init];
        
        // Logging für RestKit definieren
        RKLogConfigureFromEnvironment();
        
        // Timeout definieren
      //  manager.client.timeoutInterval = 20.0; // 20 seconds

        
    }
    return self;
}

-(KTPreferencesConnection*)preferences{
    return _preferences;
}


// Forward search provider class
-(KTKeytech*)ktKeytech{
    return ktKeytech;
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
    
    [ktKeytech performGetUser:self.username loaderDelegate:loader];
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
    
    bool objectsAreEqual =     [[[[RKObjectManager sharedManager]HTTPClient] baseURL] isEqual:[NSURL URLWithString:Servername]];
    if (!objectsAreEqual)
        manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:Servername]];
    
    [manager.HTTPClient setAuthorizationHeaderWithUsername:Username password:Password];
    [RKObjectManager setSharedManager:manager];
    
}


@end
