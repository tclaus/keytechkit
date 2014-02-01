//
//  SimpleFavorite.h
//  keytech search ios
//
//  Created by Thorsten Claus on 19.11.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTElement.h"

@interface KTTargetLink : NSObject

/**
 Sets the mapping
 */
+(id)setMapping;

/*
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
 Die ID des Folders(Bin) in dem dieses Element existiert
 */
@property (nonatomic) NSInteger sourceID;
@property (readonly) NSString* itemClassKey; //* Classkey of target element
@property (readonly) NSString* itemClassType;  // Classtype (FD,MI,DO) of this element
@end
