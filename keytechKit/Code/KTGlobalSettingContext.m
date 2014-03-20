//
//  KTGobalSettingContext.m
//  keytechKit
//
//  Created by Thorsten Claus on 05.02.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTGlobalSettingContext.h"

@implementation KTGlobalSettingContext
    static RKObjectMapping *_mapping;
    

+(id)mapping{
    
    if (_mapping==nil){
        RKObjectManager *manager = [RKObjectManager sharedManager];
        
        _mapping = [RKObjectMapping mappingForClass:[KTGlobalSettingContext class]];
        
       [_mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"Contexts" toKeyPath:@"contexts"]];
        
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *contextDescriptor = [RKResponseDescriptor
                                                   responseDescriptorWithMapping:_mapping
                                                   method:RKRequestMethodAny
                                                   pathPattern:@"/globalsettings/contexts" keyPath:nil statusCodes:statusCodes];
       
        [manager addResponseDescriptorsFromArray:@[ contextDescriptor ]];
    

    }
    return _mapping;
}

@end