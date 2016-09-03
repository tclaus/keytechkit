//
//  KTElement
//  keytech search ios
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTStatusHistoryItem.h"
#import "KTKeyValue.h"
#import "KTFileInfo.h"
#import "KTNoteItem.h"
#import "KTSignedBy.h"
#import "KTElementLink.h"

/**
 This is the main object that descibes a data part in the keytech world.
 Provides the object representation for keytech element classes. Can be a document, folder or masteritem.
 Every element can have some more proerties like its child elements (stucture), its parent elements (whereused), notes, files and so on. 
 Not every element can or will have every poissible sub parts.
 */
@interface KTElement :  NSObject

/**
  A list of types to request the attributes of an element. 
  Every is presented by a minimal set of descriptive propertiers. With this enum some more or even all attributes will be returned by a server request
 
 - none : Only the minimal set of descriptive attributes are returned
 - fullAttributes: Every attribute of this element will returned in the keyValue list
 - editorAttributes: Only attribiutes visible by an editor will returned
 - listerAttributes: Only attribites visible by a lister will returned
 
 */
#ifndef NS_ENUM
@import Foundation;
#endif
typedef NS_ENUM(NSUInteger, KTResponseAttributes) {
    /// Returns the reduced list of Attributes (default)
    KTResponseNoneAttributes            = 0,
    /// Return all available attributes for this element
    KTResponseFullAttributes            = 1,
    /// Return attribuites only needed for a editor layout
    KTResponseEditorAttributes          = 2,
    KTResponseListerAttributes          = 3
};

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Creates and returns a new element with the elementkey in the argument. To receive element data run the refresh selector
 @param elementKey A full qualified element key or a classkey. (ElementKey without the nummeric identifier) to create a new element
 */
+(instancetype)elementWithElementKey:(NSString*)elementKey;

/**
 Initializes a new element with the type of elementKey.
 You can also set a classkey as parameter.
 @param elementKey A elementkey of a existing element (e.g.: Office_File:1234). Or a classkey, in case you will create a new element from a given class. (e.g.: office_file)
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
 Sets the item Classkey. Only for newly created elements. A classkey is a part of an elementkey. Only valid for elements to be created.
 @param itemClassKey Sets a classkey. Only valid if this class is still empty. Use this to create a new element
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
/**
 Returns a list of element recent versions
 */
@property (readonly,strong) NSArray *itemVersionsList;
/**
 If yes then the list ist full loaded
 */
@property (readonly) BOOL isVersionListLoaded;

/**
 Provides a shortcut to a thumbnail. Elements without a unique thumbnailimage dont need to request a specific one.
 */
@property (nonatomic,copy) NSString* itemThumbnailHint;

/**
 Versionstring of current element Version
 */
@property (nonatomic,strong) NSString* itemVersion;
/**
 Returns a list of all element attributes as a key value list. 
 You can set the attribute list by set the KTResponseAttributes property while loading or reloading this element
 */
@property (nonatomic,strong) NSMutableArray <KTKeyValue*> * keyValueList;

/**
 Returns an attribute value from the keyValue list. Element must have a full attributelist.
 @param attribute A named attribute (as_do__status). Its value will be returned.
 @return The underlying value of the given elememnt. Nil if attribute is unknown or not loaded.
 */
-(id)valueForAttribute:(NSString*)attribute;

/**
 Sets a attribute with its value to the keyvalue list. Does not update the common properties.
 @param value the value to be set on the attribut
 @param attribute The unique attribute name to set its value (as_do__status)
 '*/
-(void)setValueForAttribute:(id <NSCopying>)value attribute:(NSString*)attribute;


/**
 Returns the next level of linked elements. If not currentlty loaded a request starts.
 Array contains full elements
 */
@property (readonly,strong) NSArray <KTElement*> * itemStructureList;
@property (readonly) BOOL isStructureListLoaded;

/**
 Starts loading the list of child elements
 @param page The page with a given size. 
 @param size The count of elements wothin a page
 @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)loadStructureListPage:(int)page withSize:(int)size
                 success:(void(^)(NSArray<KTElement*> * itemsList))success
                 failure:(void(^)(NSError *error))failure;


/**
 Returns the bill of material if this element is of type 'masteritem'. Returns an empty list if not loaded.
 */
@property (readonly,strong) NSMutableArray* itemBomList; // Only Items can have a bomlist

