//
//  KTElement
//  keytech search ios
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTKeytech.h"
#import "KTStatusHistoryItem.h"
#import "KTKeyValue.h"

#import "KTNoteItem.h"
#import "KTSignedBy.h"


/**
 Provides the object representation for keytech element classes. Can be a document, folder or masteritem.
 */
@interface KTElement :  NSObject <KTLoaderDelegate>

/**
 Provides the object Mapping for this class
 */
+(RKObjectMapping*)mapping;

/**
 Unique item name
 */
@property (nonatomic,copy) NSString* itemName;
@property (nonatomic,copy) NSString* itemDisplayName;
/**
 Main item Description as provided by the description field
 */
@property (nonatomic,copy) NSString* itemDescription;
/**
 Name (uniqueID) of the current state. You can not set a items state by simply set this property.
 */
@property (nonatomic,copy) NSString* itemStatus;
@property (nonatomic,copy) NSString* itemDisplayTypeName; // Classkey
@property(readonly) int itemID;
@property (nonatomic,copy) NSString* itemKey; // ClassKey:ID   SLDRW_3dMISC:1234
@property (readonly,copy) NSString* itemClassKey; // Nur der Classkey - Anteil, ohne ElementID
@property (readonly,copy) NSString* itemClassType;  // DO / MI // FD - ruft den vereinfachten Klassentypen ab

/**
 A shortcut to detect any versions of this element without make a query.
 */
@property (readonly) BOOL hasVersions;

@property (readonly,strong) NSMutableArray *itemVersionsList;
@property (readonly) BOOL isVersionListLoaded;

/**
 Provides a shortcut to a thumbnail. Elements without a unique thumbnailimage dont need to request a specific one.
 */
@property (nonatomic,copy) NSString* itemThumbnailHint;

/**
 Versionstring of current element Version
 */
@property (nonatomic,strong) NSString* itemVersion;
@property (nonatomic,strong) NSMutableArray* keyValueList;


/**
 Returns the next level of linked elements. If not currentlty loaded a request starts.
 */
@property (readonly,copy) NSMutableArray* itemStructureList;
@property (readonly) BOOL isStructureListLoaded;


/**
 Returns the bill of material if this element is of type 'masteritem'. Returns an empty list if not loaded.
 */
@property (readonly,strong) NSMutableArray* itemBomList; // Only Items can have a bomlist
/**
 Retun true if Bom LIst ist loaded
 */
@property (readonly) BOOL isBomListLoaded;
/**
 Returny the attached filelist. If not currentlty loaded a request starts.
 */
@property (readonly,strong) NSMutableArray* itemFilesList; // Nur bei Dokumente!
@property (readonly) BOOL isFilesListLoaded;

/**
 Loads the list of parent elements in which this Element is used.
 */
@property (readonly,strong) NSMutableArray* itemWhereUsedList;
@property (readonly) BOOL isWhereUsedListLoaded;

/**
 Loads a list of states to which this element can be set.
 */
@property (readonly,strong)NSMutableArray* itemNextAvailableStatusList;
@property (readonly) BOOL isNextAvailableStatusListLoaded;

/**
 Loads notes assigned notes to this element. If not currentlty loaded a request starts.
 */
@property (nonatomic,readonly) NSMutableArray* itemNotesList;
@property (readonly) BOOL isNotesListLoaded;

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
@property (readonly,nonatomic,copy) NSImage* itemThumbnail; // Versucht, zu diesem Element ein Thumbnail zu laden
#else
  @property (readonly,nonatomic,copy) UIImage* itemThumbnail; // Versucht, zu diesem Element ein Thumbnail zu laden
#endif

/// Removes an already loaded thumbnail from cache;
-(void)resetThumbnail;

/**
 returns the API URL of the file with the given ID
 */
-(NSString*)fileURLOfFileID:(int)fileID;

@property (nonatomic,readonly) NSMutableArray* itemStatusHistory;
@property (readonly) BOOL isStatusHistoryLoaded;


// Diese Properties liegen in der KeyValueListe vor
@property (nonatomic,copy) NSDate* itemCreatedAt;
@property (nonatomic,copy) NSString* itemCreatedByLong;
@property (nonatomic,copy) NSString* itemCreatedBy;

@property (nonatomic,copy) NSDate* itemChangedAt;
@property (nonatomic,copy) NSString* itemChangedByLong;
@property (nonatomic,copy) NSString* itemChangedBy;


-(BOOL)isBomAvailable; // Nur Artikel haben Stücklisten

@end
