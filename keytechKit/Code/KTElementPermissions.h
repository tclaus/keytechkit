//
//  KTElementPermissions.h
//  Pods
//
//  Created by Thorsten Claus on 23.07.15.
//
//

#import <Foundation/Foundation.h>
#import <KTElementPermissionList.h>

@interface KTElementPermissions : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

@property (nonatomic) NSString *elementKey;

/**
 If given, the link permissions between the elementKey and childelement will be returned.
 Can be null
 */
@property (nonatomic) NSString *childElementKey;
@property (nonatomic) NSString *userKey;
@property (nonatomic) KTElementPermissionList *permissions;

/**
 Loads the current elementPerimssion for this moment in time.
 @param elementKey The elementKey to get the permissions from.
 @param childElementKey If not nil, the link poermission between elementKey and this childelememt is returned.
 */
+(void)loadWithElementKey:(NSString*)elementKey
          childElementkey:(NSString*)childElementKey
                  success:(void (^)(KTElementPermissions *elementPermission))success
                  failure:(void (^)( NSError *error))failure;
/**
 Loads the current elementPerimssion for this moment in time. 
 @param elementKey The elementKey to get the permissions from.
 */
+(void)loadWithElementKey:(NSString*)elementKey
                  success:(void (^)(KTElementPermissions *elementPermission))success
                  failure:(void (^)( NSError *error))failure;

@end
