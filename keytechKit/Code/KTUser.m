//
//  KTUser.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTUser.h"
#import "KTManager.h"
#import "KTNotifications.h"

#import <RestKit/RestKit.h>

@implementation KTUser{
@private
    BOOL _isGroupListLoaded; // Is loaded
    BOOL _isGroupListLoading; // During al loading process
    
    BOOL _isPermissionLoaded;
    BOOL _isPermissionLoading;
    
    KTKeytech *ktManager;
}

static KTUser* _currentUser;


@synthesize isLoaded = _isLoaded;
@synthesize isLoading = _isLoading;


@synthesize userEmail = _userEmail;

@synthesize userKey = _userKey;
@synthesize userLongName = _userLongName;
@synthesize userLanguage =_userLanguage;
@synthesize groupList = _groupList;
@synthesize permissionsList =_permissionsList;


static RKObjectMapping* _mapping = nil; /** contains the mapping*/
static RKObjectManager *_usedManager;

- (id)init
{
    self = [super init];
    if (self) {
        
        ktManager= [[KTKeytech alloc]init];
        _groupList = [[NSMutableArray alloc]init];
        _permissionsList = [[NSMutableArray alloc]init];
        
        _userLanguage = @"";
        _userEmail = @"";
        _isActive = YES;
        _isAdmin = NO;
        _isSuperuser = NO;
        _userLanguage = @"";
        _userLongName = @"";
        
    }
    return self;
}

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTUser class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"IsActive":@"isActive",
                                                       @"IsAdmin":@"isAdmin",
                                                       @"IsSuperuser":@"isSuperuser",
                                                       @"KeyName":@"userKey",
                                                       @"Language":@"userLanguage",
                                                       @"LongName":@"userLongName",
                                                       @"eMail":@"userMail"
                                                       }];
        RKResponseDescriptor *userResponse = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                                                          method:RKRequestMethodAny
                                                                                     pathPattern:nil keyPath:@"MembersList"
                                                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        // In case of an error an empty user is returned
        RKResponseDescriptor *userResponseClientError = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                                                                     method:RKRequestMethodAny
                                                                                                pathPattern:nil keyPath:@"MembersList"
                                                                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
        
        // Path Argument
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTUser class]
                                           pathPattern:@"user/:userKey"
                                           method:RKRequestMethodGET]] ;
        
        
        [_usedManager addResponseDescriptor:userResponse];
        [_usedManager addResponseDescriptor:userResponseClientError];
    }
    
    
    return _mapping;
    
}

+(void)loadUserWithKey:(NSString *)username success:(void (^)(KTUser *user))success failure:(void (^)(NSError *error))failure{
    
    KTUser *user = [[KTUser alloc]init] ;
    user.userKey = username;
    NSLog(@"Start loading user with key %@",username);
    
    [user reload:success];
    
}

// Starts reloading the user. The userkey is needed.
-(void)reload{
    NSLog(@"Start reloadung user with key %@",self.userKey);
    if (!_isLoading) {
        _isLoaded = NO;
        _isLoading = YES;
        
        [self reload:nil];
        [self waitForData];
    }
    
}

-(void)reload:(void (^)(KTUser *))success{
        NSLog(@"Start reloading user with key %@",self.userKey);
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTUser mappingWithManager:manager];
    
    __weak KTUser *userObject = self;
    
    [manager getObject:userObject path:nil parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       NSLog(@"Successful reloaded user with key %@",self.userKey);
                   KTUser *user = mappingResult.firstObject;
                   
                   _isLoaded = YES;
                   _isLoading = NO;
                   
                   self.userEmail =user.userEmail;
                   self.userLanguage = user.userLanguage;
                   self.userLongName = user.userLongName;
                   
                   if (success) {
                       success(self);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error while getting the user-object: %@",error.localizedDescription);
                   _isLoaded = NO;
                   _isLoading = NO;
               }];

}

// Returns the unique indetifier key
-(NSString*)identifier{
    return _userKey;
}


-(BOOL)isPermissionListLoaded{
    return _isPermissionLoaded;
}

-(void)refreshPermissions{
    _isPermissionLoaded = NO;
    [_permissionsList removeAllObjects];
}

//Layzy load PermissionLIst
-(NSMutableArray*)permissionsList{
    if (_isPermissionLoaded &! _isPermissionLoading) {
        return _permissionsList;
    } else {
        _isPermissionLoading = YES;
        [ktManager performGetPermissionsForUser:self.identifier findPermissionName:nil findEffective:NO loaderDelegate:self];
        return _permissionsList;
    }
}


-(void)refreshGroups{
    _isGroupListLoaded = NO;
    [_groupList removeAllObjects];
}

// Lazy loads the grouos list
-(NSMutableArray*)groupList{
    if (_isGroupListLoaded & !_isGroupListLoading){
        return _groupList;
    }else{
        _isGroupListLoading = YES;
        [ktManager performGetGroupsWithUser:self.userKey loaderDelegate:self];
        return _groupList;
    }
}
-(void)requestProceedWithError:(KTLoaderInfo*)loaderInfo error:(NSError*)theError{
#pragma mark Todo: Error handler implementieren
}

// Perform getting the groups list
-(void)requestDidProceed:(NSArray*)searchResult fromResourcePath:(NSString*)resourcePath{
    // Groups
    if ([resourcePath hasSuffix:@"/groups"]){
        // Set for KVC
        _isGroupListLoading = NO;
        _isGroupListLoaded = YES;
        
        if (!_groupList){
            _groupList = [[NSMutableArray alloc] initWithArray:searchResult];
        }
        
        // Set by KVC
        [self willChangeValueForKey:@"groupList"];
        [self.groupList setArray:searchResult];
        [self didChangeValueForKey:@"groupList"];
        
        
        return;
    }
    
    if ([resourcePath rangeOfString:@"/permissions"].location !=NSNotFound) {
        _isPermissionLoading = NO;
        _isPermissionLoaded = YES;
        
        if(!_permissionsList){
            _permissionsList = [NSMutableArray array];
        }
        [self willChangeValueForKey:@"permissionsList"];
        [_permissionsList setArray:searchResult];
        [self didChangeValueForKey:@"permissionsList"];
        
    }
    
}


+(instancetype)currentUser{
    if (!_currentUser) {
        _currentUser = [[KTUser alloc]init];
        _currentUser.userKey = [KTManager sharedManager].username;
        [_currentUser reload];
    }
    return _currentUser;
}



-(void)waitForData{
    // Wait
#define POLL_INTERVAL 0.2 // 200ms
#define N_SEC_TO_POLL 30.0 // poll for 30s
#define MAX_POLL_COUNT N_SEC_TO_POLL / POLL_INTERVAL
    
    if (!_isLoading && !_isLoaded) {
        // Load was not triggered
        return;
    }
    
    NSUInteger pollCount = 0;
    while (!_isLoaded && (pollCount < MAX_POLL_COUNT)) {
        NSDate* untilDate = [NSDate dateWithTimeIntervalSinceNow:POLL_INTERVAL];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
        pollCount++;
    }
    
    if (pollCount== MAX_POLL_COUNT) {
        NSLog(@"Loading Error in KTUSer!");
    }
    
}



@end




