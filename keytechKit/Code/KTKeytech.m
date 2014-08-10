
//
//  SimpleSearch.m
//  keytech search ios
//
//  Created by Thorsten Claus on 13.09.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//


#import "KTKeytech.h"
#import "KTBaseObject.h"

#import "KTResponseLoader.h"

#import "KTNoteItem.h"
#import "KTElement.h"
#import "KTFileInfo.h"
#import "KTTargetLink.h"
#import "KTStatusHistoryItem.h"
#import "KTSimpleControl.h"
#import "KTStatusItem.h"
#import "KTNotifications.h"
#import "KTLoaderInfo.h"
#import "KTBomItem.h"
#import "KTPermission.h"
#import "KTUser.h"
#import "KTGroup.h"
#import "KTManager.h"

@implementation KTKeytech{

}


/**
 Maximal default pageSize
 */
static int const kMaxDefaultPageSize = 500;

/**
 Default maximal pageSize
 */
@synthesize maximalPageSize = _maximalPageSize;
@synthesize ktSystemManagement = _ktSystemManagement;

-(KTSystemManagement*)ktSystemManagement{
    if (!_ktSystemManagement){
        _ktSystemManagement  = [[KTSystemManagement alloc]init];
        
    }
    return _ktSystemManagement;
}

-(void)cancelQuery:(NSString *)requestPattern{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:requestPattern];
}

-(void)cancelAllQueries{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:@""];
    
}

/// Gets Permission for the given username.
-(void)performGetPermissionsForUser:(NSString *)userName findPermissionName:(NSString*)permissionName findEffective:(BOOL)effective loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{

    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTPermission mappingWithManager:manager];
    
    NSMutableDictionary *rpcData = [NSMutableDictionary dictionary];
    

    if (permissionName) {
        rpcData[@"type"] = permissionName; // Only the type. Should be nil
    }
    if (effective == YES) {
        rpcData[@"effective"] = @"1"; // effective permissions (including inherited by group membership)
    } else {
        rpcData[@"effective"] = @"0"; // Only get direct set permissionSet
    }
    
    NSString* resourcePath = [NSString stringWithFormat:@"user/%@/permissions",userName];
    
    
    
    [manager getObjectsAtPath:resourcePath parameters:rpcData
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
         
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResourceString:resourcePath] error:error];
     }];
    
    
}


//Gets the users Tasks.
-(void)performGetTasksForUser:(NSString *)userName loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{

    /*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTElement setMapping];
    itemMapping.rootKeyPath = @"ElementList";
    
    NSString* resourcePath = [NSString stringWithFormat:@"user/%@/tasks",userName];
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
    }];
    */
}

/*
 Ruft für den aktuellen Benutzer die gespeicherten Suchen (intelligente Listen) ab der Ebene ab
 */
-(void)performGetUserQueries:(NSInteger)parentLevel loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{

    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTTargetLink mappingWithManager:manager];
    
    NSString* username = [KTManager sharedManager].username;
    

    NSString* resourcePath;
    
    // Parentlevel wird nicht unterstützt!
    // es wird immer die vollständige Liste angefordert
    parentLevel = 0;
    
    if (parentLevel!= 0){
        resourcePath= [NSString stringWithFormat:@"user/%@/queries/%ld", username,(long)parentLevel ];
    }else {
        resourcePath= [NSString stringWithFormat:@"user/%@/queries", username ];
    }
    
    
[manager getObjectsAtPath:resourcePath parameters:nil
                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                      [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                      [loaderDelegate requestProceedWithError:[KTLoaderInfo ktLoaderInfo] error:error];
                  }];
    
    
}


/**
 Getting a list of user favorites
 */
-(void)performGetUserFavorites:(NSInteger)parentLevel loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{

    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString* username = [KTManager sharedManager].username;
    
    [KTTargetLink mappingWithManager:manager];
    NSString* resourcePath;

    if (parentLevel!= 0){
     resourcePath= [NSString stringWithFormat:@"user/%@/favorites/%ld", username,(long)parentLevel ];
    }else {
     resourcePath= [NSString stringWithFormat:@"user/%@/favorites", username ];
    }
    
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo ktLoaderInfo] error:error];
                      }];

    
}

/// Returns a single user identified by shortname
-(void)performGetUser:(NSString*)userName loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;{

    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTUser mappingWithManager:manager];

    //
    NSString* resourcePath = [NSString stringWithFormat:@"user/%@", userName];;
    
    [manager getObject:nil path:resourcePath parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   
                   NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;

                   [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
               }];
     

}

/// Returns a full userlist
-(void)performGetUserList:(NSObject<KTLoaderDelegate>*) loaderDelegate{

    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTUser mappingWithManager:manager];
    //
    NSString* resourcePath = @"user";
    
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResourceString:resourcePath] error:error];
                      }];

 }

