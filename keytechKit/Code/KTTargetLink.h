//
//  SimpleFavorite.h
//  keytech search ios
//
//  Created by Thorsten Claus on 19.11.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//
// A KTTargetLink provides a Link in user Bins. These are Links to Mails, Tasks, Favorites, stored queries.
// To manage links between elements (aka structure links) you must use the KTElement.strucureList
//

#import <Foundation/Foundation.h>
#import "KTElement.h"

/**
 Represents a hierachically link to a object. 
 Object can be an element a query or any other object type. Target Links are represented by its linkID
 */
@interface KTTargetLink : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
Gets the unique link ID
 */
@property (nonatomic) NSInteger parentID;

/**
 Gets or sets the target items name
 */
@property (nonatomic,copy) NSString* entryName;

/**
 Gets or sets the target unique key
 */
@property (nonatomic,copy ) NSString* targetElementKey;

/*
 The own ID of this link. (Self ID )
 */
@property (nonatomic) NSString* linkID;
@property (readonly) NSString* itemClassKey; //* Classkey of target element

/// Classtype (FD,MI,DO) of this element
@property (readonly) NSString* itemClassType;  //
@end
