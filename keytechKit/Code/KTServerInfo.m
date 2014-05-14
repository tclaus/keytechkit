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

@synthesize keyValueList = _keyValueList;

// Mapping for Class
static RKObjectMapping* _mapping;
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

-(NSString *)APIKernelVersion{
    return [self valueForKey:@"keytech version"];
}

-(NSString *)APIVersion{
    return [self valueForKey:@"API version"];
}


@end
