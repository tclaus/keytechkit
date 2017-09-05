//
//  KTPermission.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTPermission.h"
#import <RestKit/RestKit.h>

@implementation KTPermission

static RKObjectMapping* _mapping = nil; /** contains the mapping*/
static RKObjectManager *_usedManager;


+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    if (_usedManager !=manager){
        _usedManager = manager;
        
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
        
        [_usedManager addResponseDescriptor:permissionResponse];
    }
    
    
    return _mapping;
    
}

@end
