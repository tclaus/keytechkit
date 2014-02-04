//
//  KTGlobalSetting.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.08.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTGlobalSetting.h"
#import "Restkit/restkit.h"

@implementation KTGlobalSetting{

    
}


static RKObjectMapping* _mapping;

+(id)mapping{
    if (!_mapping) {
        
        _mapping = [RKObjectMapping requestMapping];
        [_mapping addAttributeMappingsFromDictionary:@{@"Account":@"settingAccount",
                                                      @"Name":@"settingName",
                                                      @"Context":@"settingContext",
                                                      @"Description":@"settingDescription",
                                                      @"Value":@"settingValue"
                                                       }];
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        
        [[RKObjectManager sharedManager] addResponseDescriptor:
        [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                     method:RKRequestMethodAny
                                                pathPattern:nil keyPath:@"GlobalsettingList"
                                                statusCodes:statusCodes]];


        
    }
    return _mapping;
}

/// Returns a list of assignes members
-(NSMutableArray*)settingAccountList{
        NSMutableArray *accountsList = [[NSMutableArray alloc]init];
        [accountsList addObjectsFromArray:[self.settingAccount componentsSeparatedByString:@"|"]];
    
    // Kein Caching von fixen Objekten in diesem Framework. Nicht in dieser Ebene!
    
    return accountsList;
}

@end
