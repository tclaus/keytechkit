//
//  KTPermission.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTPermission : NSObject

/**
 Sets the mapping
 */
+(id)setMapping;

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
