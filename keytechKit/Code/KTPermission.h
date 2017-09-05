//
//  KTPermission.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 A class that has a single permission information
 */
@interface KTPermission : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Returns or sets the user visible displayname
 */
@property (nonatomic,copy)NSString* displayname;

/**
 Returns or gets the scope for this permission.
 */
@property (nonatomic,copy)NSString* permissionContext;

/**
 The unique identifier
 */
@property (nonatomic,copy)NSString* permissionKey;

/**
 The permissiontype is the kind of right this permission represents
 */
@property (nonatomic,copy)NSString* permissionType;

/**
 If YES the permission is not directly assigend to the user but assigned by group membership.
 In case this permission is assign to a group this value has no meaning.
 */
@property (nonatomic) BOOL isPermissionSetByMembership;



@end
