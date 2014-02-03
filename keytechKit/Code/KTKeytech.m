
//
//  SimpleSearch.m
//  keytech search ios
//
//  Created by Thorsten Claus on 13.09.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import "KTKeytech.h"
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

@implementation KTKeytech{

}


/**
 Maximal default pageSize
 */
static int const kMaxDefaultPageSize = 500;
static  RKObjectManager *manager;

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

-(void)cancelQuery{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [manager cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:nil];
    
}

/// Gets Permission for the given username.
-(void)performGetPermissionsForUser:(NSString *)userName findPermissionName:(NSString*)permissionName findEffective:(BOOL)effective loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{

    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSMutableDictionary *rpcData = [NSMutableDictionary dictionary];
    

    if (permissionName) {
        rpcData[@"type"] = permissionName; // Only the type. Should be nil
    }
    if (effective == YES) {
        rpcData[@"effective"] = @"1"; // effective permissions (including inherited by group membership)
    } else {
        rpcData[@"effective"] = @"0"; // Only get direct set permissionSet
    }
    
    NSString* resourcePath = [NSString stringWithFormat:@"/user/%@/permissions",userName];
    
    
    
    [manager getObjectsAtPath:resourcePath parameters:rpcData
    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         
         [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:@""];
         
         
         NSLog(@"It Worked: %@", [mappingResult array]);
         // Or if you're only expecting a single object:
         NSLog(@"It Worked: %@", [mappingResult firstObject]);
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         NSLog(@"It Failed: %@", error);
     }];
    
    
}


//Gets the users Tasks.
-(void)performGetTasksForUser:(NSString *)userName loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{

    /*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTSimpleItem setMapping];
    itemMapping.rootKeyPath = @"ElementList";
    
    NSString* resourcePath = [NSString stringWithFormat:@"/user/%@/tasks",userName];
    
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

    /*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString* username = [RKClient sharedClient].username;
    
    RKObjectMapping* itemMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[KTTargetLink class]];
    itemMapping.rootKeyPath = @"TargetLinks";
    NSString* resourcePath;
    
    // Parentlevel wird nicht unterstützt!
    // es wird immer die vollständige Liste angefordert
    parentLevel = 0;
    
    if (parentLevel!= 0){
        resourcePath= [NSString stringWithFormat:@"/user/%@/queries/%ld", username,(long)parentLevel ];
    }else {
        resourcePath= [NSString stringWithFormat:@"/user/%@/queries", username ];
    }
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        // loader.params = [RKRequestSerialization serializationWithData:[jso
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    
    */
}


/**
 Getting a list ob user favorites
 */
-(void)performGetUserFavorites:(NSInteger)parentLevel loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{

    /*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString* username = [RKClient sharedClient].username;
    
    RKObjectMapping* itemMapping = [KTTargetLink setMapping];
    itemMapping.rootKeyPath = @"TargetLinks";
    NSString* resourcePath;


    
    if (parentLevel!= 0){
     resourcePath= [NSString stringWithFormat:@"/user/%@/favorites/%ld", username,(long)parentLevel ];
    }else {
     resourcePath= [NSString stringWithFormat:@"/user/%@/favorites", username ];
    }
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
       // loader.params = [RKRequestSerialization serializationWithData:[jso
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    */
    
}

/// Returns a single user identified by shortname
-(void)performGetUser:(NSString*)userName loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;{

    /*
    
    
    RKObjectMapping* itemMapping = [KTUser setMapping];
    itemMapping.rootKeyPath = @"MembersList";
    //
    NSString* resourcePath = [NSString stringWithFormat:@"/user/%@", userName];;
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    */
}

/// Returns a full userlist
-(void)performGetUserList:(NSObject<KTLoaderDelegate>*) loaderDelegate{
/*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTUser setMapping];
    itemMapping.rootKeyPath = @"MembersList";
    //
    NSString* resourcePath = @"/user";
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
*/
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
/*
    
    
    
    RKObjectMapping* itemMapping = [KTGroup setMapping];
    itemMapping.rootKeyPath = @"MembersList";
    //
    NSString* resourcePath = @"/groups";
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    */
}

