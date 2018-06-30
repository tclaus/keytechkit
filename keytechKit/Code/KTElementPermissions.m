//
//  KTElementPermissions.m
//  Pods
//
//  Created by Thorsten Claus on 23.07.15.
//
//

#import "KTElementPermissions.h"
#import "KTManager.h"

@implementation KTElementPermissions
static RKObjectMapping* _mapping;
static RKObjectManager *_usedManager;

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager {
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTElementPermissions class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"ElementKey":@"elementKey"
                                                       }];
        
        RKObjectMapping *permissionMapping = [RKObjectMapping mappingForClass:[KTElementPermissionList class]];
        [permissionMapping addAttributeMappingsFromDictionary:@{@"AllowShowElement":@"allowShowElement",
                                                                @"AlloModifyElement":@"allowModifyElement",
                                                                @"AllowDeleteElement":@"allowDeleteElement",
                                                                @"AllowLinkElement":@"allowLinkElement",
                                                                @"AllowChangeStatus":@"allowChangeStatus",
                                                                @"AllowReserveElement":@"allowReserveElement",
                                                                @"AllowUnreserveElement":@"allowUnreserveElement",
                                                                @"AllowCreateLink":@"allowCreateLink",
                                                                @"AllowDeleteLink":@"allowDeleteLink"
                                                                }];
        // Map the permissionlist to this object
        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Permissions"
                                                                                 toKeyPath:@"permissions"
                                                                               withMapping:permissionMapping]];
        
        
        
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                    responseDescriptorWithMapping:_mapping
                                                    method:RKRequestMethodGET
                                                    pathPattern:@"user/:userKey/permissions/element/:elementKey"
                                                    keyPath:nil
                                                    statusCodes:statusCodes];
        
        
        [manager addResponseDescriptor:responseDescriptor];
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElementPermissions class]
                                           pathPattern:@"user/:userKey/permissions/element/:elementKey"
                                           method:RKRequestMethodGET]] ;
        
        
    }
    return _mapping;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.userKey = @"jgrant";
    }
    return self;
}

+(void)loadWithElementKey:(NSString *)elementKey
                  success:(void (^)(KTElementPermissions *))success
                  failure:(void (^)(NSError *))failure {
    
    [KTElementPermissions loadWithElementKey:elementKey
                             childElementkey:nil
                                     success:success
                                     failure:failure];
}


+(void)loadWithElementKey:(NSString *)elementKey
          childElementkey:(NSString *)childElementKey
                  success:(void (^)(KTElementPermissions *))success
                  failure:(void (^)(NSError *))failure {
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTElementPermissions mappingWithManager:manager];
    
    KTElementPermissions *thePermission = [[KTElementPermissions alloc]init];
    thePermission.elementKey = elementKey;
    
    NSDictionary *parameters;
    if (childElementKey) {
        parameters = @{@"childElementKey":childElementKey};
    }
    
    [manager getObject:thePermission
                  path:nil
            parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                if (success) {
                    KTElementPermissions *elementPermission = (KTElementPermissions*)mappingResult.firstObject;
                    
                    success(elementPermission);
                }
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                if (failure) {
                    NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                    failure(transcodedError);
                }
            }];
    
}

@end
