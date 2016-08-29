//
//  KTStatusItem.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 04.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTStatusItem.h"
#import "KTManager.h"

#import <RestKit/RestKit.h>

@implementation KTStatusItem

static RKObjectMapping* _mapping;
static RKObjectManager *_usedManager;

+(NSInteger)version{
    return 1; // Dev notice: Increment if definition if header changes
}

// Sets the JSON mapping
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTStatusItem class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"ImageName":@"statusImageName",
                                                       @"Restriction":@"statusRestriction",
                                                       @"StatusID":@"statusID"
                                                    }];
        RKResponseDescriptor *statusResponse = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                             method:RKRequestMethodGET
                                        pathPattern:nil keyPath:@"StatusList"
                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

        [_usedManager addResponseDescriptor:statusResponse];
        
        
    }
    
    return _mapping;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.statusImageName forKey:@"statusImageName"];
    [aCoder encodeObject:self.statusRestriction forKey:@"statusRestriction"];
    [aCoder encodeObject:self.statusID forKey:@"statusID"];
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.statusImageName = [aDecoder decodeObjectForKey:@"statusImageName"];
        self.statusRestriction = [aDecoder decodeObjectForKey:@"statusRestriction"];
        self.statusID = [aDecoder decodeObjectForKey:@"statusID"];
        
    }
    return self;
}

+(void)loadStatusListSuccess:(void (^)(NSArray <KTStatusItem*> *))success
                     failure:(void (^)(NSError *))failure{
    
    
    
     RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTStatusItem mappingWithManager:manager];
    
    [manager getObjectsAtPath:@"status" parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          if (success) {
                              success(mappingResult.array);
                          }
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                          
                          if (failure) {
                              failure(transcodedError);
                          }
                      }];
    
    
}

-(NSString*)description{
    return [NSString stringWithFormat:@"\"%@\" with restriction (%@) ",self.statusID, self.statusRestriction];
}

@end
