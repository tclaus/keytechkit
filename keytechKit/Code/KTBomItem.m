//
//  KTBomItem.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 19.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTBomItem.h"
#import "KTKeyValue.h"
#import "KTElement.h"
#import <RestKit/RestKit.h>


@implementation KTBomItem{
    // Make a dictionary-Helper
    NSMutableDictionary* keyValues;

}
// Mapping for Class
static RKObjectMapping* _mapping;

@synthesize keyValueList = _keyValueList;
@synthesize element = _element;

-(id)getValueByKey:(NSString*)key{

    if (!self.keyValueList)
        return @"";
    
    if (!keyValues){
        keyValues = [[NSMutableDictionary alloc]init];
        
        for (KTKeyValue* keyValue in self.keyValueList){
            
            // Test to dateValue
            NSDate* dateValue =[keyValue valueAsDate] ;
            
            if (dateValue !=nil){
                
                [keyValues setValue:dateValue forKey:[keyValue key]];
                continue;
            }
            
            
            
            [keyValues setValue:[keyValue value] forKey:[keyValue key]];
        }
    }
    // Important: keep dictiony synchron with Data
    return [keyValues objectForKey:key];
    
}


// Sets the Object mapping for JSON
+(id)mapping{
    
    if (_mapping==nil){
        _mapping = [RKObjectMapping mappingForClass:[self class]];

        RKRelationshipMapping *simpleElemenRelationship =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"SimpleElement"
                                                    toKeyPath:@"element" withMapping:[KTElement mapping]];
        
        RKRelationshipMapping *keyValueMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"KeyValueList"
                                                    toKeyPath:@"keyValueList" withMapping:[KTKeyValue mapping]];

        
        [_mapping addPropertyMapping:simpleElemenRelationship];
        [_mapping addPropertyMapping:keyValueMapping];
        
    }
    
    return _mapping;
}





-(NSString *)description{
    // Wird hier zu früh abgeholt
    return [NSString stringWithFormat:@"MI Name = %@",[self getValueByKey:@"as_mi__name"]];
}

@end
