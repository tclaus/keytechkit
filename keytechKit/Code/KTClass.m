//
//  KTClass.m
//  keytechKit
//
//  Created by Thorsten Claus on 01.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTClass.h"

#import <RestKit/RestKit.h>

@implementation KTClass
static RKObjectMapping *_mapping = nil;

+(NSInteger)version{
    return 2;
}

+(id)mapping{
    
    if (!_mapping){
        
        _mapping = [RKObjectMapping mappingForClass:[KTClass class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"AllowElementCopy":@"classAllowsElementCopy",
                                                       @"ClassKey":@"classKey",
                                                       @"Description":@"classDescription",
                                                       @"Displayname":@"classDisplayname",
                                                       @"HasChangeManagement":@"classHasChangeManagement",
                                                       @"HasVersionControl":@"classHasVersionControl",
                                                       @"IsActive":@"isActive"
                                                       }];
        
        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"AttributesList" toKeyPath:@"classAttributesList" withMapping:[KTClassAttribute mapping]]];
        
        [[RKObjectManager sharedManager] addResponseDescriptor:
         [RKResponseDescriptor responseDescriptorWithMapping:_mapping method:RKRequestMethodAny
                                                 pathPattern:nil
                                                     keyPath:@"ClassConfigurationList"
                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
        
        
    }
    
    return _mapping;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.classVersion = [KTClass version];
    }
    
    return self;
}

-(NSString *)debugDescription{
    return [NSString stringWithFormat:@"%@: %@",self.classKey, self.classDisplayname];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.classVersion = [coder decodeIntegerForKey:@"classVersion"];
        
        self.classAllowsElementCopy = [coder decodeBoolForKey:@"classAllowsElementCopy"];
        self.classKey = [coder decodeObjectForKey:@"classKey"];
        self.classDescription = [coder decodeObjectForKey:@"classDescription"];
        self.classDisplayname = [coder decodeObjectForKey:@"classDisplayName"];
        self.classHasChangeManagement = [coder decodeBoolForKey:@"classHasChangeManagement"];
        self.classHasVersionControl = [coder decodeBoolForKey:@"classHasVersionControl"];
        self.isActive = [coder decodeBoolForKey:@"isActive"];
        self.classAttributesList =[coder decodeObjectForKey:@"classAttributesList"];
        
        
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.classVersion forKey:@"classVersion"];
    
    [aCoder encodeBool:self.classAllowsElementCopy forKey:@"classAllowsElementCopy"];
    [aCoder encodeObject:self.classKey forKey:@"classKey"];
    [aCoder encodeObject:self.classDescription forKey:@"classDescription"];
    [aCoder encodeObject:self.classDisplayname forKey:@"classDisplayName"];
    [aCoder encodeBool:self.classHasVersionControl forKey:@"classHasVersionControl"];
    [aCoder encodeBool:self.classHasChangeManagement forKey:@"classHasChangeManagement"];
    [aCoder encodeBool:self.isActive forKey:@"isActive"];
    [aCoder encodeObject:self.classAttributesList forKey:@"classAttributesList"];
    
}
@end