/**
 Retun true if Bom List ist loaded
 */
@property (readonly) BOOL isBomListLoaded;


/**
 Starts loading the bom list in a paged based manner
 @param page The page with a given size.
 @param size The count of elements wothin a page
 @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)loadBomListPage:(int)page withSize:(int)size
                 success:(void(^)(NSArray* itemsList))success
                 failure:(void(^)(NSError *error))failure;

/**
 Loads the list of parent elements of structure.
 */
@property (readonly,strong) NSMutableArray <KTElement*> * itemWhereUsedList;
@property (readonly) BOOL isWhereUsedListLoaded;


/**
 Starts loading the where used list. If this element is a child in any structure. This method will return with a list of oarent elements.
 @param page The page with a given size.
 @param size The count of elements wothin a page
 @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)loadWhereUsedListPage:(int)page withSize:(int)size
                 success:(void(^)(NSArray <KTElement*> * itemsList))success
                 failure:(void(^)(NSError *error))failure;
/**
 Starts loading the status history.
 @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)loadStatusHistoryListSuccess:(void(^)(NSArray <KTStatusHistoryItem* >* itemsList))success
                            failure:(void(^)(NSError *error))failure;

/**
 Starts loading of a list of status that can be set on this element
 @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)loadNextAvailableStatusListSuccess:(void(^)(NSArray <NSString*> * itemsList))success
                            failure:(void(^)(NSError *error))failure;

/**
 Starts loading the list of notes attached to this element.
  @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)loadNotesListSuccess:(void(^)(NSArray <KTNoteItem*> * itemsList))success
                    failure:(void(^)(NSError *error))failure;
/**
 Starts loading the filelist
 @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)loadFileListSuccess:(void(^)(NSArray <KTFileInfo*> * itemsList))success
                   failure:(void(^)(NSError *error))failure;

/**
 Starts loading the list of recent versions
  @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)loadVersionListSuccess:(void(^)(NSArray <KTElement*> * itemsList))success
                   failure:(void(^)(NSError *error))failure;

/**
 Adds a link for this element and makes it a chil of the linked element
@param linkToElementKey Adds this element to the element with this key. Keep in mind that the API will make checks if you are allowed to link this element to this type of parent.
@param success Will be called when request responds successfully
@param failure Will be called in case of any error
 */
-(void)addLinkTo:(NSString*)linkToElementKey success:(void(^)(KTElement *elementLink))success
         failure:(void(^)(NSError* error))failure;

/**
 Removes a link to the parent element
 @param linkToElementKey The elementKey of the parent element to remove this element from.
 @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)removeLinkTo:(NSString*)linkToElementKey success:(void(^)(void))success
            failure:(void(^)(NSError* error))failure;



/**
 Returns the masterfile object of applicable
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) KTFileInfo *masterFile;
/**
 Returny the attached filelist. If not currentlty loaded a request starts.
 */
@property (readonly,strong) NSMutableArray <KTFileInfo*> * itemFilesList; // Nur bei Dokumente!
@property (readonly) BOOL isFilesListLoaded;


/**
 Loads a list of states to which this element can be set.
 */
@property (readonly,strong)NSMutableArray <NSString*> *  itemNextAvailableStatusList;
@property (readonly) BOOL isNextAvailableStatusListLoaded;

/**
 Loads notes assigned notes to this element. If not currentlty loaded a request starts.
 */
@property (nonatomic,readonly) NSMutableArray <KTNoteItem*> * itemNotesList;
@property (readonly) BOOL isNotesListLoaded;

/**
 Only documents can be reserverd. In case of items or folder this property returns false.
 */
@property (nonatomic) BOOL isReserved;

/**
 Returns the full name of who has reserverd.
 */
@property (nonatomic,readonly) NSString *isReservedBy;

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
@property (readonly,nonatomic,copy) NSImage* itemThumbnail; // Versucht, zu diesem Element ein Thumbnail zu laden
#else
  @property (readonly,nonatomic,copy) UIImage* itemThumbnail; // Versucht, zu diesem Element ein Thumbnail zu laden
#endif

/// Removes an already loaded thumbnail from cache;
-(void)resetThumbnail;

/**
 Returns the API URL of the file with the given ID
 If a clinet wants to load the file directly - here is the URL to start loading. 
 You must create a request header by your own. 
 @param fileID The nummeric fileID for a file attached to this element

 */
