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
static RKObjectManager *_usedManager;

-(NSString*) ItemClassKey {
    NSArray *components=[self.elementKey componentsSeparatedByString:@":"];
    
    if(components.count>=2)
        return [NSString stringWithFormat:@"%@",components[0]];
    
    return self.elementKey;
}

-(NSString*) ItemClassType {
    
    if ([self.ItemClassKey rangeOfString:@"_MI"].location !=NSNotFound) return @"MI";
    if ([self.ItemClassKey rangeOfString:@"_FD"].location !=NSNotFound) return @"FD";
    if ([self.ItemClassKey rangeOfString:@"_WF"].location !=NSNotFound) return @"FD";
    
    return @"DO";
}

/// Sets the mapping
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager {

    if (_usedManager !=manager){
        _usedManager = manager;
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
                                                  withMapping:[KTElement mappingWithManager:[RKObjectManager sharedManager]]];

        [_mapping addPropertyMapping:elementRelationship];
        // TODO: Add To Manager;
    }

    return _mapping;
}

@end
