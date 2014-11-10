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
#import "KTFileInfo.h"
#import "KTNoteItem.h"
#import "KTSignedBy.h"
#import "KTElementLink.h"

/**
 Provides the object representation for keytech element classes. Can be a document, folder or masteritem.
 */
@interface KTElement :  NSObject <KTLoaderDelegate>

typedef enum {
    /// Returns the reduced list of Attributes (default)
    KTResponseNoneAttributes            = 0,
    /// Return all available attributes for this element
    KTResponseFullAttributes            = 1,
    /// Return attribuites only needed for a editor layout
    KTResponseEditorAttributes          = 2,
    KTResponseListerAttributes          = 3
} KTResponseAttributes;

/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Instantiates a new element with the given ElementKey. To receive Element Data run theh refresh selector
 */
+(instancetype)elementWithElementKey:(NSString*)elementKey;

/**
 Initializes a new element with the type of elementKey.
 You can also set a classkey as parameter.
 @param elementkey A element or classkey. If a classKey was submitted the element can be stored as a new element to the keytech API.
 */
-(instancetype)initWithElementKey:(NSString*)elementKey;


/**
 Unique item name
 */
@property (nonatomic,copy) NSString* itemName;
/**
 The displayname is a assembled name defined by the keytech API. It may contains the name, version, description and any other information about this
 element.
 You can not change this displaystring.
 */
@property (nonatomic,copy) NSString* itemDisplayName;
/**
 Main item Description as provided by the description field
 */
@property (nonatomic,copy) NSString* itemDescription;
/**
 Name (uniqueID) of the current state. You can not set a items state by simply set this property.
 */
@property (nonatomic,copy) NSString* itemStatus;
/**
 Localized name of the elements class.
 */
@property (nonatomic,copy) NSString* itemClassDisplayName; // Classkey

/**
 The nummeric ID of this element.
 */
@property(readonly) int itemID;
/**
 The full elementkey in notation ClassKey:ElementID.
 If this is a new element and still not saved through the API there is no nummeric elementid but only the the ClassKey
 */
@property (nonatomic,copy) NSString* itemKey; // ClassKey:ID   SLDRW_3dMISC:1234
/**
 The classkey is the elementkey without the identifier. In type of <ClassLabel>_<ClassType> like: 3DSLD_DRW.
 */
@property (readonly,copy) NSString* itemClassKey; // Nur der Classkey - Anteil, ohne ElementID

/**
 Sets the item Classkey. Only for newly created element. A classkey is a part of an elementkey. Only valid for elements to be created.
 */
-(void)setItemClassKey:(NSString *)itemClassKey;

/**
 One of DO, MI, FD. A token that identifies a classtype
 */
@property (readonly,copy) NSString* itemClassType;  // DO / MI // FD - ruft den vereinfachten Klassentypen ab

/**
 A shortcut to detect any versions of this element without make a query.
 */
@property (readonly) BOOL hasVersions;

@property (readonly,strong) NSArray *itemVersionsList;
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

/// Returns an attribute value from the keyValue list. Element must have a full attributelist.
-(id)valueForAttribute:(NSString*)attribute;

/// Sets a attribute with its value to the keyvalue list. Does not update the common properties.
-(void)setValueForAttribute:(id <NSCopying>)value attribute:(NSString*)attribute;


/**
 Returns the next level of linked elements. If not currentlty loaded a request starts.
 Array contains full elements
 */
@property (readonly,strong) NSArray* itemStructureList;
@property (readonly) BOOL isItemStructureListLoaded;

/**
 Starts loading the list of child elements
 @param page The page with a given size. 
 @param size The count of elements wothin a page
 */
-(void)loadStructureListPage:(int)page withSize:(int)size
                 success:(void(^)(NSArray* itemsList))success
                 failure:(void(^)(NSError *error))failure;

-(void)loadBomListPage:(int)page withSize:(int)size
                 success:(void(^)(NSArray* itemsList))success
                 failure:(void(^)(NSError *error))failure;

-(void)loadWhereUsedListPage:(int)page withSize:(int)size
                 success:(void(^)(NSArray* itemsList))success
                 failure:(void(^)(NSError *error))failure;
/**
 Starts loading the status history.
 */
-(void)loadStatusHistoryListSuccess:(void(^)(NSArray* itemsList))success
                            failure:(void(^)(NSError *error))failure;
/**
 Starts loading the notes list
 */
-(void)loadNotesListSuccess:(void(^)(NSArray* itemsList))success
                    failure:(void(^)(NSError *error))failure;
/**
 Starts loading the filelist
 */
