//
//  KTStatusItem.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 04.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//
// Povides Information about documents - status definitions.
//
#import <Foundation/Foundation.h>

/**
 Represents a single statusitem. every keytech element miust have a status even no 'statusmanagement' is definied for the element Class. In this Case a element has a staus of value '------' (6 x minus sign).
  The statusID property may not be localized on server side.
 */
@interface KTStatusItem : NSObject <NSCoding>

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 The name of an image which represents this status. The image is windows client specific
 */
@property (nonatomic,copy) NSString* statusImageName;

/**
 Gets or sets the restriction of this status. Restrictions affects the access rights of elements.
 Restrictions are any of this key words: None, Readonly, Release, Archive.
 Every restriction results to different behavior in editing or changing element data.
 */
@property (nonatomic,copy) NSString* statusRestriction;

/**
 The name of the status. Used as a localized (urg..) key in keytech API. These names are key in elements and should never change in a running environment.
 */
@property (nonatomic,copy)NSString* statusID;

/**
 Loads the full list of available status from this API installation
 @param success Will excecute after list is loaded
 @param failure In any case of an error failure will be called.
 */
+(void)loadStatusListSuccess:(void (^)(NSArray *statusList))success failure:(void(^)(NSError *error))failure;

@end



