//
//  Keytech.h
//  keytech search ios
//
//  Created by Thorsten Claus on 13.09.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

@class KTLoaderInfo;


#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "KTKeytechLoader.h"
#import "KTSystemManagement.h"



/**
 Provides main GET functions to fetch data from public API
 */
@interface KTKeytech : NSObject

/**
 For queries- the search result can serverside be filtered to this scope type. Defaults to 'ALL' - no filter.
 */
typedef enum {
    KTScopeAll           = 0,
    KTScopeDocuments     = 1,
    KTScopeMasteritems   = 2,
    KTScopeFolder        = 3
} KTSearchScopeType;


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
-(void)performSearchByQuery:(NSInteger)queryID page:(NSInteger)page withSize:(NSInteger)size loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate;

/**
 Starts a fulltext search with the given search word. Returns a single large page of searchresults. 
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performSearch:(NSString *)searchToken loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Starts a fulltext search with the given search word. Returns pagewise with given page sizes
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performSearch:(NSString *)searchToken page:(NSInteger)page withSize:(NSInteger)size withScope:(KTSearchScopeType)scope loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Queries elements structure from a given elementKey.
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetElementStructure:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Queries element whereused list from a given elementKey.
 whereUsed is the term for elements which has linked to the given element.
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetElementWhereUsed:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Gets a list of available target status. Starting from current element with its given state.
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetElementNextAvailableStatus:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate;


/**
 Queries element notes list
 @param elementKey: the elementkey. All of its notes will be delivered.
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetElementNotes:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Queries the BOm of the given Element.
 Only Items (articles) can have a bom.
 @param:elementKey represents the full elementKey in classtype:ID DEFAULT_MI:1234 notiation.
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetElementBom:(NSString*)elementKey searchDeleagte:(NSObject<KTLoaderDelegate>*)loaderDelegate;

/**
 Queries element from API with given elementKey
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetElement:(NSString*)elementKey withMetaData:(bool)metadata loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate;

/**
 Starts a query to get the element status history.
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetElementStatusHistory:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Get layout for editor for the given classkey an currently logged in user
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetClassEditorLayoutForClassKey:(NSString *)classKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Get default BOM Layout
  @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetClassBOMListerLayout:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Get layout for lister layout for the given classkey an currently logged in user
 @param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetClassListerLayout:(NSString *)classKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Get fileslist from given element
@param loaderDelegate: The object which gets the result. Must implement the <loaderDelegate> protocol.
 */
-(void)performGetFileList:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

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
-(void)performGetRootFolderWithPage:(NSInteger)page withSize:(NSInteger)pageSize delegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;


-(void)cancelQuery;

@property (nonatomic,strong)NSArray *SearchResults;


@end
