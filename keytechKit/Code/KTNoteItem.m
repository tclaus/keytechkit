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
+(id)setMapping{
    
    if (!_mapping){
    _mapping = [RKObjectMapping mappingForClass:[KTNoteItem class]];
    
        [_mapping addAttributeMappingsFromDictionary:@{@"NoteID":@"noteID",
                                                       @"NoteType":@"noteType",
                                                       @"NoteText":@"noteText",
                                                       @"NoteSubject":@"noteSubject",
                                                       @"NoteSubject":@"noteSubject",
                                                       @"ChangedAt":@"noteChangedAt",
                                                       @"ChangedBy":@"noteChangedBy",
                                                       @"ChangedByLong":@"noteChangedByLong",
                                                       @"CreatedAt":@"noteCreatedAt",
                                                       @"CreatedBy":@"noteCreatedBy",
                                                       @"CreatedByLong":@"noteCreatedByLong"
                                                       }];
        
    }
    return _mapping;
}

@end



