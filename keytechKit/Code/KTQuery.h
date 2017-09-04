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




/**
 Starts a Query to the API by using the search ressouces.
 A simple search can only have a text value or a complex assembled search query on a predicates base.
 */
@interface KTQuery : NSObject


/**
 Starts a query with th given text
 @param queryText One or more word to search for.
 @param pagedObject The requested page and its size
 @param shouldReload Set to True if a server side reload will be forced.
 @param success A block that will execute after search is completed
 @param failure A block that will be exectue in case of a failure. The Error object will have a descriptive text of the cause of the error when possible
 */
-(void)queryByText:(NSString*)queryText
            reload:(BOOL)shouldReload
             paged:(KTPagedObject*)pagedObject
           success:(void(^)(NSArray<KTElement*> * results))success
           failure:(void(^)(NSError *error))failure;



/**
 Starts a query with querytext, and / or fields. One must be not null or both can have a value.
 @param queryText One or more word to search for. can be null if fields parameter has a value
 @param fields A list of fields with query parametrers. one entry must have the form <field>[=,<>,!=,>,<,like]<Value>. field can have a short or the long form: created_by=jgrant oder as_do__created_by = jgrant
 @param inClasses An array of classkeys. The result will only contain elements of this kind of classes.
 @param pagedObject The requested page and its size
 @param shouldReload Set to True if a server side reload will be forced.
 @param success A block that will execute after search is completed
 @param failure A block that will be exectue in case of a failure. The Error object will have a descriptive text of the cause of the error when possible
 */
-(void)queryByText:(NSString*)queryText
            fields:(NSArray*)fields
         inClasses:(NSArray*)inClasses
            reload:(BOOL)shouldReload
             paged:(KTPagedObject*)pagedObject
           success:(void(^)(NSArray <KTElement*> * results))success
           failure:(void(^)(NSError *error))failure;



#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

/**
 Starts a powerful search by using composed search predicates
 @param predicate A complex predicate to execute the query.
 @param inClasses A string list of classkeys. Result is only returned for the speified classes. If this parameter is nil all classes are searched
 @param pagedObject The requested page and its size
 @param shouldReload Set to True if a server side reload will be forced.
 @param success A block that will execute after search is completed
 @param failure A block that will be exectue in case of a failure. The Error object will have a descriptive text of the cause of the error when possible
 */
-(void)queryByPredicate:(NSPredicate*)predicate
              inClasses:(NSArray*)inClasses
                 reload:(BOOL)shouldReload
                  paged:(KTPagedObject*)pagedObject
                success:(void(^)(NSArray <KTElement*> * results))success
                failure:(void(^)(NSError *error))failure;

#endif

/**
 Starts a query by a server stored query by its ID
 @param storedQueryID The nummeric ID of a server side stored query
 @param shouldReload Set to True if a server side reload will be forced.
 @param pagedObject The requested page and its size
 @param success A block that will execute after search is completed
 @param failure A block that will be exectue in case of a failure. The Error object will have a descriptive text of the cause of the error when possible
 */
-(void)queryByStoredSearch:(NSInteger)storedQueryID
                    reload:(BOOL)shouldReload
                     paged:(KTPagedObject*)pagedObject
                   success:(void(^)(NSArray <KTElement*> * results))success
                   failure:(void(^)(NSError *error))failure;

/**
 Starts a query in vaults (Solr search in Vaults) when enabled on server side.
 @param fileContentText A text fragment to be searched in files
 @param shouldReload Set to True if a server side reload will be forced.
 @param pagedObject The requested page and its size
 @param success A block that will execute after search is completed
 @param failure A block that will be exectue in case of a failure. The Error object will have a descriptive text of the cause of the error when possible
 */
-(void)queryInVaultsByText:(NSString *)fileContentText
                    reload:(BOOL)shouldReload
                     paged:(KTPagedObject*)pagedObject
                   success:(void(^)(NSArray <KTElement*>* results))success
                   failure:(void(^)(NSError *error))failure;

/**
 Cancels all pending queries and invalides the result
 */
-(void)cancelSearches;

@end