/// Returns all groups with the given username in it.
-(void)performGetGroupsWithUser:(NSString *)username loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
/*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTGroup setMapping];
    itemMapping.rootKeyPath = @"MembersList";
    itemMapping.objectClass = [KTGroup class];
    //
    NSString* resourcePath = [NSString stringWithFormat:@"/user/%@/groups",username];
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    */
}

// Getting notes
-(void)performGetElementNotes:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
/*

 
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"elementKey"] = elementKey;


    RKObjectMapping* itemMapping = [KTNoteItem setMapping];
    itemMapping.rootKeyPath = @"NotesList";
    
    NSString* resourcePath = [NSString stringWithFormat:@"/elements/%@/notes", elementKey];
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        //loader.params = [RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON] ;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
*/
}

/**
 Getting the default BOM lister layout
 */
-(void)performGetClassBOMListerLayout:(NSObject<KTLoaderDelegate>*) loaderDelegate{
/*
 
    
    //RKObjectMapping* itemMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[KTSimpleControl class]];
    
    RKObjectMapping* itemMapping = [KTSimpleControl setMapping];
    
    itemMapping.rootKeyPath = @"DesignerControls";
    
    NSString* resourcePath = @"/classes/bom/listerlayout";
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    */
}

/**
Getting lister layout data for the given classkey and the current logged in user.
 */
-(void)performGetClassListerLayout:(NSString *)classKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
/*
 
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"classKey"] = classKey;
    
    [KTSimpleControl setMapping];
    
    // This did not work in unit Tests
    //RKObjectMapping* itemMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[KTSimpleControl class]];
    
    // This works in unit-Tests also
    RKObjectMapping* itemMapping = [KTSimpleControl setMapping];
    itemMapping.rootKeyPath = @"DesignerControls";
    
    NSString* resourcePath = [NSString stringWithFormat:@"/classes/%@/listerlayout", classKey];
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        //loader.params = [RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON] ;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    */
    
}


/*
 Ruft das Editor-Layout der angegebenen Klasse ab
 */
-(void)performGetClassEditorLayoutForClassKey:(NSString *)classKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
/*
 
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"classKey"] = classKey;
    
    
    RKObjectMapping* itemMapping = [KTSimpleControl setMapping];
    itemMapping.rootKeyPath = @"DesignerControls";
    
    NSString* resourcePath = [NSString stringWithFormat:@"/classes/%@/editorlayout", classKey];
    
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        //loader.params = [RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON] ;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    */
}

// gets a Element
-(void)performGetElement:(NSString*)elementKey withMetaData:(bool)metadata loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate{

 
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    // Requests full Elements Metadata
    if (metadata) {
        rpcData[@"attributes"] = @"Editor"; // Editor / Lister / ALL / None
    }
    
    // ResourcePath zusammenbauen
    NSString* resourcePath =  [NSString stringWithFormat:@"/Elements/%@",elementKey];
    
    
    // Initilize the mapping
    [KTElement mapping];
    [manager getObject:nil path:nil parameters:rpcData success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [loaderDelegate requestDidProceed:mappingResult.firstObject fromResourcePath:@"/Elements"];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        [loaderDelegate requestProceedWithError:[[KTLoaderInfo alloc]init]  error:error];
    }];
    


}

/**
Gets the filelist of given elementKey
 */
-(void)performGetFileList:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
    /*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"elementKey"] = elementKey;
    
    //Parsing rpcData to JSON!
    //id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
    //NSError *error = nil;
    //NSString *json = [parser stringFromObject:rpcData error:&error];
    
    RKObjectMapping* itemMapping = [KTFileInfo setMapping];
    itemMapping.rootKeyPath = @"GetElementFileListResult";
    
    
    NSString* resourcePath = [NSString stringWithFormat:@"/elements/%@/files", elementKey];
    
        [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        //loader.params = [RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON] ;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;

    }];
    */

}



-(void)performGetElementStatusHistory:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
/*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTStatusHistoryItem setMapping];
    itemMapping.rootKeyPath = @"StatusHistoryEntries";
    
    NSString* resourcePath = [NSString stringWithFormat:@"/elements/%@/statushistory",elementKey];
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
*/
}

// Gets the List of parent elements which links to the given element
-(void)performGetElementWhereUsed:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    /*
    
    
    RKObjectMapping* itemMapping = [KTSimpleItem setMapping];
    itemMapping.rootKeyPath = @"ElementList";
    
    NSString* resourcePath = [NSString stringWithFormat:@"/elements/%@/whereused",elementKey];
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
     */
    
}