-(NSString*)fileURLOfFileID:(int)fileID;

/**
 Returns the list of status change events. Who did it and when.
 */
@property (nonatomic,readonly) NSArray <KTStatusHistoryItem*> * itemStatusHistory;
/**
 Retuns a value indicating if a statusHistory is already loaded
 */
@property (readonly) BOOL isStatusHistoryLoaded;


// These are some well defined element properties
/// The date this element was created
@property (nonatomic,copy) NSDate* itemCreatedAt;
/// The longname this element was created by whom
@property (nonatomic,copy) NSString* itemCreatedByLong;
/// The shortname this element was created by whom
@property (nonatomic,copy) NSString* itemCreatedBy;
/// The date this element was last changed
@property (nonatomic,copy) NSDate* itemChangedAt;
/// The longname this element was changed by whom
@property (nonatomic,copy) NSString* itemChangedByLong;
/// The shortname this element was changed by whom
@property (nonatomic,copy) NSString* itemChangedBy;

/// In case of a document or item: The date this element got a released state
@property (nonatomic,copy) NSDate* itemReleasedAt;
/// In case this element got a release state: shortname of the releaser
@property (nonatomic,copy) NSString* itemReleasedBy;

/// In case this element got a release state: longname of the releaser
@property (nonatomic,copy) NSString* itemReleasedByLong;

/// Returns TRUE after a successfull delete
@property (readonly) BOOL isDeleted;


@property (NS_NONATOMIC_IOSONLY, getter=isBomAvailable, readonly) BOOL bomAvailable; // Nur Artikel haben Stücklisten


#pragma mark Methods

/**
 Loads the element with the given Key from the API
 @param elementKey Loads a element with this elementkey. eg: "Misc_file:1234"
 @param success Is excecuted after a element is fetched
 @param failure Is excecuded in any case of an error
 */
+(void)loadElementWithKey:(NSString *)elementKey success:(void (^)(KTElement *theElement))success
                  failure:(void(^)(NSError *error))failure;

/**
 Loads the element with the key and metadata
 @param elementKey Loads a element with this elementkey. eg: "Misc_file:1234"
 @param metadata Can be one of ALL, Editor,Lister or None. In addition to the default attributes more attributes can be loaded. If 'ALL' is set, every attribute is loaded with the element. The attribute count can be high. Consider only fetching Editor attributes. Defaults to none.
 @param success Is excecuted after a element is fetched
 @param failure Is excecuded in any case of an error
 */
+(void)loadElementWithKey:(NSString *)elementKey withMetaData:(KTResponseAttributes)metadata
                  success:(void (^)(KTElement *theElement))success
                  failure:(void(^)(NSError *error))failure;
                                                                                                                                                       
/**
 Deletes this element from keytech API
  @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)deleteItem:(void (^)(KTElement *element))success
          failure:(void (^)(KTElement *element, NSError *error))failure;

/**
 Saves this element to API. If this is a new element a new one will be created
  @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)saveItem:(void (^)(KTElement *element))success
                 failure:(void (^)(NSError *error))failure;
                 

/**
 Refreshes this instance immediatley by loading from API
 @param success will be performed when completed.
 @param failure In case of any error the failure block is called
 */
-(void)reload:(void(^)(KTElement *element))success
      failure:(void(^)(NSError *error))failure;

/**
 Refreshes this instance immediatley by loading from API
 @param metadata A set of attributes that will be returned
  @param success Will be called when request responds successfully
 @param failure Will be called in case of any error

 */
-(void)reload:(KTResponseAttributes)metadata success:(void(^)(KTElement *element))success
      failure:(void (^)(NSError *error))failure;

/**
 Moves the element to a new target class
 @param targetClassKey The target Class to that the element will be moved.
  @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)moveToClass:(NSString*)targetClassKey success:(void(^)(NSString *newElementkey))success
           failure:(void(^)(NSError *error))failure;

/**
 Sets a Reserved / Unreserverd status. Only elements of type document can be reserverd. 
 If a element is reserverd by others, no file operations are allowed.
 @param newReserveStatus Set ti true or false to set or release a reserved status.
 @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)setReserveStatus:(BOOL)newReserveStatus success:(void(^)(void))success
                failure:(void(^)(NSError *error))failure;

@end









