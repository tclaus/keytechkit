//
//  KTSendNotifications.h
//  keytechKit
//
//  Created by Thorsten Claus on 06.08.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTElement.h"

@interface KTSendNotifications : NSObject <NSURLConnectionDataDelegate>

/**
 Identifies the unique ServerID. Only clients connected to this ServerID will receive the message. You can get the serverID by asking the KTServerInfo object.
 */
@property (nonatomic,copy) NSString* serverID;



/**
 Registers a deviceID to the APN. Register a device in the AppDelegates didRegisterForRemoteNotificationsWithDeviceToken function. The language used is the preferredLanguage of the device. Dont cache the deviceToken.
 @param deviceToken The devicetoken as provided in the (NSData *)deviceToken parameter of the didRegisterForRemoteNotificationsWithDeviceToken selector.
 @param uniqueID A Unique ID to identify the device. Not the bundleID. On iOS and OSX devices you can set it by
    [NSUUID UUID].uuidString;
 */
-(void)registerDevice:(NSData*)deviceToken uniqueID:(NSString*)uniqueID;

/**
 Registers a deviceID to the APN with the given languageID. Register a device in the AppDelegates didRegisterForRemoteNotificationsWithDeviceToken function. Dont cache the deviceToken.
 @param deviceToken The devicetoken as provided in the (NSData *)deviceToken parameter of the didRegisterForRemoteNotificationsWithDeviceToken selector.
 @param uniqueID A Unique ID to identify the device. Not the bundleID. On iOS and OSX devices you can set it by
 [NSUUID UUID].uuidString;
 @param languageID The language ID is the 2 character iso language identifier. If nil the english language will be used for notifications.
 */
-(void)registerDevice:(NSData*)deviceToken uniqueID:(NSString*)uniqueID languageID:(NSString*)languageID;



-(void)sendElementHasBeenChanged:(KTElement*)element;
-(void)sendElementHasBeenDeleted:(KTElement *)element;
-(void)sendElementFileUploaded:(NSString *)elementKey;
-(void)sendElementFileHasBeenRemoved:(NSString *)elementKey;
-(void)sendElementHasNewChildLink:(NSString *)elementKey addedtoFolder:( NSString*)folderName;
-(void)sendElementChildLinkRemoved:(NSString*)elementKey removedFromFolder:(NSString*)folderName;

// More to be come

+(instancetype)sharedSendNotification;

@property (nonatomic) BOOL connectionSucceeded;
@property (nonatomic) BOOL connectionFinished;

@end
