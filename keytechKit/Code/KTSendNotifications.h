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
 The keytech user login that will receive the notification
 */
@property (nonatomic,copy) NSString* userID;


-(void)sendElementHasBeenChanged:(KTElement*)element;
-(void)sendElementHasBeenDeleted:(KTElement *)element;
-(void)sendElementFileUploaded:(NSString *)elementKey;
-(void)sendElementFileHasBeenRemoved:(NSString *)elementKey;
// More to be come

+(instancetype)sharedSendNotification;

@property (nonatomic) BOOL connectionSucceeded;
@property (nonatomic) BOOL connectionFinished;

@end
