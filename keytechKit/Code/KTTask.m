//
//  KTTask.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 25.07.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTTask.h"
#import <RestKit/RestKit.h>

@implementation KTTask

static RKObjectMapping *_mapping;
static RKObjectManager *_usedManager;


// Sets the JSON mapping
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        //TODO: Make the mappings
  
    }
    
    return _mapping;
}
@end
