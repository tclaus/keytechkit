//
//  KTAttributeMapping.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 18.10.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTAttributeMapping.h"
#import "Restkit/restkit.h"

@implementation KTAttributeMapping
static RKObjectMapping* _mapping;

+(id)setMapping{
    if (!_mapping) {
        
        _mapping = [RKObjectMapping mappingForClass:[KTAttributeMapping class]];
        [_mapping addAttributeMappingsFromDictionary:@{
                                                       @"ClassKey":@"classKey",
                                                       @"Comment":@"comment",
                                                       @"ID":@"internalID",
                                                       @"Order":@"order",
                                                       @"SourceAttribute":@"sourceValue",
                                                       @"TargetAttribute":@"targetAttribute",
                                                       @"Status":@"status",
                                                       @"TypeName":@"typeName"
                                                       }];
        
    }
    return _mapping;
}
/// Provides user friendly debugger output
-(NSString *)debugDescription{
    return [NSString stringWithFormat:@"In Class %@ map: %@ -> %@",self.classKey, self.sourceValue,self.targetAttribute];
}

@end
