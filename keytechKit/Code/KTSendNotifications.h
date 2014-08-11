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
 Identifies the unique ServerID. Only clients connected to this ServerID will receive the message
 */
@property (nonatomic,copy) NSString* serverID;



/**
 Registers a deviceID to the APN
 */
-(void)registerDevice:(NSData*)deviceToken uniqueID:(NSString*)uniqueID;

/**
 Registers a deviceID to the APN with the given two character language ID
 */
-(void)registerDevice:(NSData*)deviceToken uniqueID:(NSString*)uniqueID languageID:(NSString*)languageID;



-(void)sendElementHasBeenChanged:(KTElement*)element;
-(void)sendElementHasBeenDeleted:(KTElement *)element;
-(void)sendElementFileUploaded:(NSString *)elementKey;
-(void)sendElementFileHasBeenRemoved:(NSString *)elementKey;
// More to be come

+(instancetype)sharedSendNotification;

@property (nonatomic) BOOL connectionSucceeded;
@property (nonatomic) BOOL connectionFinished;

@end
