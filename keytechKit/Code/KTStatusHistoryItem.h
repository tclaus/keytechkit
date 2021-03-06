//
//  KTStatusHistoryItem.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 14.01.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTSignedBy.h"

/**
 Provides an item of Status change. Who and When signed the element.
 */
@interface KTStatusHistoryItem : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

@property (copy) NSString* historyDescription;
@property (copy) NSString* historySourceStatus;
@property (copy) NSString* historyTargetStatus;
@property (copy) NSArray* historySignedBy; // vom Typ ktsignedBy

/**
 List of accounts who has signed the last status change. In case ob multisign.
 */
@property (readonly) NSString* signedByList;

/**
 Date of least signed. Only least signed date marks the fullfilment of signung the status change.
 */
@property (readonly) NSDate* lastSignedAt;

@end
