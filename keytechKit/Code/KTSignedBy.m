//
//  KTSignedBy.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 14.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTSignedBy.h"
#import <RestKit/RestKit.h>

@implementation KTSignedBy

static RKObjectMapping* _mapping = nil;
static RKObjectManager *_usedManager;

/// Stets the object mapping
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTSignedBy class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"SignedByLong":@"signedByLong",
                                                       @"SignedBy":@"signedBy",
                                                       @"SignedAt":@"signedAt"}];
        
    }
    return _mapping;

}

@end
