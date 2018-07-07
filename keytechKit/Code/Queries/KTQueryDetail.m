//
//  KTQueryDetails.m
//  keytechkit
//
//  Created by Thorsten Claus on 03.07.18.
//

#import <RestKit/RestKit.h>
#import "KTQueryDetail.h"
#import "KTManager.h"
#import "KTUser.h"

NS_ASSUME_NONNULL_BEGIN
@implementation KTQueryDetail

static RKObjectManager *_usedManager;
static RKObjectMapping *_mapping;

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*) manager {
    
    NSString *pathPattern = @"user/:userKey/queries/:queryID";
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass: [KTQueryDetail class]];
        // JSON Prefix entfällt
        [_mapping addAttributeMappingsFromDictionary:@{@"ID":@"queryID",
                                                       @"Key": @"key",
                                                       @"DisplayName" :@"displayName",
                                                       @"QueryParamTypes" :@"queryParamTypes"
                                                       }];
        
        RKObjectMapping *parameterList = [RKObjectMapping mappingForClass: KTQueryParameter.class];
        [parameterList addAttributeMappingsFromDictionary:@{@"AttributeName":@"attributeName",
                                                            @"AttributeType":@"attributeType",
                                                            @"AttributeText":@"attributeText",
                                                            @"Message":@"message",
                                                            @"OperatorType":@"operatorType",
                                                            @"OperatorLocalizedText":@"operatorLocalizedText",
                                                            @"OperatorConcatLocalizedText":@"operatorConcatLocalizedText",
                                                            @"OriginalValues":@"originalValues"
                                                            }];
        // Map the query paramaters to this object
        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ParameterList"
                                                                                 toKeyPath:@"parameterList"
                                                                               withMapping:parameterList]];
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                    responseDescriptorWithMapping:_mapping
                                                    method:RKRequestMethodGET
                                                    pathPattern: pathPattern // Path must be set, for mapping without KVO. See https://github.com/RestKit/RestKit/wiki/Object-mapping#mapping-without-kvc
                                                    keyPath: nil // This resource has no keyPath!
                                                    statusCodes:statusCodes];
        
        [manager addResponseDescriptor:responseDescriptor];
        
        // Dont add to router - give
        // Check tests if using path
         [manager.router.routeSet addRoute:[RKRoute
         routeWithClass: KTQueryDetail.class
         pathPattern: pathPattern
         method:RKRequestMethodGET]] ;
        
    }
    return _mapping;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(void)loadQueryDetailsUserKey:(NSString*) userKey
                       queryID:(int) queryID
                       success:(void (^)(KTQueryDetail*))success
                       failure:(void (^)(NSError *))failure {
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTQueryDetail mappingWithManager:manager];
    
    
    NSString* queryPath = [NSString stringWithFormat:@"user/%@/queries/%d",userKey,queryID];
    
    [manager getObjectsAtPath:queryPath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          if (success) {
                              KTQueryDetail *queryDetail =  (KTQueryDetail*) mappingResult.firstObject;
                              success(queryDetail);
                          }
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          if (failure) {
                              NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                              failure(transcodedError);
                          }
                      }];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p> ID: %d, '%@'", [self class], self, self.queryID, self.displayName];
}

@end
NS_ASSUME_NONNULL_END



