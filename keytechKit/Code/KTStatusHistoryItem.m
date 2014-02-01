//
//  KTStatusHistoryItem.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 14.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTStatusHistoryItem.h"
#import <RestKit/RestKit.h>

@implementation KTStatusHistoryItem
    static RKObjectMapping* _mapping = nil;



// Setzt das Mapping
+(id)setMapping{
    
    if (!_mapping){
        
        _mapping = [RKObjectMapping mappingForClass:[KTStatusHistoryItem class]];
        [_mapping addAttributeMappingsFromDictionary:@{
                                                       @"Description":@"historyDescription",
                                                       @"SourceStatus":@"historySourceStatus",
                                                       @"TargetStatus":@"historyTargetStatus"
                                                    }];

        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"SignedByList" toKeyPath:@"historySignedBy" withMapping:[KTSignedBy setMapping]]];
        
    }
    
    return _mapping;
}

/*
 Konstruiert eine Liste von Benutzern, die den Statuswechsel unterschrieren haben
 */
-(NSString*)signedByList{
    NSString* _usersList;
    _usersList = [[self.historySignedBy valueForKey:@"signedByLong"] componentsJoinedByString:@" "];
    return  _usersList;
}

-(NSDate*)lastSignedAt{
    KTSignedBy* signedBy = [self.historySignedBy lastObject];
    return  signedBy.signedAt;
    
}

/*
 Debugger Output
 */
-(NSString *)description{
    return [NSString stringWithFormat:@"From: %@ To: %@",self.historySourceStatus,self.historyTargetStatus];
}

@end
