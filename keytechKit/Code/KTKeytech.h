//
//  Keytech.h
//  keytech search ios
//
//  Created by Thorsten Claus on 13.09.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

@class KTLoaderInfo;


#import <Foundation/Foundation.h>
#import "KTLoaderDelegate.h"
#import "KTSystemManagement.h"
#import "NSPredicate+PredicateKTFormat.h"
#import "KTElement.h"

/**
 Provides main GET functions to fetch data from public API
 */
@interface KTKeytech : NSObject


/**
 Provides acces to basic system level management functions
 */
@property (readonly,nonatomic,strong)KTSystemManagement* ktSystemManagement;


/**
 Default maximal pagesize for paginated queries.
 The larer the page is, the slower it will be transfered. But the smaller ist ist the more roundtrips are needed.
 Use wisely.
 */
@property (nonatomic) NSInteger maximalPageSize;


/**
 Starts a user saved search by it's query ID
 @param queryID: the API's internal id of the requested Query
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performSearchByQueryID:(NSInteger)queryID page:(NSInteger)page withSize:(NSInteger)size loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate;

//#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

-(void)performSearchByPredicate:(NSPredicate*)predicate page:(NSInteger)page withSize:(NSInteger)size loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate;

/**
 Performs a search with a predicate and a success block
 */
-(void)performSearchByPredicate:(NSPredicate*)predicate
                           page:(NSInteger)page
                       withSize:(NSInteger)size
                 loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate
                        success:(void(^)(NSArray *result))success;

//#endif

/**
 Starts a fulltext search with the given search word. Returns a single large page of searchresults.
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performSearch:(NSString *)searchToken loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;


/**
 Start a search with a set of parameters. Set to nil if not needed.
 @param searchToken: One or more words divided by space for searching in a server defined set of fields. Leave empty if no needed.
 @param searchFields: An array of field predicates in the form
 <attributename><Operator><Value> with attributename is a valid keytech internal attribute (as_do__... or au_sdo__..)
 Operator is eqals, greater than, lesser than or nit equal: <,>,=,<>
 and a value in a string format.
 A valid searchfield is eg: "as_do__status=in arbeit", "as_sdo__volume=123"
 @param inClass: as comma separated list of valid classkeys. The list can be requested by a getClasses command.
 @param page: If the response has many elements. Set a Page and a proper  @pageSize for paginated resukltset
 @param pageSize: the maximum requested count of elements within a page
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performSearch:(NSString *)searchToken
              fields:(NSArray*)searchFields
             inClass:(NSString*)inClass
                page:(NSInteger)page
            pageSize:(NSInteger)size
      loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Gets a list of available target status. Starting from current element with its given state.
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetElementNextAvailableStatus:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate
__attribute__((deprecated("Use performGetElementNextAvailableStatus: success: instead")));

/**
 Gets a list of available target status. Starting from current element with its given state.
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetElementNextAvailableStatus:(NSString *)elementKey success:(void(^)(NSArray *result))success;


/**
 Get layout for editor for the given classkey an currently logged in user
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetClassEditorLayoutForClassKey:(NSString *)classKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate
__attribute__((deprecated));

/**
 Get default BOM Layout
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetClassBOMListerLayout:(NSObject<KTLoaderDelegate>*) loaderDelegate
__attribute__((deprecated));

/**
 Get layout for lister layout for the given classkey an currently logged in user
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetClassListerLayout:(NSString *)classKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate
__attribute__((deprecated));


/**
 Gets the permissions set for this user.
 @param userName: Request permissions for the username
 @param findPermissionName: Only find the Permissions named by findPermissionName. Leave empty or nil if not needed.
 @param findEffective: If set return list also provides permissions inherited by group membership.
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetPermissionsForUser:(NSString *)userName findPermissionName:(NSString*)permissionName findEffective:(BOOL)onlyEffectice loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

-(void)performGetUserQueries:(NSInteger)parentLevel loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;
-(void)performGetUserFavorites:(NSInteger)parentLevel loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Gets a single user identified by userName.
 @param userName: The short user name (unique name)
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetUser:(NSString*)userName loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Gets the full users list
 */
-(void)performGetUserList:(NSObject<KTLoaderDelegate>*) loaderDelegate;
/**
 Gets the user who are member of the given group
 @param groupname: All useres who are member of this group will be returned
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetUsersInGroup:(NSString*)groupname loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;


/**
 Gets the full group list
 */
-(void)performGetGroupList:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Gets all groups which contains the given username.
 @param username: All groups which contains this user will be returned
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetGroupsWithUser:(NSString*)username loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate;


/**
 Gets the Tasks assigned to the specific user
 @param userName: The shortname for the user whos tasks are requested.
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetTasksForUser:(NSString *)userName loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Get a list of root folder. This is the top level instance of all folders
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetRootFolder:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Get a list of root folder. This is the top level instance of all folders.
 Can be paginated.
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetRootFolderWithPage:(NSInteger)page withSize:(NSInteger)pageSize loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

#pragma mark Helper Functions


-(void)cancelAllQueries;
-(void)cancelQuery:(NSString*)requestPattern;

@property (nonatomic,strong)NSArray *SearchResults;


@end
