//
//  KTQuery.h
//  keytechKit
//
//  Created by Thorsten Claus on 22.09.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//
// Provides search functions
#import <Foundation/Foundation.h>
#import "KTPagedObject.h"
#import "KTElement.h"

@interface KTQuery : NSObject

/**
 Cancels any searches that are currently running
 */
-(void)cancelSearches;

/**
 Starts a query with th given text
 @param queryText One or more word to search for.
*/
-(void)queryByText:(NSString*)queryText paged:(KTPagedObject*)pagedObject
             block:(void(^)(NSArray* results))block
           failure:(void(^)(NSError *error))failure;

/**
 Starts a query with th given text
 @param queryText One or more word to search for.
 @param inClasses A string list of classkeys. Result is only returned for the speified classes. If this parameter is nil all classes are searched
 */
-(void)queryByText:(NSString*)queryText inClasses:(NSArray*)inClasses paged:(KTPagedObject*)pagedObject
             block:(void(^)(NSArray* results))block
           failure:(void(^)(NSError *error))failure;

/// Most powerful search
-(void)queryByPredicate:(NSPredicate*)predicate inClasses:(NSArray*)inClasses paged:(KTPagedObject*)pagedObject
                  block:(void(^)(NSArray* results))block
                failure:(void(^)(NSError *error))failure;


/**
 Starts a query by a server stored query by its ID
 */
-(void)queryByStoredSearch:(NSInteger)storedQueryID paged:(KTPagedObject*)pagedObject
                     block:(void(^)(NSArray* results))block
                   failure:(void(^)(NSError *error))failure;

/**
 Starts a query in vaults (Solr search in Vaults)
 @param fileContentText: A text fragment to be searched in files
 */
-(void)queryInVaultsByText:(NSString *)fileContentText paged:(KTPagedObject*)pagedObject
                     block:(void(^)(NSArray* results))block
                   failure:(void(^)(NSError *error))failure;

@end