/// Returns the userlist which are member of the given group
-(void)performGetUsersInGroup:(NSString*)groupname loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
/*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTUser setMapping];
    itemMapping.rootKeyPath = @"MembersList";
    

    NSString* resourcePath = [NSString stringWithFormat:@"/groups/%@/users",groupname];
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    */
    
}

/// Returns the full group list
-(void)performGetGroupList:(NSObject<KTLoaderDelegate> *)loaderDelegate{

    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTGroup mappingWithManager:manager];
    
    NSString* resourcePath = @"groups";
    
    [manager getObjectsAtPath:resourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResourceString:resourcePath] error:error];
                      }];
}

/// Returns all groups with the given username in it.
-(void)performGetGroupsWithUser:(NSString *)username loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{

    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTGroup mappingWithManager:manager];

    NSString* resourcePath = [NSString stringWithFormat:@"user/%@/groups",username];
    
    
    [manager getObjectsAtPath:resourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResourceString:resourcePath] error:error];
                      }];
}

// Getting notes
-(void)performGetElementNotes:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{

    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTNoteItem mappingWithManager:manager];
    
    elementKey = [KTBaseObject normalizeElementKey:elementKey];
    
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/notes", elementKey];
    
    
    [manager getObjectsAtPath:resourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                        [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResourceString:resourcePath] error:error];
                      }];

}

/**
 Getting the default BOM lister layout
 */
-(void)performGetClassBOMListerLayout:(NSObject<KTLoaderDelegate>*) loaderDelegate{

    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTSimpleControl mappingWithManager:manager];
    
    // itemMapping.rootKeyPath = @"DesignerControls";
    
    NSString* resourcePath = @"classes/bom/listerlayout";
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResourceString:resourcePath] error:error];
                      }];
    
}


/**
Getting lister layout data for the given classkey and the current logged in user.
 */
-(void)performGetClassListerLayout:(NSString *)classKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTSimpleControl mappingWithManager:manager];
    
    classKey = [KTBaseObject normalizeElementKey:classKey];
    
    NSString* resourcePath = [NSString stringWithFormat:@"classes/%@/listerlayout", classKey];
    [manager getObjectsAtPath:resourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResourceString:resourcePath] error:error];
                      }];
    
    
}


/*
 Ruft das Editor-Layout der angegebenen Klasse ab
 */
-(void)performGetClassEditorLayoutForClassKey:(NSString *)classKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
 
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTSimpleControl mappingWithManager:manager];
    
    classKey = [KTBaseObject normalizeElementKey:classKey];
    
    
    NSString* resourcePath = [NSString stringWithFormat:@"classes/%@/editorlayout", classKey];
    
    
    [manager getObjectsAtPath:resourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResourceString:resourcePath] error:error];
                          
                      }];
    
}

// gets a Element
-(void)performGetElement:(NSString*)elementKey withMetaData:(KTResponseAttributes)metadata loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate{

    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // ResourcePath zusammenbauen
    elementKey = [KTBaseObject normalizeElementKey:elementKey];
    NSString* resourcePath =  [NSString stringWithFormat:@"Elements/%@",elementKey];
    
    // Initilize the mapping
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    // Requests full Elements Metadata
    switch (metadata) {
        case KTResponseNoneAttributes:
            // No special treatment
            break;
        case KTResponseFullAttributes:
            rpcData[@"attributes"] = @"ALL";
            break;
        case KTRespnseEditorAttributes:
            rpcData[@"attributes"] = @"Editor";
            break;
        case KTResponseListerAttributes:
            rpcData[@"attributes"] = @"Lister";
            break;
        default:
            break;
    }
    

    

    [manager getObject:nil path:resourcePath parameters:rpcData
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
    
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
        [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
    }];
    


}




/**
Gets the filelist of given elementKey
 */
-(void)performGetFileList:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTFileInfo mappingWithManager:manager];
    
    elementKey = [KTBaseObject normalizeElementKey:elementKey];
    
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/files", elementKey];
    
   [manager getObjectsAtPath:resourcePath
                  parameters:nil
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                         
                     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                         
                         NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                         [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
                     }];

}


/// Ruft von einem gegebenen Elementschlüssel die zugehörige Statushistorie ab
-(void)performGetElementStatusHistory:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTStatusHistoryItem mappingWithManager:manager];
    elementKey = [KTBaseObject normalizeElementKey:elementKey];
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/statushistory",elementKey];
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
                          
                          
                      }];
    
}

// Gets the List of parent elements which links to the given element
-(void)performGetElementWhereUsed:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
    
    elementKey = [KTBaseObject normalizeElementKey:elementKey];
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/whereused",elementKey];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager getObjectsAtPath:resourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
                      }];
    
}

//Gets a list of available target status. Starting from current element with its given state.
-(void)performGetElementNextAvailableStatus:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{

     RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTStatusItem mappingWithManager:manager];
    
    elementKey = [KTBaseObject normalizeElementKey:elementKey];
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/nextstatus",elementKey];
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
                      }];

}

