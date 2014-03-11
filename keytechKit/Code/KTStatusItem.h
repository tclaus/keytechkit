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


@interface KTStatusItem : NSObject <NSCoding>

/**
 Sets the object mapping for this class
 */
+(id)mapping;

/**
 The name of an image which represents this status
 */
@property (nonatomic,copy) NSString* imageName;
/**
 Gets or sets the restriction of this status. Restrictions affects the access rights of elements.
 Restrictions are any of this key words: None, Readonly, RELEASE, Archive.
 Every restriction results to different behavior in editing or changing element data.
 */
@property (nonatomic,copy) NSString* restriction;

/**
 The name of the status. Used as a localized (urg..) key in keytech API.
 */
@property (nonatomic,copy)NSString* statusID;

@end
