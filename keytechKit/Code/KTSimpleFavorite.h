//
//  SimpleFavorite.h
//  keytech search ios
//
//  Created by Thorsten Claus on 19.11.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTElement.h"

@interface KTSimpleFavorite : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Unique ID of this favorite
 */
@property (nonatomic) NSInteger parentFolderID;
@property (nonatomic,retain) NSString* folderName;
@property (nonatomic,retain ) NSString* elementKey;
@property (nonatomic) BOOL isFolder;
@property (nonatomic) NSInteger folderID;
@property (readonly) NSString* ItemClassKey; // Nur der Classkey - Anteil, ohne ElementID
@property (readonly) NSString* ItemClassType;  // DO / MI // FD - ruft den vereinfachten Klassentypen ab
@property (nonatomic,retain) KTElement* element;
@end
