//
//  KTQueryDetails.h
//  keytechkit
//
//  Created by Thorsten Claus on 03.07.18.
//

#import <Foundation/Foundation.h>
#import "KTElement.h"
#import "KTQueryParameter.h"

/**
 Represents a details object under /user/<username>/queries/<queryID>
 */
@interface KTQueryDetail : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*) manager;

-(instancetype)initWithUser:(NSString*)userKey queryID:(int)queryID;

/**
 Returns a single query detail for currentUser
 @param success A block to execute after query is loaded
 @para, failure A block to execute after loading failed
 */
+(void)loadQueryDetailsUserKey:(NSString*) userKey
                     queryID:(int) queryID
                    success:(void (^)(KTQueryDetail* ktQueryDetails)) success
                    failure:(void (^)(NSError *error)) failure;

@property (nonatomic) int queryID;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *queryParamTypes;
@property (nonatomic) NSArray <KTQueryParameter*> *parameterList;

@end
