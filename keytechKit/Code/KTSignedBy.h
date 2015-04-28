//
//  KTSignedBy.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 14.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

/**
 A sign is a authorization sign that allows a element-status change. 
 Multiple signs can be nessesary before a status change can be made.
 */
@interface KTSignedBy : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Long username og who did sign a status change
 */
@property (copy) NSString* signedByLong;
/**
 Short (key) username of who did sign
 */
@property (copy) NSString* signedBy;
/**
 Date of sign.
 */
@property (copy) NSDate* signedAt;

@end
