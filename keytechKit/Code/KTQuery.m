//
//  KTQuery.m
//  keytechKit
//
//  Created by Thorsten Claus on 22.09.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTQuery.h"
#import "KTSearchengineResult.h"
#import "KTManager.h"


#import "NSPredicate+PredicateKTFormat.h"

@implementation KTQuery


-(void)queryByText:(NSString *)queryText
            reload:(BOOL)shouldReload
             paged:(KTPagedObject *)pagedObject
           success:(void (^)(NSArray *results))success
           failure:(void(^)(NSError *error))failure{
    
    [self queryByText:queryText
               fields:nil
            inClasses:nil
               reload:shouldReload
                paged:pagedObject
              success:success
              failure:failure];
}


-(void)queryByText:(NSString *)queryText
            fields:(NSArray *)fields
         inClasses:(NSArray *)inClasses
            reload:(BOOL)shouldReload
             paged:(KTPagedObject *)pagedObject
           success:(void (^)(NSArray *results))success
           failure:(void (^)(NSError *error))failure {
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTElement mappingWithManager:manager];
    
    NSString *resourcePath = @"Search";
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    
    // If QueryText then ??? Exception ?
    
    if (queryText == nil && fields == nil) {
        NSException *myException = [NSException exceptionWithName:@"Invalid Parameter"
                                                           reason:@"Either querytext or fiels must not be null"
                                                         userInfo:nil];
        @throw myException;
        return;
    }
    
    if (queryText) { // server will search this text in more than one attribute at once. Look at the server configuration
        rpcData[@"q"] = queryText;
    }
    
    if (fields) {
        NSMutableString *fieldList = [[NSMutableString alloc] init];
        for (NSString* aField in fields) {
            [fieldList appendString:[self generateHTMLStringFromString:aField] ];
            [fieldList appendString:@":"];
        }
        
        rpcData[@"fields"] = [fieldList stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] ;
    }
    
    
    if (inClasses) { // Return only elements within this classes
        
        NSMutableString *classList = [[NSMutableString alloc] init];
        for (NSString* aClass in inClasses) {
            [classList appendString:aClass];
            [classList appendString:@","];
        }
        
        rpcData[@"classtypes"] = [classList stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] ;
    }
    
    if (shouldReload) {
        rpcData[@"reload"] = @"true";
    } else {
        rpcData[@"reload"] = @"false";
    }
    
    if (pagedObject) {
        rpcData[@"page"] = @((int)pagedObject.page);
        rpcData[@"size"] = @((int)pagedObject.size);
    }
    
       [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   // Dont call Block and delegate
                   if (success) {
                       success(mappingResult.array);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   
                   NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                   
                   if (failure) {
                       failure(transcodedError);
                   }
                   
               }];
    
    
}



#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED


-(void)queryByPredicate:(NSPredicate*)predicate
              inClasses:(NSArray*)inClasses
                 reload:(BOOL)shouldReload
                  paged:(KTPagedObject*)pagedObject
                success:(void(^)(NSArray* results))success
                failure:(void(^)(NSError *error))failure{
    
 
    
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
    
    if (shouldReload) {
        rpcData[@"reload"] = @"true";
    } else {
        rpcData[@"reload"] = @"false";
    }
    
    if (pagedObject) { // A pageObject should not be nil
        rpcData[@"page"] = @((int)pagedObject.page);
        rpcData[@"size"] = @((int)pagedObject.size);
    }
    
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   // Dont call Block and delegate
                   if (success) {
                       success(mappingResult.array);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   
                   NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                   
                   if (failure) {
                       failure(transcodedError);
                   }
                   
               }];
    
}
#endif

/// Starts a Solr Vault query
-(void)queryInVaultsByText:(NSString *)fileContentText
                    reload:(BOOL)shouldReload
                     paged:(KTPagedObject *)pagedObject
                   success:(void (^)(NSArray *))success
                   failure:(void (^)(NSError *))failure
{
    
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTElement mappingWithManager:manager];
    [KTSearchengineResult mappingWithManager:[RKObjectManager sharedManager]];
    
    NSString *resourcePath = @"Searchengine";
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    
    // If QueryText then ??? Exception ?
    
    if (fileContentText) { // server will search this text in more than one attribute at once. Look at the server configuration
        rpcData[@"q"] = fileContentText;
    }
    
    if (shouldReload) {
        rpcData[@"reload"] = @"true";
    } else {
        rpcData[@"reload"] = @"false";
    }
    
    if (pagedObject) {
        rpcData[@"page"] = @((int)pagedObject.page);
        rpcData[@"size"] = @((int)pagedObject.size);
    }
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   // Dont call Block and delegate
                   if (success) {
                       success(mappingResult.array);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   
                   NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                   
                   if (failure) {
                       failure(transcodedError);
                   }
                   
               }];
    
    
    
}



-(void)queryByStoredSearch:(NSInteger)storedQueryID
                    reload:(BOOL)shouldReload
                     paged:(KTPagedObject *)pagedObject
                   success:(void (^)(NSArray *))success
                   failure:(void(^)(NSError *error))failure{
    
    /// Stats a Search by its queryID
    
    
   
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
    
    
    // Creating Query Parameter
    
    NSString *resourcePath = @"Search";
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"byQuery"] = @((int)storedQueryID);
    
    if (shouldReload) {
        rpcData[@"reload"] = @"true";
    } else {
        rpcData[@"reload"] = @"false";
    }
    
    rpcData[@"page"] = @((int)pagedObject.page);
    rpcData[@"size"] = @((int)pagedObject.size);
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   if (success) {
                       success(mappingResult.array);
                   }
                   
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   // Important: Error handler
                   
                   
                   NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                   
                   if (failure) {
                       failure(transcodedError);
                   }
                   
               }];
    
}

- (NSString *)generateHTMLStringFromString:(NSString*)inString
{
    
    NSMutableString *mutableString = [inString mutableCopy];
    
    [mutableString replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"'"  withString:@"&#x27;" options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    [mutableString replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSLiteralSearch range:NSMakeRange(0, [mutableString length])];
    
    return mutableString;
}


-(void)cancelSearches{
    // TODO: Cancel queries
}

@end






