//
//  KTSize.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTSize.h"
#import <RestKit/RestKit.h>

static RKObjectMapping* _mapping;
@implementation KTSize


+(id)setMapping{
    
    if (!_mapping) {
     
    _mapping = [RKObjectMapping mappingForClass:[KTSize class]];
        [_mapping addAttributeMappingsFromDictionary:@{
                                                       @"height":@"height",
                                                       @"width":@"width",
                                                       }];
    
    }
    
    return _mapping;
    
}

@end
