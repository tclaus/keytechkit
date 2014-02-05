//
//  KTPermission.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTPermission.h"
#import <RestKit/RestKit.h>

@implementation KTPermission
static RKObjectMapping* _mapping = nil; /** contains the mapping*/



+(id)mapping{
    if (!_mapping){
        _mapping = [RKObjectMapping mappingForClass:[KTPermission class]];
        
        [_mapping addAttributeMappingsFromDictionary:@{@"DisplayName":@"displayname",
                                                      @"PermissionContext":@"permissionContext",
                                                      @"PermissionKey":@"permissionKey",
                                                      @"PermissionType":@"permissionType",
                                                      @"AssignedByMembership":@"isPermissionSetByMembership"
                                                    }];
        RKResponseDescriptor *permissionResponse =
        [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                     method:RKRequestMethodAny
                                                pathPattern:nil
                                                    keyPath:@"PermissionList"
                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        [[RKObjectManager sharedManager] addResponseDescriptor:permissionResponse];
    }
    
    
    return _mapping;
    
}

@end