-(void)loadFileListSuccess:(void(^)(NSArray* itemsList))success
                   failure:(void(^)(NSError *error))failure;

/**
 Starts loading the list of recent versions
 */
-(void)loadVersionListSuccess:(void(^)(NSArray* itemsList))success
                   failure:(void(^)(NSError *error))failure;

-(void)addLinkTo:(NSString*)linkToElementKey success:(void(^)(KTElement *elementLink))success failure:(void(^)(NSError* error))failure;

-(void)removeLinkTo:(NSString*)linkToElementKey success:(void(^)(void))success failure:(void(^)(NSError* error))failure;


// wie dann speichern? - Sofort?


/**
 Returns the bill of material if this element is of type 'masteritem'. Returns an empty list if not loaded.
 */
@property (readonly,strong) NSArray* itemBomList; // Only Items can have a bomlist
/**
 Retun true if Bom List ist loaded
 */
@property (readonly) BOOL isBomListLoaded;

/**
 Returns the masterfile object of applicable
 */
-(KTFileInfo*)masterFile;
/**
 Returny the attached filelist. If not currentlty loaded a request starts.
 */
@property (readonly,strong) NSArray* itemFilesList; // Nur bei Dokumente!
@property (readonly) BOOL isFilesListLoaded;

/**
 Loads the list of parent elements in which this Element is used.
 */
@property (readonly,strong) NSArray* itemWhereUsedList;
@property (readonly) BOOL isWhereUsedListLoaded;

/**
 Loads a list of states to which this element can be set.
 */
@property (readonly,strong)NSMutableArray* itemNextAvailableStatusList;
@property (readonly) BOOL isNextAvailableStatusListLoaded;

/**
 Loads notes assigned notes to this element. If not currentlty loaded a request starts.
 */
@property (nonatomic,readonly) NSArray* itemNotesList;
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

@property (nonatomic,readonly) NSArray* itemStatusHistory;
@property (readonly) BOOL isStatusHistoryLoaded;


// Diese Properties liegen in der KeyValueListe vor
@property (nonatomic,copy) NSDate* itemCreatedAt;
@property (nonatomic,copy) NSString* itemCreatedByLong;
@property (nonatomic,copy) NSString* itemCreatedBy;

@property (nonatomic,copy) NSDate* itemChangedAt;
@property (nonatomic,copy) NSString* itemChangedByLong;
@property (nonatomic,copy) NSString* itemChangedBy;

@property (nonatomic,copy) NSDate* itemReleasedAt;
@property (nonatomic,copy) NSString* itemReleasedBy;
@property (nonatomic,copy) NSString* itemReleasedByLong;

/// Returns TRUE after a successfull delete
@property (readonly) BOOL isDeleted;


-(BOOL)isBomAvailable; // Nur Artikel haben Stücklisten


#pragma mark Methods

/**
 Loads the element with the given Key from the API
 @param success Is excecuted after a element is fetched
 @param failure Is excecuded in any case of an error
 */
+(void)loadElementWithKey:(NSString *)elementKey success:(void (^)(KTElement *theElement))success failure:(void(^)(NSError *error))failure;

/**
 Loads the element with the key and metadata
 @param withMetaData: Can be one of ALL, Editor,Lister or None. In addition to the default attributes more attributes can be loaded. If 'ALL' is set, every attribute is loaded with the element. The attribute count can be high. Consider only fetching Editor attributes. Defaults to none.
 @param success Is excecuted after a element is fetched
 @param failure Is excecuded in any case of an error
 */
+(void)loadElementWithKey:(NSString *)elementKey withMetaData:(KTResponseAttributes)metadata
                  success:(void (^)(KTElement *theElement))success
                  failure:(void(^)(NSError *error))failure;
                                                                                                                                                       
/**
 Deletes this element from keytech API
 */
-(void)deleteItem:(void (^)(KTElement *element))success
          failure:(void (^)(KTElement *element, NSError *error))failure;

/**
 Saves this element to API. If this is a new element a new one will be created
 */
-(void)saveItem:(void (^)(KTElement *element))success
                 failure:(void (^)(KTElement *element,NSError *error))failure;
                 

/**
 Refreshes this instance immediatley by loading from API
 @param success will be performed when completed.
 @param failure In case of any error the failure block is called
 */
-(void)reload:(void(^)(KTElement *element))success failure:(void(^)(NSError *error))failure;

/**
 Refreshes this instance immediatley by loading from API
 @param success will be performed when completed.
 */
-(void)reload:(KTResponseAttributes)metadata success:(void(^)(KTElement *element))success failure:(void (^)(NSError *))failure;
@end