/// Gets a list of the given Elemets versions
-(void)performGetElementVersions:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
     
    elementKey = [KTBaseObject normalizeElementKey:elementKey];
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/versions",elementKey];
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
                      }];
    
}

// Queries a full list of root folder without any parents. Uses maximal pagesize
-(void)performGetRootFolder:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    [self performGetRootFolderWithPage:1 withSize:self.maximalPageSize loaderDelegate:loaderDelegate];
}

// Queries a full list of root folder without any parents.]
-(void)performGetRootFolderWithPage:(NSInteger)page withSize:(NSInteger)pageSize loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{

    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
    
    NSString* resourcePath = @"folder/rootfolder";
    
    [manager getObjectsAtPath:resourcePath
               parameters:nil
                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                      [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      
                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                      NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                      [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
                      
                  }];
    

}

// Gets the Bom of provided element
-(void)performGetElementBom:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTBomItem mappingWithManager:manager];
    
    elementKey = [KTBaseObject normalizeElementKey:elementKey];
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/bom",elementKey];
    
    [manager getObjectsAtPath:resourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
                      }];
 
}



/// Queries the underlying element structure.
-(void)performGetElementStructure:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTElement mappingWithManager:manager];
    
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/structure",elementKey];
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          
                          NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
                      }];
    
}

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

-(void)cancelSearches{
    [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET
                                                            matchingPathPattern:@"Search"];

}

-(void)performSearchByPredicate:(NSPredicate*)predicate page:(NSInteger)page withSize:(NSInteger)size loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate{
    [self performSearchByPredicate:predicate
                              page:page
                          withSize:size
                    loaderDelegate:loaderDelegate
                           success:nil];
     
}

-(void)performSearchByPredicate:(NSPredicate*)predicate
     page:(NSInteger)page
     withSize:(NSInteger)size
     loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate
     success:(void(^)(NSArray *result))success {
  
    [self cancelSearches];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTElement mappingWithManager:manager];
    
    NSString *resourcePath = @"Search";
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    NSString *queryString = [predicate predicateKTQueryText];
    NSString *fieldList = [predicate predicateKTFormat];
    NSString *classtypes = [predicate predicateKTClasstypes];
    
    if (queryString) {
        rpcData[@"q"] = queryString;
    }
    
    if (classtypes) {
        rpcData[@"classtypes"] = classtypes;
    }
    
    if (fieldList) {
        rpcData[@"fields"] = fieldList;
    }

    rpcData[@"page"] = @((int)page);
    rpcData[@"size"] = @((int)size);
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

                   // Dont call Block and delegate
                   if (success) {
                       success(mappingResult.array);
                   } else {
                       [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                   if (!operation.isCancelled){
                       [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
                   }
               }];
    
}
#endif

/// Stats a Search by its queryID
-(void)performSearchByQueryID:(NSInteger)queryID page:(NSInteger)page withSize:(NSInteger)size loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate{


    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
    
    
    // Creating Query Parameter
    
    NSString *resourcePath = @"Search";
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"byQuery"] = @((int)queryID);
    rpcData[@"page"] = @((int)page);
    rpcData[@"size"] = @((int)size);
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                   
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                   [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
               }];
    

}


/// Searchs for ALL with pagesize 500
-(void)performSearch:(NSString *)searchToken loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
    
    [self performSearch:searchToken
                 fields:nil
                inClass:nil
                   page:1
               pageSize:500
         loaderDelegate:loaderDelegate];
    
}


/// The search
-(void)performSearch:(NSString *)searchToken
        fields:(NSArray*)searchFields
        inClass:(NSString*)inClass
        page:(NSInteger)page
        pageSize:(NSInteger)size
        loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{

        
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
   
    // Initialize the mapping if not already done
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
    
    NSString *resourcePath = @"Search";
    
    // Creating Query Parameter
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    if (searchToken) {
        rpcData[@"q"] = searchToken;
    }
    
    if (inClass) {
        rpcData[@"classtypes"] = inClass;
    }
    if (searchFields) {
        NSMutableString *fields = [NSMutableString stringWithString:@""];
        for (NSString* item in searchFields) {
            if ([fields length]>0){
                
            [fields appendString:@":"]; // add a new string
            }
            [fields appendString:item];
        }
        
        rpcData[@"fields"] = fields;
    }

    
    rpcData[@"page"] = @((int)page);
    rpcData[@"size"] = @((int)size);

    
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {

                   NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                   [loaderDelegate requestProceedWithError:[KTLoaderInfo loaderInfoWithResponse:response resourceString:resourcePath] error:error];
               }];

}


- (id)init
{
    self = [super init];
    if (self) {
        // Set to a resonably defaultvalue
        self.maximalPageSize = kMaxDefaultPageSize;
        
    }
    
    return self;
}


@end
