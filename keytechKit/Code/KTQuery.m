//
//  KTQuery.m
//  keytechKit
//
//  Created by Thorsten Claus on 22.09.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTQuery.h"
#import "KTSearchengineResult.h"

@implementation KTQuery


-(void)cancelSearches{
    [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET
                                                            matchingPathPattern:@"Search"];
}

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED


-(void)queryByPredicate:(NSPredicate*)predicate inClasses:(NSArray*)inClasses paged:(KTPagedObject*)pagedObject
                  block:(void(^)(NSArray* results))block
                failure:(void(^)(NSError *error))failure{

    [self cancelSearches];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTElement mappingWithManager:manager];
    
    NSString *resourcePath = @"Search";
    
    // Extract query Data
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    NSString *queryString = [predicate predicateKTQueryText];
    NSString *fieldList = [predicate predicateKTFormat];
    NSString *classtypes = [predicate predicateKTClasstypes];
    
    if (queryString) { // server will search this text in more than one attribute at once. Look at the server configuration
        rpcData[@"q"] = queryString;
    }
    
    if (classtypes) { // Return only elements within this classes
        rpcData[@"classtypes"] = classtypes;
    }
    
    if (fieldList) { // Fieldlist. Have a look at the servers documentation
        rpcData[@"fields"] = fieldList;
    }
    
    if (pagedObject) { // A pageObject should not be nil
        rpcData[@"page"] = @((int)pagedObject.page);
        rpcData[@"size"] = @((int)pagedObject.size);
    }

    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   // Dont call Block and delegate
                   if (block) {
                       block(mappingResult.array);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                  
                       if (failure) {
                           failure(error);
                       }

               }];
    
}
#endif

-(void)queryByText:(NSString *)queryText paged:(KTPagedObject *)pagedObject
             block:(void (^)(NSArray *))block
           failure:(void(^)(NSError *error))failure{
    
    [self queryByText:queryText inClasses:nil paged:pagedObject block:block failure:failure];
}

-(void)queryByText:(NSString *)queryText inClasses:(NSArray *)inClasses paged:(KTPagedObject *)pagedObject
             block:(void (^)(NSArray *))block
           failure:(void(^)(NSError *error))failure{
    
    [self cancelSearches];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTElement mappingWithManager:manager];
    
    NSString *resourcePath = @"Search";
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    
    // If QueryText then ??? Exception ?
    
    if (queryText) { // server will search this text in more than one attribute at once. Look at the server configuration
        rpcData[@"q"] = queryText;
    }
    
    if (inClasses) { // Return only elements within this classes
        rpcData[@"classtypes"] = inClasses;
    }
    
    if (pagedObject) {
        rpcData[@"page"] = @((int)pagedObject.page);
        rpcData[@"size"] = @((int)pagedObject.size);
    }
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   // Dont call Block and delegate
                   if (block) {
                       block(mappingResult.array);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {


                       if (failure) {
                           failure(error);
                       }

               }];
    

    
}

/// Starts a Solr Vault query
-(void)queryInVaultsByText:(NSString *)fileContentText
                     paged:(KTPagedObject *)pagedObject
                     block:(void (^)(NSArray *))block
                   failure:(void (^)(NSError *))failure
{
    [self cancelSearches];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTElement mappingWithManager:manager];
    [KTSearchengineResult mappingWithManager:[RKObjectManager sharedManager]];

    NSString *resourcePath = @"Searchengine";
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    
    // If QueryText then ??? Exception ?
    
    if (fileContentText) { // server will search this text in more than one attribute at once. Look at the server configuration
        rpcData[@"q"] = fileContentText;
    }
   
    
    if (pagedObject) {
        rpcData[@"page"] = @((int)pagedObject.page);
        rpcData[@"size"] = @((int)pagedObject.size);
    }
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   // Dont call Block and delegate
                   if (block) {
                       block(mappingResult.array);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {

                   
                   if (failure) {
                       failure(error);
                   }
                   
               }];
    
    
    
}



-(void)queryByStoredSearch:(NSInteger)storedQueryID paged:(KTPagedObject *)pagedObject
                     block:(void (^)(NSArray *))block
                   failure:(void(^)(NSError *error))failure{
/// Stats a Search by its queryID
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
    
    
    // Creating Query Parameter
    
    NSString *resourcePath = @"Search";
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"byQuery"] = @((int)storedQueryID);
    rpcData[@"page"] = @((int)pagedObject.page);
    rpcData[@"size"] = @((int)pagedObject.size);
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   if (block) {
                       block(mappingResult.array);
                   }
                   
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {

                       if (failure) {
                           failure(error);
                       }

               }];
    
}




@end
