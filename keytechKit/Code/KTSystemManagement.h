//
//  KTSystemManagement.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 31.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//
// Provides system management functionalities.
// Rarely used settings or adminsistrative settings and services

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "KTKeytechLoader.h"


@interface KTSystemManagement : NSObject

#pragma mark GlobalSettings
/**
 Gets the effective setting for the user
 @param settingname: Unique name for a setting
 @param forUser: The requested user. The first relevant setting valid for the user will be reuturned. (Effective setting)  If nil all setting with @see settingName are returned.
 You can only requests your own settings unless you user credentials has admin rights
 */
-(void)performGetGlobalSetting:(NSString*)settingName forUser:(NSString*)username loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Loads all globalsettings for a specific context
 @param contextName A group name in which setting can be organized. Can be a list of contextnames separated by spaces
 @param loaderDelegate The class which is responsible for processing results
 */
-(void)performGetGlobalSettingsByContext:(NSString *)contextName loaderDelegate:(NSObject<KTLoaderDelegate> *)loaderDelegate;

/**
 Returns a list of settings by a part of its name. Will only return a represntal of the setting. Accountname and Value will be blanked.
 @param searchText A part of a settings name.
 @param withFullResults If YES settings for all useraccounts with the same name will be returned. The results are longer and full account nd value properties are filled out.
 @param searchDelegate The delegate who will process the request.
 */
-(void)performGetGlobalSettingsBySearchString:(NSString*)seachText returnFullResults:(BOOL)fullResults loaderDelegate:(NSObject<KTLoaderDelegate>*) loaderDelegate;

/**
 Returns a list of all valid contexts.
 Each setting has a scope it is valid for. These are named by contexts. However a settingname must globally be unique. 
 Only different name and accounts are valid.
 
 Will return a simplified Settingslist with only context property filled.
 */
-(void)performGetGlobalSettingContexts:(NSObject<KTLoaderDelegate> *)loaderDelegate;

#pragma mark Classlist
/**
 Returns a full Classlist with its attributes
 */
-(void)performGetClasslist:(NSObject <KTLoaderDelegate>*) loaderDelegate;

/**
 Returns a specific class identified by classkey
 */
-(void)performGetClass:(NSString*)classKey loaderDelegate:(NSObject <KTLoaderDelegate>*) loaderDelegate;


#pragma mark Status
/**
 Gets the statuslist with it definition
 */
-(void)performGetAvailableStatusList:(NSObject<KTLoaderDelegate> *)loaderDelegate;

/**
 Gets the list of actions performed after a status changes
 */
-(void)performGetStatusChangeActionList:(NSObject<KTLoaderDelegate> *)loaderDelegate;


#pragma mark AttributeMapping
/**
 Gets the list of attribute mappings. 
 */
-(void)performGetAttributeMappings:(NSObject<KTLoaderDelegate>*)loaderDelegate;


@end






