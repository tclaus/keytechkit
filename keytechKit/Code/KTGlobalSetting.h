//
//  KTGlobalSetting.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.08.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTGlobalSetting : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 A short user or groupname (key) can also be 'none' for not in use or 'ALL' for globally valid.
 */
@property (nonatomic, copy)NSString* settingAccount;

/**
 Returns a array of user or group IDs.
 */
@property (readonly,assign) NSMutableArray *settingAccountList;

/**
 Represents a scope for this setting. However setting names must be unique in combination with an account.
 A context does not need to limit validity only in a given scope.
 */
@property (nonatomic,copy) NSString* settingContext;

/**
 A human readable, localized description of this setting.
 */
@property (nonatomic,copy) NSString* settingDescription;
/**
 The unique name of a setting. The same setting can be assigned to multiple accounts with different or sane values.
 */
@property (nonatomic,copy) NSString *settingName;

/**
 The value. Can representation of numbers, strings, boolean (true/false) or (0/1) switches, compiled settingnames divided by pipes. e.g.: 
 "|as_gs__name|as_gs__description". 
 
 You will have to parse the value for your needs.
 
 */
@property (nonatomic,copy) NSString* settingValue;


@end
