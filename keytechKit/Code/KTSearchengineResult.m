//
//  KTSearchengineResult.m
//  keytechKit
//
//  Created by Thorsten Claus on 06.11.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTSearchengineResult.h"
#import <RestKit/RestKit.h>
#import "KTManager.h"

static RKObjectManager *_usedManager;
static RKObjectMapping *_mapping;
@implementation KTSearchengineResult

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    if (_usedManager !=manager) {
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTSearchengineResult class]];
        
        [_mapping addAttributeMappingsFromDictionary:@{@"SolrIndexID":@"solrIndexID"}];
        
        
        
        
        RKResponseDescriptor *results = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:nil
                                                                                   keyPath:@"SearchResults"
                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Element"
                                                                                       toKeyPath:@"element"
                                                                                     withMapping:[KTElement mappingWithManager:[RKObjectManager sharedManager]]]];

        
        [_usedManager addResponseDescriptor:results];
        
        
    }
    return _mapping;
}

-(void)getSolrData{
    [[RKObjectManager sharedManager]
     getObjectsAtPath:@"/searchengine"
     parameters:@{@"q": @"keytech"}
     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"OK");
         
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

@end