//Gets a list of available target status. Starting from current element with its given state.
-(void)performGetElementNextAvailableStatus:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
/*
 
    
    
    RKObjectMapping* itemMapping = [KTStatusItem setMapping];
    itemMapping.rootKeyPath = @"Statuslist";
    
    NSString* resourcePath = [NSString stringWithFormat:@"/elements/%@/nextstatus",elementKey];
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    */
}

// Queries a full list of root folder without any parents. Uses maximal pagesize
-(void)performGetRootFolder:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    [self performGetRootFolderWithPage:1 withSize:self.maximalPageSize delegate:loaderDelegate];
}

// Queries a full list of root folder without any parents.
-(void)performGetRootFolderWithPage:(NSInteger)page withSize:(NSInteger)pageSize delegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
/*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTSimpleItem setMapping];
    itemMapping.rootKeyPath = @"ElementList";
    
    NSString* resourcePath = @"/folder/rootfolder";
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
        loader.serializationMIMEType = RKMIMETypeJSON;
    }];
    
 */
}

// Gets the Bom of provided element
-(void)performGetElementBom:(NSString *)elementKey searchDeleagte:(NSObject<KTLoaderDelegate> *)loaderDelegate{
/*
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKObjectMapping* itemMapping = [KTBomItem setMapping];
    itemMapping.rootKeyPath = @"BomElementList";
    
    NSString* resourcePath = [NSString stringWithFormat:@"/elements/%@/bom",elementKey];
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
    }];
 */
}



//Queries the underlying element structure.
-(void)performGetElementStructure:(NSString *)elementKey loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{

    /*
   
    RKObjectManager *manager = [RKObjectManager sharedManager];
    

    
    RKObjectMapping* itemMapping = [KTSimpleItem setMapping];
    itemMapping.rootKeyPath = @"ElementList";
    
    NSString* resourcePath = [NSString stringWithFormat:@"/elements/%@/structure",elementKey];
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
    }];
*/
}

/// Stats a Search by its queryID
-(void)performSearchByQuery:(NSInteger)queryID page:(NSInteger)page withSize:(NSInteger)size loaderDelegate:(NSObject<KTLoaderDelegate>*)loaderDelegate{


    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    // Creating Query Parameter
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"byQuery"] = @((int)queryID);
    rpcData[@"page"] = @((int)page);
    rpcData[@"size"] = @((int)size);
    
    [manager getObject:nil path:@"/Searchitsm" parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   NSLog(@"Success");
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Failed");
               }];
    

}

// Searchs for ALL with pagesize 500
-(void)performSearch:(NSString *)searchToken loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{
    [self performSearch:searchToken page:1 withSize:500 withScope:KTScopeAll loaderDelegate:loaderDelegate];
}

-(void)performSearch:(NSString *)searchToken page:(NSInteger)page withSize:(NSInteger)size withScope:(KTSearchScopeType)scope loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate{

    
    RKObjectManager *manager = [RKObjectManager sharedManager];
   
    // Initialize the mapping if not already done
    [KTElement mapping];
    
    // Creating Query Parameter
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"q"] = searchToken;
    rpcData[@"page"] = @((int)page);
    rpcData[@"size"] = @((int)size);
    
    switch (scope) {
        case KTScopeAll:
            rpcData[@"scope"] =@"ALL";
            break;
        case KTScopeDocuments:
            rpcData[@"scope"] = @"Document";
            break;
            
        case KTScopeFolder:
            rpcData[@"scope"] = @"Folder";
            break;
            
        case KTScopeMasteritems:
            rpcData[@"scope"] = @"Item";
            break;
            
        default:
            // No Scope - get all
            break;
    }
    
    [manager getObject:nil path:@"/Searchitems" parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   NSLog(@"Success");
                   [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:@"/Searchitems"];
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Failed");
                   [loaderDelegate requestProceedWithError:nil error:nil];
               }];

}


- (id)init
{
    self = [super init];
    if (self) {
        // Set to a resonably defaultvalue
        self.maximalPageSize = kMaxDefaultPageSize;
        
        manager = [RKObjectManager sharedManager];
    }
    
    return self;
}


@end
