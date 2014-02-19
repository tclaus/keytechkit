//
//  KTUser.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTUser.h"
#import "Webservice.h"
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

@synthesize userEmail = _userEmail;

@synthesize userKey = _userKey;
@synthesize userLongName = _userLongName;
@synthesize userLanguage =_userLanguage;
@synthesize groupList = _groupList;
@synthesize permissionsList =_permissionsList;


static RKObjectMapping* _mapping = nil; /** contains the mapping*/

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

+(id)mapping{
    if (!_mapping){
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
        
        [[RKObjectManager sharedManager]addResponseDescriptor:userResponse];
    }
    
    
    return _mapping;
    
}

// Returns the key
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

@end
