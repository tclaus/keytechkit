//
//  SimpleNoteItem.m
//  keytech search ios
//
//  Created by Thorsten Claus on 17.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import "KTNoteItem.h"
#import <RestKit/RestKit.h>

@implementation KTNoteItem

 static RKObjectMapping* _mapping;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


/**
 Sets the object mapping
 */
+(id)mapping{
    
    if (!_mapping){
    _mapping = [RKObjectMapping mappingForClass:[KTNoteItem class]];
    
        [_mapping addAttributeMappingsFromDictionary:@{@"ID":@"noteID",
                                                       @"NoteType":@"noteType",
                                                       @"Text":@"noteText",
                                                       @"Subject":@"noteSubject",
                                                       @"ChangedAt":@"noteChangedAt",
                                                       @"ChangedBy":@"noteChangedBy",
                                                       @"ChangedByLong":@"noteChangedByLong",
                                                       @"CreatedAt":@"noteCreatedAt",
                                                       @"CreatedBy":@"noteCreatedBy",
                                                       @"CreatedByLong":@"noteCreatedByLong"
                                                    }];
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *elementDescriptor = [RKResponseDescriptor
                                                   responseDescriptorWithMapping:_mapping
                                                   method:RKRequestMethodAny
                                                   pathPattern:nil keyPath:@"NotesList" statusCodes:statusCodes];

        [[RKObjectManager sharedManager] addResponseDescriptor:elementDescriptor];
        
    }
    return _mapping;
}

@end



