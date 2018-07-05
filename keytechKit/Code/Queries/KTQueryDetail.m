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


@implementation KTQueryDetail

static RKObjectManager *_usedManager;

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*) manager {
    
    NSString *pathPattern = @"user/:userKey/queries/:queryID";
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass: KTQueryDetail.class];
        // JSON Prefix entfällt
        [mapping addAttributeMappingsFromDictionary:@{@"ID":@"queryID",
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
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ParameterList"
                                                                                 toKeyPath:@"parameterList"
                                                                               withMapping:parameterList]];
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                    responseDescriptorWithMapping:mapping
                                                    method:RKRequestMethodGET
                                                    pathPattern:nil
                                                    keyPath:nil
                                                    statusCodes:statusCodes];
        
        [manager addResponseDescriptor:responseDescriptor];
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass: KTQueryDetail.class
                                           pathPattern: pathPattern
                                           method:RKRequestMethodGET]] ;
        
        
    }
    return nil;
}

-(instancetype)initWithUser:(NSString *)userKey queryID:(int)queryID {
    self = [super init];
    if (self) {
        _userKey = userKey;
        _queryID = queryID;
    }
    return self;
}

+(void)loadQueryDetailsUserKey:(NSString*) userKey
                        queryID:(int) queryID
                       success:(void (^)(KTQueryDetail*))success
                       failure:(void (^)(NSError *))failure {
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTQueryDetail mappingWithManager:manager];
    KTQueryDetail *queryDetail = [[KTQueryDetail alloc] initWithUser: userKey queryID: queryID];
    
    
    [manager getObject:queryDetail
                  path:nil
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
@end




