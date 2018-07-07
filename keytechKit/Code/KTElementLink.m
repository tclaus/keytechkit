//
//  KTElementLink.m
//  keytechKit
//
//  Created by Thorsten Claus on 19.06.14.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTElementLink.h"
#import "KTElement.h"
#import "KTManager.h"

@implementation KTElementLink

static RKObjectMapping* _mapping = nil; /** contains the mapping*/
static RKObjectManager *_usedManager;

/// Stets the object mapping
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager {
    
    if (_usedManager !=manager){
        _usedManager = manager;
        _mapping = [RKObjectMapping mappingForClass:[KTElementLink class]];
        [_mapping addAttributeMappingsFromDictionary:@{
                                                       @"ChildLinkTo":@"childLinkTo"
                                                       }];
        
        [_usedManager addResponseDescriptor:
         [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                      method:RKRequestMethodGET
                                                 pathPattern:nil
                                                     keyPath:@"ElementChildLinks"
                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
        
        [_usedManager addResponseDescriptor:
         [RKResponseDescriptor responseDescriptorWithMapping:[KTElement mappingWithManager:_usedManager]
                                                      method:RKRequestMethodPOST | RKRequestMethodPUT
                                                 pathPattern:nil
                                                     keyPath:nil
                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
        
        
        [_usedManager addRequestDescriptor:
         [RKRequestDescriptor requestDescriptorWithMapping:[_mapping inverseMapping]
                                               objectClass:[KTElementLink class]
                                               rootKeyPath:nil
                                                    method:RKRequestMethodPOST | RKRequestMethodPUT ]];
        
        
        
        // Path Argument
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElementLink class]
                                           pathPattern:@"elements/:parentElementKey/links"
                                           method:RKRequestMethodGET]] ;
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElementLink class]
                                           pathPattern:@"elements/:parentElementKey/links"
                                           method:RKRequestMethodPOST]] ;
        
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElementLink class]
                                           pathPattern:@"elements/:parentElementKey/links/:childLinkTo"
                                           method:RKRequestMethodDELETE]] ;
        
        
    }
    
    return _mapping;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [KTElementLink mappingWithManager:[RKObjectManager sharedManager]];
    }
    return self;
}

-(instancetype)initWithParent:(NSString *)parentElementKey
                     childKey:(NSString *)childKey {
    self =[self init];
    if (self) {
        [KTElementLink mappingWithManager:[RKObjectManager sharedManager]];
        self.childLinkTo = childKey;
        self.parentElementKey = parentElementKey;
    }
    return self;
}

-(void)saveLink:(void (^)(KTElement *childElement))success
        failure:(void (^)(NSError * error))failure {
    [_usedManager postObject:self path:nil parameters:nil
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                         KTElement *addedElement =  mappingResult.firstObject;
                         if (success) {
                             success(addedElement);
                         }
                         
                     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                         
                         NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                         
                         if (failure) {
                             failure(transcodedError);
                         }
                     }];
}

-(void)deleteLink:(void (^)(void))success
          failure:(void (^)(NSError * error))failure {
    
    [_usedManager deleteObject:self path:nil parameters:nil
                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                           if (success) {
                               success();
                           }
                       } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                           NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                           
                           if (failure) {
                               failure(transcodedError);
                           }
                       }];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p> Parent: %@, child: %@", [self class], self, self.childLinkTo, self.parentElementKey];
}

@end



