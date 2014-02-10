//
//  KTPosition.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTPosition.h"
#import <RestKit/RestKit.h>

@implementation KTPosition

static RKObjectMapping *_mapping = nil;

+(id)mapping{
    
    if (!_mapping){
    
        _mapping = [RKObjectMapping mappingForClass:[KTPosition class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"x":@"x",
                                                      @"y":@"y"
                                                       }];
        
        [[RKObjectManager sharedManager] addResponseDescriptor:
        [RKResponseDescriptor responseDescriptorWithMapping:_mapping method:RKRequestMethodAny
                                                pathPattern:nil
                                                    keyPath:@"Position" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
        
        
    }
    
    return _mapping;

}

-(NSString*)description{
    return [NSString stringWithFormat:@"(%ld,%ld)",(long)self.x,(long)self.y];
}

@end
