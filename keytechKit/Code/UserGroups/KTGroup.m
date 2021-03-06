//
//  KTUser.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTGroup.h"
#import "KTNotifications.h"
#import <RestKit/RestKit.h>

@implementation KTGroup{
@private
    BOOL _isUserListLoaded;
    BOOL _isUserListLoading;
    
}

static KTGroup *_groupAll;
static KTGroup *_groupNone;

@synthesize usersList = _usersList;

static RKObjectMapping* _mapping = nil; /** contains the mapping*/
static RKObjectManager *_usedManager;

- (instancetype)init {
    self = [super init];
    if (self) {
        _usersList = [[NSMutableArray alloc]init];
    }
    
    return self;
}

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager {
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping requestMapping];
        [_mapping addAttributeMappingsFromDictionary:@{
                                                       @"KeyName":@"groupKey",
                                                       @"LongName":@"groupLongName"
                                                       }];
        
        [_usedManager addRequestDescriptor:
         [RKRequestDescriptor requestDescriptorWithMapping:_mapping objectClass:[KTGroup class] rootKeyPath:@"MembersList" method:RKRequestMethodAny]];
        
    }
    
    return _mapping;
}

//Lazy loads a userlist
-(NSMutableArray*)usersList {
    if (_isUserListLoaded &!_isUserListLoading) {
        return _usersList;
    } else {
        _isUserListLoading = YES;
        //TODO: Load the userlist (Not implemented in API)
        return _usersList;
    }
}

/// Returns the uniue Group name. (included the grp_ prefixx)
-(NSString*)identifier {
    return _groupKey;
}

+(KTGroup*)groupAll {
    if(!_groupAll){
        _groupAll = [[KTGroup alloc]init];
        _groupAll.groupKey = @"ALL";
        _groupAll.groupLongName = NSLocalizedString(@"ALL Groups",@"ALL Groups, placeholder for 'everyone'");
        
    }
    return _groupAll;
}

+(KTGroup*)groupNone {
    if(!_groupNone){
        _groupNone = [[KTGroup alloc]init];
        _groupNone.groupKey = @"NONE";
        _groupNone.groupLongName = NSLocalizedString(@"None",@"No Groups, placeholder for 'nobody'");
        
    }
    return _groupNone;
}

@end
