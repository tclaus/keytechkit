//
//  KTServerInfo.m
//  keytechKit
//
//  Created by Thorsten Claus on 13.05.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTServerInfo.h"
#import "KTKeyValue.h"

@implementation KTServerInfo{

}
    static KTServerInfo *_serverInfo;

@synthesize keyValueList = _keyValueList;

// Mapping for Class
static RKObjectMapping *_mapping;
static RKObjectManager *_usedManager;


// Sets the Object mapping for JSON
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
       
        
        RKObjectMapping *kvMapping = [RKObjectMapping mappingForClass:[KTKeyValue class]];
        [kvMapping addAttributeMappingsFromDictionary:@{@"Key":@"key",
                                                       @"Value":@"value"}];
       
         _mapping = [RKObjectMapping mappingForClass:[self class]];
        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ServerInfoResult" toKeyPath:@"keyValueList" withMapping:kvMapping]];
        /*
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"ServerInfoResult"
                                                    toKeyPath:@"keyValueList"
                                                  withMapping:kvMapping];
        */
        
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *serverInfoDescriptor = [RKResponseDescriptor
                                                      responseDescriptorWithMapping:_mapping
                                                      method:RKRequestMethodAny
                                                      pathPattern:@"serverinfo"
                                                      keyPath:nil
                                                      statusCodes:statusCodes];
        
        
        [_usedManager addResponseDescriptorsFromArray:@[ serverInfoDescriptor ]];
        
        
    }
    
    return _mapping;
}


-(id)valueForKey:(NSString *)key{
    
    for (KTKeyValue *kv in self.keyValueList) {
        if ([kv.key isEqualToString:key]) {
            return kv.value;
        }
    }
    return nil;
}

+(instancetype)serverInfo{
    if (!_serverInfo) {
        _serverInfo = [[KTServerInfo alloc]init];
        [_serverInfo reload];
    }
    return _serverInfo;
}

-(NSString *)ServerID{
    return [self valueForKey:@"ServerID"];
}

-(NSString *)APIKernelVersion{
    return [self valueForKey:@"keytech version"];
}

-(NSString *)APIVersion{
    return [self valueForKey:@"API version"];
}

-(void)reload{
    // TBD;
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTServerInfo mappingWithManager:manager];
    
    [manager getObject:self path:@"serverinfo" parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

                KTServerInfo *serverInfo = mappingResult.firstObject;

               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error while getting the API version: %@",error.localizedDescription);
                  
               }];

}

@end
