//
//  KTTargetLink.m
//  keytech search ios
//
//  Created by Thorsten Claus on 19.11.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//
//  Stellt einen Link zwischen Elementen dar. 

#import "KTTargetLink.h"

@implementation KTTargetLink

static RKObjectMapping* _mapping = nil; /** contains the mapping*/
static RKObjectManager *_usedManager;

/// Stets the object mapping
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager {
    
    if (_usedManager !=manager){
        _usedManager = manager;
        _mapping = [RKObjectMapping mappingForClass:[KTTargetLink class]];
        [_mapping addAttributeMappingsFromDictionary:@{
                                                       @"ParentID":@"parentID",
                                                       @"EntryName":@"entryName",
                                                       @"TargetElementKey":@"targetElementKey",
                                                       @"LinkID":@"linkID"
                                                       }];
        
        [_usedManager addResponseDescriptor:
         [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                      method:RKRequestMethodAny
                                                 pathPattern:nil
                                                     keyPath:@"TargetLinks"
                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    }
    return _mapping;
}

-(NSString*) itemClassKey {
    NSArray *components=[self.targetElementKey componentsSeparatedByString:@":"];
    
    if(components.count>=2)
        return [NSString stringWithFormat:@"%@",components[0]];
    
    return self.targetElementKey;
}

-(NSString*) itemClassType {
    
    if ([self.itemClassKey rangeOfString:@"_MI"].location !=NSNotFound) return @"MI";
    if ([self.itemClassKey rangeOfString:@"_FD"].location !=NSNotFound) return @"FD";
    if ([self.itemClassKey rangeOfString:@"_WF"].location !=NSNotFound) return @"FD";
    
    return @"DO";
}

-(void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    
    // für leere Keys ein "nil" erzwingen
    if ([key isEqualToString:@"targetElementKey"]){
        if ([value length]==0){
            [super setValue:nil forKey:key];
        }
    }
}

/**
 Helps debugging output
 */
-(NSString*)debugDescription {
    return [NSString stringWithFormat:@"%@, %@",self.entryName,self.targetElementKey];
}
-(NSString *)description {
    return [self debugDescription];
}

@end




