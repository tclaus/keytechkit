//
//  KTServerInfo.h
//  keytechKit
//
//  Created by Thorsten Claus on 13.05.14.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

/**
 The keytech serverinfo data is available withoutthe need of a valid user logged in.
 It provides information about the server and keytech version, a unique servce ID and statistical data.
 This class must be used as a singelton class
 */
@interface KTServerInfo : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Returns a shared instace of the server info object.
 */
+(instancetype)sharedServerInfo;

/**
 returns TRUE if serverinfo was fetched
 */
@property (readonly) BOOL isLoaded;
@property (readonly) BOOL isLoading;

/**
 Contains the full key-value list of all server properties.
 */
@property (readonly) NSMutableArray* keyValueList;

/**
 Returns the current API Version from Server
 */
@property (readonly)NSString *databaseVersion;

/**
 Return the API Kernel version from Server
 */
@property (readonly)NSString *APIVersion;

/**
 Returns the baseURL for this Serverinfo
 */
@property (readonly) NSString *baseURL;

/**
 A unique key to identify the current Server
 */
@property (readonly) NSString *serverID;

/**
 Returns YES if web API supports index Server (SOLR server on vaults)
 */
@property (readonly) BOOL isIndexServerEnabled;

/**
 Returns the company String used for license generations
 */
@property (readonly) NSString* licencedCompany;

/**
 Loads the current Serverinfo with globally set ServerURL.
 Waits until server responds.
 */
+(instancetype)serverInfo;

/**
 Loads a serverinfo object.
 @param success Will be called after a successful load of server information
 @param failure Will be called when request returns with an error.
 */
-(void)loadWithSuccess:(void(^)(KTServerInfo* serverInfo))success
               failure:(void(^)(NSError *error))failure;


-(void)waitUnitlLoad;

@end







