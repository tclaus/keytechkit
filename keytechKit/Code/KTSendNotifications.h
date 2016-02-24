//
//  KTSendNotifications.h
//  keytechKit
//
//  Created by Thorsten Claus on 06.08.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTElement.h"
@class KTUser;

/**
 Push notification manager
 Dont use this directly
 
 Sends push notifications when element changes occure. EG sends a 'Element XY has been changed by user Z' to user who own (created) the element.
 
 To use the Push Service: 
 1. Start an account on POushWoosh
 2. Enter the API Token, by setting an the environment "APNToken" to the API Token
 
 */
@interface KTSendNotifications : NSObject <NSURLConnectionDataDelegate>

/**
 Identifies the unique keytech ServerID. Only clients connected to this ServerID will receive the message. You can get the serverID by asking the KTServerInfo object.
 */
@property (nonatomic,copy) NSString* serverID;

/**
 Set to the PushWoosh API Token
 */
@property (nonatomic,copy) NSString* APNAPIToken;
/**
 Define the APN Application ID, provided by the Push Wosh Service
 */
@property (nonatomic, copy) NSString* APNApplictionID;

/**
 Set a freetext to define the App Type - for exampe you can set this to "release", "debug" or whatever you like to specify this app. 
 Will be a hint on some debug messages only
 */
@property (nonatomic,copy)NSString* AppType;

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

/*
 Notifies about an opend push
 */
-(void)sendPushOpend:(NSString*)pushHashValue;


/**
 Sends a message with informs the receiver about an changed element.
 @param element The element object that has been changed
 */
-(void)sendElementHasBeenChanged:(KTElement*)element;

/**
 Sends a message with informs the receiver about a deletd element.
 @param element The element object that has been deleted.
 */
-(void)sendElementHasBeenDeleted:(KTElement *)element;

/**
 Sends a message with informs the receiver about an element that has received a new file.
 @param elementKey The elementKey of the element that has received a file.
 */
-(void)sendElementFileUploaded:(NSString *)elementKey;

/**
 Sends a message that informs the receiver that a masterfile has been removed
 @param elementKey The elementKey of the element
 @description A masterfile is the main file of a document
 */
-(void)sendElementMasterFileHasBeenRemoved:(NSString *)elementKey;

/**
 Sends a message that informs the receiver about an element that has a deleted file. (A non master file).
 @param elementKey The elementKey of the element.
 */
-(void)sendElementFileHasBeenRemoved:(NSString *)elementKey;

/**
 Sends a message that informs the receiver that an element has been linked to a folder.
 @param elementKey The elementKey that has been linked to a folder
 @param folderName The name of the parent folder
 */
-(void)sendElementHasNewChildLink:(NSString *)elementKey addedtoFolder:( NSString*)folderName;

/**
 Sends a message with informs the receiver that an element has been unlinked from a folder.
 @param elementKey The elementKey that has been unlinked from a folder
 @param folderName The name of the parent folder
 */
-(void)sendElementChildLinkRemoved:(NSString*)elementKey removedFromFolder:(NSString*)folderName;

/**
 Returns a shared instance of KTSendNotification
 */
+(instancetype)sharedSendNotification;

@property (nonatomic) BOOL connectionSucceeded;
@property (nonatomic) BOOL connectionFinished;

@end
