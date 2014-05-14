//
//  KTStatusItem.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 04.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTStatusItem.h"
#import <RestKit/RestKit.h>

@implementation KTStatusItem

static RKObjectMapping* _mapping;
static RKObjectManager *_usedManager;


// Sets the JSON mapping
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTStatusItem class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"ImageName":@"imageName",
                                                       @"Restriction":@"restriction",
                                                       @"StatusID":@"statusID"
                                                    }];
        RKResponseDescriptor *statusResponse = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                             method:RKRequestMethodAny
                                        pathPattern:nil keyPath:@"StatusList"
                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

        [_usedManager addResponseDescriptor:statusResponse];
    }
    
    return _mapping;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.restriction forKey:@"restriction"];
    [aCoder encodeObject:self.statusID forKey:@"statusID"];
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
        self.restriction = [aDecoder decodeObjectForKey:@"restriction"];
        self.statusID = [aDecoder decodeObjectForKey:@"statusID"];
        
    }
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"\"%@\" with restriction (%@) ",self.statusID, self.restriction];
}

@end
