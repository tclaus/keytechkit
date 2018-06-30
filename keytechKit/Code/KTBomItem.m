//
//  KTBomItem.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 19.07.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTBomItem.h"
#import "KTKeyValue.h"
#import <RestKit/RestKit.h>

@implementation KTBomItem{
    // Make a dictionary-Helper
    NSMutableDictionary* keyValues;
    
}

// Mapping for Class
static RKObjectMapping* _mapping;
static RKObjectManager *_usedManager;

@synthesize keyValueList = _keyValueList;
@synthesize element = _element;

// Sets the Object mapping for JSON
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager {
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[self class]];
        
        RKRelationshipMapping *simpleElemenRelationship =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"Element"
                                                    toKeyPath:@"element" withMapping:[KTElement mappingWithManager:[RKObjectManager sharedManager]] ];
        
        RKRelationshipMapping *keyValueMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"KeyValueList"
                                                    toKeyPath:@"keyValueList" withMapping:[KTKeyValue mappingWithManager:manager]];
        
        
        [_mapping addPropertyMapping:simpleElemenRelationship];
        [_mapping addPropertyMapping:keyValueMapping];
        
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *bomElementDescriptor = [RKResponseDescriptor
                                                      responseDescriptorWithMapping:_mapping
                                                      method:RKRequestMethodAny
                                                      pathPattern:nil keyPath:@"BomElementList" statusCodes:statusCodes];
        
        [_usedManager addResponseDescriptorsFromArray:@[ bomElementDescriptor ]];
    }
    
    return _mapping;
}

-(id)valueForKey:(NSString *)key {
    
    if (!self.keyValueList)
        return @"";
    
    if (!keyValues){
        keyValues = [[NSMutableDictionary alloc]init];
        
        for (KTKeyValue* keyValue in self.keyValueList){
            
            // Test to dateValue
            NSDate* dateValue =[keyValue valueAsDate] ;
            
            if (dateValue !=nil){
                
                [keyValues setValue:dateValue forKey:keyValue.key];
                continue;
            }
            
            [keyValues setValue:keyValue.value forKey:keyValue.key];
        }
    }
    
    // Important: keep dictiony synchron with Data
    return keyValues[key];
}

-(NSString *)description {
    // Wird hier zu früh abgeholt
    return [NSString stringWithFormat:@"MI Name = %@",[self valueForKey:@"as_mi__name"]];
}

@end
