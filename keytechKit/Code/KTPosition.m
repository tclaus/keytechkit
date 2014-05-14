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
static RKObjectManager *_usedManager;

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTPosition class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"x":@"x",
                                                      @"y":@"y"
                                                       }];
        
        [_usedManager addResponseDescriptor:
        [RKResponseDescriptor responseDescriptorWithMapping:_mapping method:RKRequestMethodAny
                                                pathPattern:nil
                                                    keyPath:@"Position" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
        
        
    }
    
    return _mapping;

}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.x forKey:@"positionX"];
    [aCoder encodeInteger:self.y forKey:@"positionY"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.x  = [coder decodeIntegerForKey:@"positionX"];
        self.y = [coder decodeIntegerForKey:@"positionY"];
    }
    return self;
}


-(NSString*)debugDescription{
    return [NSString stringWithFormat:@"(%ld,%ld)",(long)self.x,(long)self.y];
}

@end



