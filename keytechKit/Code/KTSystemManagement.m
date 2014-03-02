//
//  KTSystemManagement.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 31.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTSystemManagement.h"
#import "KTBaseObject.h"
#import "KTGlobalSetting.h"
#import "KTStatusItem.h"
#import "KTChangeAction.h"
#import "KTAttributeMapping.h"
#import "KTGlobalSettingContext.h"
#import "KTClass.h"

@implementation KTSystemManagement

#pragma mark Classlist
-(void)performGetClass:(NSString *)classKey loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTClass mapping];
    
    classKey = [KTBaseObject normalizeElementKey:classKey];
    
    NSString *resourcePath = [NSString stringWithFormat:@"classes/%@",classKey];
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[[KTLoaderInfo alloc]init] error:error];
                      }];
    
    
    
}

-(void)performGetClasslist:(NSObject<KTLoaderDelegate> *)loaderDelegate{
     RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTClass mapping];
    NSString *resourcePath = @"classes";
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[[KTLoaderInfo alloc]init] error:error];
                      }];

    
}

#pragma mark GlobalSettings

/// Requests effective user relevant Globalsettings if username is set
// Requests a list of usersetting if username is nil
-(void)performGetGlobalSetting:(NSString *)settingName forUser:(NSString *)username loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTGlobalSetting mapping];

    NSString* resourcePath;
    
    if (username) {
        resourcePath= [NSString stringWithFormat:@"user/%@/globalsettings/%@",username,settingName];
    } else {
        // Username was nil - request list of settings
        resourcePath= [NSString stringWithFormat:@"globalsettings/%@",settingName];
    }
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[[KTLoaderInfo alloc]init] error:error];
                      }];
    
}

// Performs a search
-(void)performGetGlobalSettingsBySearchString:(NSString *)searchText returnFullResults:(BOOL)fullResults loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTGlobalSetting mapping];
    
    // Creating Query Parameter
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"q"] = searchText;
    rpcData[@"FullResults"] = @((int)fullResults);
    
    NSString* resourcePath =@"globalsettings";
    
    [manager getObject:nil path:resourcePath parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   [loaderDelegate requestProceedWithError:[[KTLoaderInfo alloc]init] error:error];
               }];
    
    
}

/// Gets a full list of available global setting contexts
-(void)performGetGlobalSettingContexts:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTGlobalSettingContext mapping];
    
    NSString* resourcePath = @"globalsettings/contexts";
    
    [manager getObject:nil path:resourcePath parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                   
                  
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   [loaderDelegate requestProceedWithError:[[KTLoaderInfo alloc] initWithResourcePath:resourcePath] error:error];
                   
               }];
}

// All Settings by its given contextname
-(void)performGetGlobalSettingsByContext:(NSString *)contextName loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTGlobalSetting mapping];
    
    // ResourcePath zusammenbauen
    NSString* resourcePath = [NSString stringWithFormat:@"globalsettings/contexts/%@",contextName];

    [manager getObjectsAtPath:resourcePath parameters:nil
                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                      [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      
                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                      [loaderDelegate requestProceedWithError:[KTLoaderInfo ktLoaderInfo] error:error];
                  }];
}


#pragma mark Status

-(void)performGetAvailableStatusList:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [KTStatusItem mapping];
    
    NSString* resourcePath = @"status";
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:resourcePath];
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          [loaderDelegate requestProceedWithError:[KTLoaderInfo ktLoaderInfo] error:error];
                      }];
    
    
}

/// Gets the list of actions performed by a status change
-(void)performGetStatusChangeActionList:(NSObject<KTLoaderDelegate> *)loaderDelegate{
   /*
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTChangeAction setMapping];
    
    itemMapping.rootKeyPath = @"StatusChangeActions";
    
    NSString* resourcePath = @"/status/changeactions";
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
    }];
    */
}

#pragma mark AttributeMappings
/// Performs a GET of a full list of attribute mappings
-(void)performGetAttributeMappings:(NSObject<KTLoaderDelegate>*)loaderDelegate{
    /*
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTAttributeMapping setMapping];
    
    itemMapping.rootKeyPath = @"AttributeMappingsList";
    
    NSString* resourcePath = @"/attributemappings";
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
    }];
     */
}





@end



