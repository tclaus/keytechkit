//
//  KTNoteType.m
//  Pods
//
//  Created by Thorsten Claus on 22.07.15.
//
//

#import "KTNoteType.h"
#import "KTManager.h"

@implementation KTNoteType
static RKObjectMapping* _mapping;
static RKObjectManager *_usedManager;

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTNoteType class]];
    
        
        NSDictionary *noteTypeResponseAttributes = @{@"ID":@"noteTypeID",
                                                 @"AllowModify":@"allowModify",
                                                 @"PostItType":@"isPostItType",
                                                 @"Displaytext":@"displaytext",
                                                 @"IsFolderInfo":@"isFolderInfo",
                                                 @"IsMasteritemInfo":@"isMasteritemInfo",
                                                 @"IsDocumentInfo":@"isDocumentInfo",
                                                 @"IsSystemInfo":@"isSystemInfo",
                                                 @"ShouldCopyOnElementCopy":@"shouldCopyOnElementCopy",
                                                 @"ShouldCopyOnNewVersion":@"shouldCopyOnNewVersion"
                                                 };
        
        
        
        [_mapping addAttributeMappingsFromDictionary:noteTypeResponseAttributes];
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *notesResponseDescriptor = [RKResponseDescriptor
                                                         responseDescriptorWithMapping:_mapping
                                                         method:RKRequestMethodGET
                                                         pathPattern:@"notetypes" keyPath:@"Notetypes" statusCodes:statusCodes];
        
        
        
        [_usedManager addResponseDescriptor:notesResponseDescriptor];

        
    }
    return _mapping;
}

+(void)loadNoteTypesSuccess:(void (^)(NSArray *noteTypes))success failure:(void (^)(NSError *error))failure{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // Make sure a mapping is set
    [KTNoteType mappingWithManager:manager];
    
    [manager getObjectsAtPath:@"notetypes" parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          if (success) {
                              NSArray* noteTypes = mappingResult.array;
                              success(noteTypes);
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          
                          if (failure) {
                               NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                              failure(transcodedError);
                          }
                          
                      }];
    
}


-(NSString *)description{
    return self.displaytext;
}

@end
