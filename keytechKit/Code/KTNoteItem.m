//
//  SimpleNoteItem.m
//  keytech search ios
//
//  Created by Thorsten Claus on 17.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import "KTNoteItem.h"
#import <RestKit/RestKit.h>
#import <KTManager.h>


@implementation KTNoteItem

static RKObjectMapping* _mapping;
static RKObjectManager *_usedManager;



- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


/**
 Sets the object mapping
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTNoteItem class]];
        NSDictionary *noteRequestAttributes = @{@"noteID":@"ID",
                                          @"noteType":@"NoteType",
                                          @"noteText":@"Text",
                                          @"noteIndex":@"Index",
                                          @"noteSubject":@"Subject",
                                          };

        NSDictionary *noteResponseAttributes = @{@"ID":@"noteID",
                                                 @"NoteType":@"noteType",
                                                 @"Text":@"noteText",
                                                 @"Index":@"noteIndex",
                                                 @"Subject":@"noteSubject",
                                                 @"ChangedAt":@"noteChangedAt",
                                                 @"ChangedBy":@"noteChangedBy",
                                                 @"ChangedByLong":@"noteChangedByLong",
                                                 @"CreatedAt":@"noteCreatedAt",
                                                 @"CreatedBy":@"noteCreatedBy",
                                                 @"CreatedByLong":@"noteCreatedByLong"
                                                 };

        
        
        [_mapping addAttributeMappingsFromDictionary:noteResponseAttributes];

        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *notesResponseDescriptor = [RKResponseDescriptor
                                                         responseDescriptorWithMapping:_mapping
                                                         method:RKRequestMethodGET
                                                         pathPattern:nil keyPath:@"NotesList" statusCodes:statusCodes];
        
        
        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromDictionary:noteRequestAttributes];
        
        RKRequestDescriptor *notesRequestDescriptor =[RKRequestDescriptor
                                                      requestDescriptorWithMapping: requestMapping
                                                      objectClass:[KTNoteItem class]
                                                      rootKeyPath:nil
                                                      method:RKRequestMethodPOST| RKRequestMethodPUT];
        
        
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTNoteItem class]
                                           pathPattern:@"elements/:targetElementKey/notes"
                                           method:RKRequestMethodPOST]] ;
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTNoteItem class]
                                           pathPattern:@"elements/:targetElementKey/notes/:noteID"
                                           method:RKRequestMethodPUT]] ;
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTNoteItem class]
                                           pathPattern:@"elements/:targetElementKey/notes/:noteID"
                                           method:RKRequestMethodDELETE]] ;
        
        [_usedManager addResponseDescriptor:notesResponseDescriptor];
        [_usedManager addRequestDescriptor:notesRequestDescriptor];
        
    }
    return _mapping;
}

+(instancetype)noteItemForElementKey:(NSString *)elementkey {
    KTNoteItem *newItem = [[KTNoteItem alloc] init];
    newItem.targetElementKey = elementkey;
    
    return newItem;
}


-(void)deleteNote:(void (^)())success failure:(void (^)(KTNoteItem *, NSError *))failure {
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // Make sure a mapping is set
    [KTNoteItem mappingWithManager:manager];
    
    [manager deleteObject:self
                     path:nil
               parameters:nil
                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                      if (success) {
                          success();
                      }

     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         if (failure) {
             NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
             failure(self,transcodedError);
         }
     }];
    
}

-(void)saveNote:(void (^)(KTNoteItem *))success failure:(void (^)(KTNoteItem *, NSError *))failure {
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // Make sure a mapping is set
    [KTNoteItem mappingWithManager:manager];
    
    if (self.noteID ==0 ) {
        
    // Create a new note
    [manager postObject:self
                   path:nil
             parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    NSHTTPURLResponse *response = operation.HTTPRequestOperation.response;

                    NSString *locationString = (NSString*)(response.allHeaderFields)[@"Location"];
                    self.noteID = locationString.integerValue;
                    if (success) {
                        success(self);
                    }
                    
                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                    
                    if (failure) {
                        failure(self,transcodedError);
                    }
                    
                }];
    } else {
        // Update an existing one
        
        [manager putObject:self
                       path:nil
                 parameters:nil
                    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        if (success) {
                            success(self);
                        }
                        
                    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                        
                        if (failure) {
                            failure(self,transcodedError);
                        }
                        
                    }];
        
    }
    
        
}


@end



