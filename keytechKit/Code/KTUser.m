//
//  KTUser.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTUser.h"
#import "KTManager.h"
#import "KTNotifications.h"

#import <RestKit/RestKit.h>

@implementation KTUser{
@private
    BOOL _isGroupListLoaded; // Is loaded
    BOOL _isGroupListLoading; // During al loading process
    
}

static KTUser* _currentUser;


@synthesize isLoaded = _isLoaded;
@synthesize isLoading = _isLoading;


@synthesize userEmail = _userEmail;

@synthesize userKey = _userKey;
@synthesize userLongName = _userLongName;
@synthesize userLanguage =_userLanguage;
@synthesize groupList = _groupList;


static RKObjectMapping* _mapping = nil; /** contains the mapping*/
static RKObjectManager *_usedManager;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _groupList = [[NSMutableArray alloc]init];
        
        _userLanguage = @"";
        _userEmail = @"";
        _isActive = NO;
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
    
    [user reload:success failure:failure];
    
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
        
        [self reload:nil failure:nil];
        [self waitForData];
    }
    
}

-(void)reload:(void (^)(KTUser *))success failure:(void (^)(NSError *))failure{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTUser mappingWithManager:manager];
    
    __weak KTUser *userObject = self;
    
    _isLoaded = NO;
    _isLoading = YES;
    
    
    [manager getObject:userObject path:nil parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   KTUser *user = mappingResult.firstObject;
                   
                   
                   userObject.userEmail =user.userEmail;
                   userObject.userLanguage = user.userLanguage;
                   userObject.userLongName = user.userLongName;
                   userObject.userLanguageID = user.userLanguageID;
                   userObject.isActive = user.isActive;
                   
                   _isLoaded = YES;
                   _isLoading = NO;
                   if (success) {
                       success(self);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                   
                   _latestLocalizedServerMessage = transcodedError.localizedDescription;
                   
                   _isLoaded = NO;
                   _isLoading = NO;
                   
                   if (failure) {
                       failure(transcodedError);
                   }
                   
               }];
    
}

// Returns the unique indetifier key
-(NSString*)identifier{
    return _userKey;
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


-(void)loadFavoritesSuccess:(void (^)(NSArray <KTTargetLink*> *))success
                    failure:(void (^)(NSError *))failure{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTTargetLink mappingWithManager:manager];
    
    NSString *resourcePath = [NSString stringWithFormat:@"user/%@/favorites",self.userKey];
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          self.favorites = mappingResult.array;
                          
                          if (success) {
                              success(mappingResult.array);
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          //TODO: prepaire the error
                          if (failure) {
                              failure(error);
                          }
                      }];
}

-(void)loadQueriesSuccess:(void (^)(NSArray <KTTargetLink*> *))success
                  failure:(void (^)(NSError *))failure{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTTargetLink mappingWithManager:manager];
    
    
    NSString *resourcePath = [NSString stringWithFormat:@"user/%@/queries",self.userKey];
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          self.queries = mappingResult.array;
                          
                          if (success) {
                              success(mappingResult.array);
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          //TODO: prepaire the error
                          if (failure) {
                              failure(error);
                          }
                      }];
}

+(void)loadCurrentUser:(void (^)(KTUser *user))success
               failure:(void (^)(NSError *error))failure{
    
    [KTUser loadUserWithKey:[KTManager sharedManager].username
                    success:^(KTUser *user) {
                        
                        _currentUser = user;
                        
                        if ((success)) {
                            success(user);
                        }
                    } failure:^(NSError *error) {
                        if (failure) {
                            failure(error);
                        }
                    }];
}


+(instancetype)currentUser{
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
    while (_isLoading && (pollCount < MAX_POLL_COUNT)) {
        NSDate* untilDate = [NSDate dateWithTimeIntervalSinceNow:POLL_INTERVAL];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
        pollCount++;
    }
    
    if (pollCount== MAX_POLL_COUNT) {
        NSLog(@"Loading Error in KTUser!");
    }
    
}


-(NSString *)debugDescription{
    return self.userKey;
}

@end




