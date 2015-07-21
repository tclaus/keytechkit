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
#import <KTLicenseData.h>

@implementation KTNoteItem

static RKObjectMapping* _mapping;
static RKObjectManager *_usedManager;



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
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
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
        RKResponseDescriptor *notesResponseDescriptor = [RKResponseDescriptor
                                                         responseDescriptorWithMapping:_mapping
                                                         method:RKRequestMethodGET
                                                         pathPattern:nil keyPath:@"NotesList" statusCodes:statusCodes];
        
        RKRequestDescriptor *notesRequestDescriptor =[RKRequestDescriptor
                                                      requestDescriptorWithMapping:_mapping
                                                      objectClass:[KTNoteItem class]
                                                      rootKeyPath:nil method:RKRequestMethodPOST| RKRequestMethodPUT];
        
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTNoteItem class]
                                           pathPattern:@"elements/:elementkey/notes"
                                           method:RKRequestMethodPOST]] ;
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTNoteItem class]
                                           pathPattern:@"elements/:elementkey/notes/:noteID"
                                           method:RKRequestMethodPUT]] ;
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTNoteItem class]
                                           pathPattern:@"elements/:elementkey/notes/:noteID"
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

-(void)deleteNote{
    if (![KTLicenseData sharedLicenseData].isValidLicense) {
        NSError *error = [KTLicenseData sharedLicenseData].licenseError;
       
        return;
    }
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // Make sure a mapping is set
    [KTNoteItem mappingWithManager:manager];
    
    [manager deleteObject:self
     path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         //
         NSLog(@"Note soccessfully deleted");
     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         //
         NSLog(@"Delete of a note failed");
     }];
    
}

-(void)saveNote:(void (^)(KTNoteItem *))success failure:(void (^)(KTNoteItem *, NSError *))failure {
    if (![KTLicenseData sharedLicenseData].isValidLicense) {
        NSError *error = [KTLicenseData sharedLicenseData].licenseError;
        if (failure) {
            failure(self,error);
        }
        return;
    }
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // Make sure a mapping is set
    [KTNoteItem mappingWithManager:manager];
    
    if (self.noteID ==0 ) {
        
    // Create a new note
    [manager postObject:self
                   path:nil
             parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                    self.noteID = (int)[response.allHeaderFields objectForKey:@"Location"];
                    if (success) {
                        success(self);
                    }
                    
                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response];
                    
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
                        NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                        self.noteID = (int)[response.allHeaderFields objectForKey:@"Location"];
                        if (success) {
                            success(self);
                        }
                        
                    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response];
                        
                        if (failure) {
                            failure(self,transcodedError);
                        }
                        
                    }];
        
    }
    
        
}


@end



