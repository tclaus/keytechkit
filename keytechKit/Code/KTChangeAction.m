//
//  KTChangeAction.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 11.08.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTChangeAction.h"
#import "RestKit/Restkit.h"

@implementation KTChangeAction{
    
    NSString* _classStringList;
    NSString* _sourceStatusStringList;
    NSString* _targetStatusStringList;
    
}
static RKObjectMapping* _mapping;

@synthesize actionName = _actionName;
@synthesize classList = _classList;
@synthesize descriptionText = _descriptionText;
@synthesize isActive = _isActive;
@synthesize parameter = _parameter;
@synthesize sourceStatusList = _sourceStatusList;
@synthesize targetStatusList = _targetStausList;


/// Converts the pipe divided String List to an mutable Array
-(void)setClassStringList:(NSString *)classList{
    _classStringList = classList;
    
    NSString* smallList =  [classList stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"|"]];
     _classList =  [NSMutableArray arrayWithArray:[smallList  componentsSeparatedByString:@"|"]];
    
}

/// Converts the pipe divided String List to an mutable Array
-(void)setSourceStatusStringList:(NSString *)sourceStatusList{
    
    _sourceStatusStringList = sourceStatusList;
    
    NSString* smallList =  [sourceStatusList stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"|"]];
    _sourceStatusList =  [NSMutableArray arrayWithArray:[smallList componentsSeparatedByString:@"|"]];
}

/// Converts the pipe divided String List to an mutable Array
//        targetStatusStringList
-(void)setTargetStatusStringList:(NSString *)targetStausList{
    _targetStatusStringList = targetStausList;
    
    NSString* smallList =  [targetStausList stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"|"]];
    _targetStausList =  [NSMutableArray arrayWithArray:[smallList componentsSeparatedByString:@"|"]];
    
}


+(id)mapping{
        
        if (_mapping==nil){
            
            _mapping = [RKObjectMapping requestMapping];
            [_mapping addAttributeMappingsFromDictionary:@{@"ActionName": @"actionName",
                                                          @"ClassList":@"classStringList",
                                                          @"Description":@"descriptionText",
                                                          @"Parameter":@"parameter",
                                                          @"SourceStatus":@"sourceStatusStringList",
                                                          @"TargetStatus":@"targetStatusStringList"
                                                           }];
            
            
            
            
        }
        
        return _mapping;
    }



-(NSString*)description{
    return [NSString stringWithFormat:@"%@ : %@",self.actionName, self.descriptionText];
}

@end
