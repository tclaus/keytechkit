//
//  KTSize.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTSize.h"
#import <RestKit/RestKit.h>

@implementation KTSize

static RKObjectMapping* _mapping;
static RKObjectManager* _usedManager;

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager {
    
    if (_usedManager !=manager) {
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTSize class]];
        [_mapping addAttributeMappingsFromDictionary:@{
                                                       @"height":@"height",
                                                       @"width":@"width",
                                                       }];
        
        [[RKObjectManager sharedManager] addResponseDescriptor:
         [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                      method:RKRequestMethodAny
                                                 pathPattern:nil
                                                     keyPath:@"Size"
                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    }
    return _mapping;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.height forKey:@"height"];
    [aCoder encodeInteger:self.width forKey:@"width"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.height = [coder decodeIntegerForKey:@"height"];
        self.width = [coder decodeIntegerForKey:@"width"];
    }
    return self;
}

@end



