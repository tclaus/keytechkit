//
//  KTSystemManagement.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 31.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTSystemManagement.h"
#import "KTGlobalSetting.h"
#import "KTStatusItem.h"
#import "KTChangeAction.h"
#import "KTAttributeMapping.h"


@implementation KTSystemManagement


#pragma mark GlobalSettings

/// Requests effective user relevant Globalsettings if username is set
// Requests a list of usersetting if username is nil
-(void)performGetGlobalSetting:(NSString *)settingName forUser:(NSString *)username loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    /*
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    RKObjectMapping* itemMapping = [KTGlobalSetting setMapping];

    
    NSString* resourcePath;
    
    if (username) {
        resourcePath= [NSString stringWithFormat:@"/user/%@/globalsettings/%@",username,settingName];
    } else {
        // USername was nil - request list of settings
        resourcePath= [NSString stringWithFormat:@"/globalsettings/%@",settingName];
    }
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
    }];
     */
}

// Performs a search
-(void)performGetGlobalSettingsBySearchString:(NSString *)searchText returnFullResults:(BOOL)fullResults loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    

    // Creating Query Parameter
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"q"] = searchText;
    rpcData[@"FullResults"] = @((int)fullResults);
    
    [manager getObject:nil path:@"/globalsettings" parameters:rpcData
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   NSLog(@"Success");
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Failed");
               }];
    
    
}


-(void)performGetGlobalSettingContexts:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    NSString* resourcePath = @"/globalsettings/contexts";
    
    [manager getObject:nil path:resourcePath parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    NSLog(@"Success");
                   [loaderDelegate requestDidProceed:mappingResult.array fromResourcePath:@""];
                   
                  
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Failed");
               }];
}

// All Settings by its given contextname
-(void)performGetGlobalSettingsByContext:(NSString *)contextName loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    
    
    
    // ResourcePath zusammenbauen
    NSString* resourcePath = [NSString stringWithFormat:@"/globalsettings/contexts/%@",contextName];

/*
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
    }];
  */
}


#pragma mark Status

-(void)performGetAvailableStatusList:(NSObject<KTLoaderDelegate> *)loaderDelegate{
    /*
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKObjectMapping* itemMapping = [KTStatusItem setMapping];
    
    itemMapping.rootKeyPath = @"StatusList";
    
    NSString* resourcePath = @"/status";
    
    [manager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.objectMapping = itemMapping;
        loader.delegate = self;
        loader.targetObject = nil;
    }];
     */
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



