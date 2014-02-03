//
//  SimpleFavorite.m
//  keytech search ios
//
//  Created by Thorsten Claus on 19.11.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import "KTSimpleFavorite.h"

@implementation KTSimpleFavorite

static RKObjectMapping* _mapping = nil;

-(NSString*) ItemClassKey{
    NSArray *components=[self.elementKey componentsSeparatedByString:@":"];
    
    if(components.count>=2)
        return [NSString stringWithFormat:@"%@",components[0]];
    
    return self.elementKey;
}

-(NSString*) ItemClassType{
    
    if ([self.ItemClassKey rangeOfString:@"_MI"].location !=NSNotFound) return @"MI";
    if ([self.ItemClassKey rangeOfString:@"_FD"].location !=NSNotFound) return @"FD";
    if ([self.ItemClassKey rangeOfString:@"_WF"].location !=NSNotFound) return @"FD";
    
    return @"DO";
    
}

/// Sets the mapping
+(RKObjectMapping*)mapping{
    if (!_mapping){
    _mapping = [RKObjectMapping mappingForClass:[KTSimpleFavorite class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"ParentFolderID":@"parentFolderID",
                                                       @"FolderName":@"folderName",
                                                       @"ElementKey":@"elementKey",
                                                       @"IsFolder":@"isFolder",
                                                       @"FolderID":@"isFolder"
                                                       }];
        
        RKRelationshipMapping *elementRelationship =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"Element"
                                                    toKeyPath:@"Element"
                                                  withMapping:[KTElement mapping]];

        [_mapping addPropertyMapping:elementRelationship];
    }

    return _mapping;
}

@end
