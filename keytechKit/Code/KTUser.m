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
                                                       @"LanguageID":@"userLanguageID",
                                                       @"LongName":@"userLongName",
                                                       @"eMail":@"userMail"
                                                       }];
        RKResponseDescriptor *userResponse = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                                                          method:RKRequestMethodAny
                                                                                     pathPattern:nil keyPath:@"MembersList"
                                                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        // Path Argument
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTUser class]
                                           pathPattern:@"user/:userKey"
                                           method:RKRequestMethodGET]] ;
        
        
        [_usedManager addResponseDescriptor:userResponse];
       // [_usedManager addResponseDescriptor:userResponseClientError];
    }
    
    
    return _mapping;
    
}

+(void)loadUserWithKey:(NSString *)username success:(void (^)(KTUser *user))success failure:(void (^)(NSError *error))failure{
    
    KTUser *user = [[KTUser alloc]init] ;
    user.userKey = username;
    
    [user reload:success];
    
}

+(KTUser*)loadUserWithKey:(NSString *)username{
    KTUser *user = [[KTUser alloc]init] ;
    user.userKey = username;

    [user reload];
    return user;
}

// Starts reloading the user. The userkey is needed.
-(void)reload{
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
                   
                   

                   self.userEmail =user.userEmail;
                   self.userLanguage = user.userLanguage;
                   self.userLongName = user.userLongName;

                   _isLoaded = YES;
                   _isLoading = NO;
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
//TODO: Load Permisisons
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
       //TODO: Load Users groups
        return _groupList;
    }
}


-(void)loadFavoritesSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{

    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTTargetLink mappingWithManager:manager];
    
    NSString *resourcePath = [NSString stringWithFormat:@"user/%@/favorites",self.userKey];
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          self.favorites = mappingResult.array;
                          
                          if (success) {
                              success(self.favorites);
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          //TODO: prepaire the error
                          if (failure) {
                              failure(error);
                          }
                      }];
}

-(void)loadQueriesSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{

    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTTargetLink mappingWithManager:manager];
    
    
    NSString *resourcePath = [NSString stringWithFormat:@"user/%@/queries",self.userKey];
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          self.queries = mappingResult.array;
                          
                          if (success) {
                              success(self.queries);
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          //TODO: prepaire the error
                          if (failure) {
                              failure(error);
                          }
                      }];
}

+(instancetype)currentUser{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentUser = [[KTUser alloc]init];
        _currentUser.userKey = [KTManager sharedManager].username;
        [_currentUser reload];
    });
    
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




