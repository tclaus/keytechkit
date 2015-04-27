//
//  KTUser.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTIdentifiedDataSource.h"
#import "KTTargetLink.h"

/**
 Represets a user object
 */
@interface KTUser : NSObject <KTIdentifiedDataSource>

/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Loads a new user object with the given short username. 
 @param username The short keytech username
 @param success Called after the user object is loaded
 @param failure Called when the user object could not be loaded
 */
+(void)loadUserWithKey:(NSString*)username success:(void(^)(KTUser* user))success failure:(void(^)(NSError* error))failure;

/**
 Loads a list of server side stored queries. These ware queries definied in the keytech database by a client or admin controlled
 */
-(void)loadQueriesSuccess:(void(^)(NSArray* targetLinks))success failure:(void(^)(NSError* error))failure;
/**
 Loads a structured list of favorie elemets
 */
-(void)loadFavoritesSuccess:(void(^)(NSArray* targetLinks))success failure:(void(^)(NSError* error))failure;

/**
 Returns a list of queries. Is NIL when never loaded.
 */
@property (nonatomic,weak) NSArray* queries;
/**
 Returns a list of favorite elements. Returns nil if never loaded
 */
@property (nonatomic,weak) NSArray* favorites;

/**
 Loads a new user objects but waits until returns
  @param username The short keytech username
 */
+(KTUser*)loadUserWithKey:(NSString*)username;

/**
 Reloads the userobject. Waits until object is loaded.
 */
-(void)reload;

/*
 Reloads the current userobject. All settings will be lost
@param success Will be called after the object is loaded
 */
-(void)reload:(void(^)(KTUser*))success;


/**
 Returns YES if this user is active. (Means it's allowed to login and can use services.
 */
@property (nonatomic) BOOL isActive;

/**
 Returns YES if this user has the superuser Role. Superusers have special and advanced rights to edit data. 
 Superuser dont have automaticaly admin rights.
 */
@property (nonatomic) BOOL isSuperuser;

/**
 Returns YES if thos user has the admin role. Admins should administer keytechs meta data.
 */
@property (nonatomic) BOOL isAdmin;


/**
 The unique key. Represents the shortname (loginname)
 */
@property (readonly,copy)NSString* identifier;
@property (nonatomic,copy)NSString* userKey;


/**
 Represents the name of the used language. Is an internal used name and my be not a ISO language identifier.
 */
@property (nonatomic,copy) NSString* userLanguage;

/**
The users longname. 
*/
@property (nonatomic,copy) NSString* userLongName;

/**
 The users email address
 */
@property (nonatomic,copy) NSString* userEmail;

/**
 Contains the list of Groups the user is assigned in
 */
@property (nonatomic,readonly)NSMutableArray *groupList;

/**
 Empties the group list and forces a reload on next read access
 */
-(void)refreshGroups;
/**
 Return YES if permission list is loaded. Returns NO if not loaded or loading in progress
 */
@property (nonatomic,readonly) BOOL isPermissionListLoaded;
@property (nonatomic,readonly)NSMutableArray *permissionsList;

/**
 Empties the permissions list and forces a reload on next read access
 */
-(void)refreshPermissions;

/**
 Creates and returns the instance of the currently logged in user account.
 */
+(instancetype)currentUser;

/**
 Indicates that a loading is in progress
 */
@property (nonatomic,readonly)BOOL isLoaded;
/**
 Indicates that the object is loaded
 */
@property (nonatomic,readonly) BOOL isLoading;

@end





