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


+(id)mapping{
    
    if (!_mapping) {
     
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

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.height forKey:@"height"];
    [aCoder encodeInteger:self.width forKey:@"width"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.height = [coder decodeIntegerForKey:@"height"];
        self.width = [coder decodeIntegerForKey:@"width"];
    }
    return self;
}


@end



