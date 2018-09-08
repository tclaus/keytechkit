//
//  KTUser.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
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
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Loads a new user object with the given short username. 
 @param username The short keytech username
 @param success Called after the user object is successfully loaded
 @param failure Called when the user object could not be loaded. The error object will have a localized error message
 */
+(void)loadUserWithKey:(NSString*)username success:(void(^)(KTUser* user))success
               failure:(void(^)(NSError* error))failure;

/**
 Loads a list of server side stored queries. These ware queries definied in the keytech database by a client or admin controlled
 @param success Called after the user object is successfully loaded
 @param failure Called when the user object could not be loaded. The error object will have a localized error message
 */
-(void)loadQueriesSuccess:(void(^)(NSArray <KTTargetLink*> *targetLinks))success
                  failure:(void(^)(NSError* error))failure;

/**
 Loads a list of server side stored queries. These ware queries definied in the keytech database by a client or admin controlled
 @param paramaters A dictionary with query paraneters: withSystemQueries= files,elements,all,none; ignoreTypes=Attributes, none
 @param success Called after the user object is successfully loaded
 @param failure Called when the user object could not be loaded. The error object will have a localized error message
 */
-(void)loadQueriesWithParameters:(NSDictionary*) parameters success:(void (^)(NSArray <KTTargetLink*> *)) success
                         failure:(void (^)(NSError *)) failure;

/**
 Loads a structured list of favorite (KTTargetLink) elements
 @param success Called after the user object is successfully loaded
 @param failure Called when the user object could not be loaded. The error object will have a localized error message
 */
-(void)loadFavoritesSuccess:(void(^)( NSArray <KTTargetLink*> *targetLinks))success
                    failure:(void(^)(NSError* error))failure;

/**
 Returns a list of queries. Is nil when never loaded.
 */
@property (nonatomic) NSArray <KTTargetLink*> *queries;
/**
 Returns a list of favorite elements. Returns nil if never loaded
 */
@property (nonatomic) NSArray <KTTargetLink*> *favorites;

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
-(void)reload:(void(^)(KTUser*))success
      failure:(void(^)(NSError *error))failure;

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
 Returns YES if thos user has the admin role. Admins should administer keytech meta data.
 */
@property (nonatomic) BOOL isAdmin;

/**
 The unique key. Represents the shortname (loginname)
 */
@property (readonly,copy) NSString* identifier;

/**
 The short username. This identifies uniquely a user in the keytech system
 */
@property (nonatomic,copy) NSString* userKey;

/**
 If a user can not be load, a sever error message can be fetched here
 */
@property (readonly,copy) NSString *latestLocalizedServerMessage;

/**
 Represents the name of the used language. Is an internal used name and my be not a ISO language identifier.
 */
@property (nonatomic,copy) NSString* userLanguage;

/**
 Represents the server side user language preference as two character language ID
 */
@property (nonatomic,copy) NSString* userLanguageID;

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


/**
 Loads the currently logged-in user. Failure if user unknown 
 */
+(void)loadCurrentUser:(void (^)(KTUser *user))success
               failure:(void (^)(NSError *error))failure;
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





