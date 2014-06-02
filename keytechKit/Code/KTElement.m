//
//  KTElement
//  keytech search ios
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//


#import "KTManager.h"
#import "KTNotifications.h"
#import "KTLoaderInfo.h"
#import "KTElement.h"

@interface KTElement()

@end

@implementation KTElement{
@private
    
    /// Notifies about loading in process
    BOOL _isStatusHistoryLoading;
    
    
    /// Notifies about loading in process
    BOOL _isStructureLoading;
    /// Notifies about loading in process
    BOOL _isItemFileslistLoading;
    /// Notifies about loading in process
    BOOL _isItemNotesListLoading;
    /// Is YES if this collection is loaded
    BOOL _isItemThumnailLoaded;
    /// Notifies about loading in process
    BOOL _isItemThumbnailLoading;
    /// Notifies about loading in process
    BOOL _isItemWhereUsedListLoading;
    /// Notifies about loading in process
    BOOL _isItemNextStatesListLoading;
    /// Notifies about loading in process
    
    BOOL _isItemBomListLoading;
    
    /// Notifies is load is in progress
    BOOL _isItemVersionListLoading;
    
    
    // Hilfsobjekt, das weitere Eigenschaften nachladen kann durchführt
    KTKeytech* ktManager;

}

/// The last used manager for mapping
static RKObjectManager *usedRKManager;

static NSTimeInterval _thumbnailLoadingTimeout = 4; //* 4 Seconds Timeout for thumbnails

static dispatch_queue_t _barrierQueue;

/// Provides a process-wide cache of all Thumbnails
static NSCache* thumbnailCache;

/// Provides a list of currently processing thumbnail loading queues.
static NSMutableSet* thumbnailLoadingQueue;

static NSObject* dummy;

// Mapping für diese Klasse merken
static RKObjectMapping* _mapping;



#pragma mark Properties
@synthesize itemStatusHistory = _itemStatusHistory;
@synthesize isStatusHistoryLoaded = _isStatusHistoryLoaded;

@synthesize itemStructureList = _itemStructureList;
@synthesize isStructureListLoaded = _isStructureListLoaded;

@synthesize itemVersionsList =_itemVersionsList;
@synthesize isVersionListLoaded = _isVersionListLoaded;

@synthesize itemFilesList = _itemFilesList;
@synthesize isFilesListLoaded = _isFilesListLoaded;

@synthesize itemBomList = _itemBomList;
@synthesize isBomListLoaded = _isBomListLoaded;

@synthesize itemNotesList = _itemNotesList;
@synthesize isNotesListLoaded =_isNotesListLoaded;

@synthesize itemThumbnail = _itemThumbnail;
//Sonderfall

@synthesize itemWhereUsedList = _itemWhereUsedList;
@synthesize isWhereUsedListLoaded =_isWhereUsedListLoaded;

@synthesize itemNextAvailableStatusList = _itemNextAvailableStatusList;
@synthesize isNextAvailableStatusListLoaded = _isNextAvailableStatusListLoaded;

@synthesize itemThumbnailHint = _itemThumbnailHint;


@synthesize keyValueList = _keyValueList;

@synthesize isDeleted = _isDeleted;


/// Returns a trimmed item Display name.
-(NSString*)itemDisplayName{
    return [_itemDisplayName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}




// Returns the numeric ID
-(int) itemID{
    NSArray *components=[self.itemKey componentsSeparatedByString:@":"];
    
    if(components.count>=2){
        
        return (int)[components[1] integerValue];
    }
    
    return -1;
}

-(NSString*) itemClassKey{
    NSArray *components=[self.itemKey componentsSeparatedByString:@":"];
    
    if(components.count>=2)
        return [NSString stringWithFormat:@"%@",components[0]];
    
    return self.itemKey;
}

-(NSString*) itemClassType{
    
    if ([self.itemClassKey rangeOfString:@"_MI"].location !=NSNotFound) return @"MI";
    if ([self.itemClassKey rangeOfString:@"_FD"].location !=NSNotFound) return @"FD";
    if ([self.itemClassKey rangeOfString:@"_WF"].location !=NSNotFound) return @"FD";
    
    return @"DO";
    
}


// Sets the Object mapping for JSON
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (usedRKManager!=manager){
        usedRKManager = manager;

        _mapping = [RKObjectMapping mappingForClass:[KTElement class]];
        
        
        [_mapping addAttributeMappingsFromDictionary:@{@"Description":@"itemDescription",
                                                       @"ClassDisplayName":@"itemClassDisplayName",
                                                       @"Key":@"itemKey",
                                                       @"Name":@"itemName",
                                                       @"DisplayName":@"itemDisplayName",
                                                       @"Status":@"itemStatus",
                                                       @"Version":@"itemVersion",
                                                       @"CreatedAt":@"itemCreatedAt",
                                                       @"CreatedBy":@"itemCreatedBy",
                                                       @"CreatedByLong":@"itemCreatedByLong",
                                                       @"ChangedAt":@"itemChangedAt",
                                                       @"ChangedBy":@"itemChangedBy",
                                                       @"ChangedByLong":@"itemChangedByLong",
                                                       @"ThumbnailHint":@"itemThumbnailHint",
                                                       @"HasVersions":@"hasVersions"
                                                       }];
        
        RKObjectMapping *keyValueMapping = [KTKeyValue mappingWithManager:manager];
        
        RKRelationshipMapping *keyValueListResponse =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"KeyValueList"
                                                    toKeyPath:@"keyValueList"
                                                  withMapping:keyValueMapping];
        
        [_mapping addPropertyMapping:keyValueListResponse];
        
        // Zentralisiert ?
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                   responseDescriptorWithMapping:_mapping
                                                   method:RKRequestMethodGET | RKRequestMethodPOST | RKRequestMethodPUT
                                                   pathPattern:nil
                                                   keyPath:@"ElementList"
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        
        // For POST and PUT only the keyValue List and key parameter is needed.
        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        
        [requestMapping addAttributeMappingsFromDictionary:@{@"itemKey":@"Key"}];

        
        RKRelationshipMapping *keyValueRelationShipRequest =
       [RKRelationshipMapping relationshipMappingFromKeyPath:@"keyValueList"
                                                    toKeyPath:@"KeyValueList"
                                                  withMapping:[keyValueMapping inverseMapping ]];
       
        [requestMapping addPropertyMapping:keyValueRelationShipRequest];
        
        
        
        // If POST or PUT, the new element will be returned
        RKRequestDescriptor *elementRequestDescriptor = [RKRequestDescriptor
                                                         requestDescriptorWithMapping:requestMapping
                                                         objectClass:[KTElement class]
                                                         rootKeyPath:nil
                                                         method:RKRequestMethodPOST|RKRequestMethodPUT];

        
        // Path Argument
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElement class]
                                           pathPattern:@"elements/:itemKey"
                                           method:RKRequestMethodGET]] ;
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElement class]
                                           pathPattern:@"elements"
                                           method:RKRequestMethodPOST]] ;
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElement class]
                                           pathPattern:@"elements/:itemKey"
                                           method:RKRequestMethodPUT]] ;
        
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElement class]
                                           pathPattern:@"elements/:itemKey"
                                           method:RKRequestMethodDELETE]] ;
        
        [manager addResponseDescriptorsFromArray:@[ responseDescriptor ]];
        [manager addRequestDescriptor:elementRequestDescriptor];
        
    }
    return _mapping;
}




#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
//Multiplattform supportet. Returns thumnail or classicon. Whatever ist implemented
-(NSImage*)itemThumbnail{
    
    if (_isItemThumnailLoaded &! _isItemThumbnailLoading){
        return _itemThumbnail;
        
    }else
        
        if (!_isItemThumbnailLoading &!_isItemThumnailLoaded){
            _isItemThumbnailLoading = YES;
            
            //[self performSelectorInBackground:@selector(loadItemThumbnail) withObject:nil ];
            [self loadItemThumbnail];
            return _itemThumbnail;
            
        } else {
            return _itemThumbnail;
        }
    
}
#else
//Multiplattform supported. Returns thumbnail or classicon. Whatever ist implemented in keytech basis.
-(UIImage*)itemThumbnail{
    if (_isItemThumnailLoaded & !_isItemThumbnailLoading){
        return _itemThumbnail;
        
    }else{
        if (!_isItemThumbnailLoading){
            _isItemThumbnailLoading = YES;
            //[self loadItemThumbnail];
            [self performSelectorInBackground:@selector(loadItemThumbnail) withObject:nil];
        }
        return _itemThumbnail;
    }
}
#endif


-(NSMutableArray*)itemWhereUsedList{
    if (_isWhereUsedListLoaded &!_isItemWhereUsedListLoading){
        return _itemWhereUsedList;
    }else {
        if (!_isItemWhereUsedListLoading){
            _isItemWhereUsedListLoading = YES;
            [ktManager performGetElementWhereUsed:self.itemKey loaderDelegate:self];
        }
        return _itemWhereUsedList;
    }
}

// Returns the current list or queries a new one.
-(NSMutableArray*)itemNextAvailableStatusList{
    if (_isNextAvailableStatusListLoaded &!_isItemNextStatesListLoading){
        return _itemNextAvailableStatusList;
    }else {
        
        if (!_isItemNextStatesListLoading){
            _isItemNextStatesListLoading = YES;
            // Starts the query and returns the current (empty) list
            [ktManager performGetElementNextAvailableStatus:self.itemKey loaderDelegate:self];
        }
        
        return _itemNextAvailableStatusList;
    }
}

-(NSMutableArray*)itemStatusHistory{
    if (_isStatusHistoryLoaded &!_isStatusHistoryLoading){
        return _itemStatusHistory;
    }else{
        if(!_isStatusHistoryLoading){
            _isStatusHistoryLoading = YES;
            // Return preparied (empty) array but perform fill the list
            [ktManager performGetElementStatusHistory:self.itemKey loaderDelegate:self];
        }
        return _itemStatusHistory;
    }
    
}

/**
 Performs lazy loading of bom lists.
 Only Items may return valid Bom lists.
 */
-(NSMutableArray*)itemBomList{
    if (_isBomListLoaded &! _isItemBomListLoading){
        return _itemBomList;
    }else {
        if(!_isItemBomListLoading){
            _isItemBomListLoading = YES;
            [ktManager performGetElementBom:self.itemKey loaderDelegate:self];
        }
        
        return _itemBomList;
    }
}

/**
 Performs a load of Versionslist - if hasVersion is True
 */
-(NSMutableArray *)itemVersionsList{
    if (self.hasVersions) {
        if (_isVersionListLoaded &! _isItemVersionListLoading){
            return _itemVersionsList;
        } else {
            if (!_isItemVersionListLoading) {
                [ktManager performGetElementVersions:self.itemKey loaderDelegate:self];
            }
        }
        
        return _itemVersionsList;
        
    } else {
        return _itemVersionsList;
    }
}

/**
 Performs lazy loading of structural data. Every elementtype might have structural data.
 Child elements linked to this parent element.
 Loading is asynchron. So first getting this property returns a nil value. After Request returns KVO should send a value changed signal.
 */
-(NSMutableArray*)itemStructureList{
    if (_isStructureListLoaded &!_isStructureLoading){
        return _itemStructureList;
    }else{
        if (!_isStructureLoading) {
            _isStructureLoading = YES;
            [ktManager performGetElementStructure:self.itemKey loaderDelegate:self];
        }
        return _itemStructureList;
    }
    
}

// Return current filelist or requests a new one from server
-(NSMutableArray*)itemFilesList{
    if (_isFilesListLoaded & !_isItemFileslistLoading){
        return _itemFilesList;
    }else{
        _isItemFileslistLoading = YES;
        [ktManager performGetFileList:self.itemKey loaderDelegate:self];
        return _itemFilesList;
    }
}

// Return current notes list or requests a new one from server.
-(NSMutableArray*)itemNotesList{
    if (_isNotesListLoaded &!_isItemNotesListLoading){
        return _itemNotesList;
    }else{
        _isItemNotesListLoading = YES;
        [ktManager performGetElementNotes:self.itemKey loaderDelegate:self];
        return _itemNotesList;
    }
}

#pragma mark Server response

-(void)requestProceedWithError:(KTLoaderInfo*)loaderInfo error:(NSError *)theError{
    
    // Clear the loading - States
    if ([loaderInfo.resourcePath hasSuffix:@"statushistory"])
        _isStatusHistoryLoading = NO;
    
    if ([loaderInfo.resourcePath hasSuffix:@"nextstatus"])
        _isItemNextStatesListLoading = NO;
    
    if ([loaderInfo.resourcePath hasSuffix:@"structure"])
        _isStructureLoading = NO;
    
    if ([loaderInfo.resourcePath hasSuffix:@"files"])
        _isItemFileslistLoading = NO;
    
    if ([loaderInfo.resourcePath hasSuffix:@"notes"])
        _isItemNotesListLoading = NO;
    
    if ([loaderInfo.resourcePath hasSuffix:@"whereused"])
        _isItemWhereUsedListLoading = NO;
    
    if ([loaderInfo.resourcePath hasSuffix:@"bom"])
        _isItemBomListLoading = NO;
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KTRequestDidFailWithErrorNotification
                                                        object:self
                                                      userInfo:nil];
}

// Invoked by a successful search
-(void)requestDidProceed:(NSArray*)searchResult fromResourcePath:(NSString*)resourcePath{
    
    
    // Structure
    if ([resourcePath hasSuffix:@"structure"]){
        // Set for KVC
        _isStructureLoading = NO;
        _isStructureListLoaded = YES;
        
        if (!_itemStructureList){
            _itemStructureList = [[NSMutableArray alloc] initWithArray:searchResult];
        }else {
            
            // Set by KVC
            [self willChangeValueForKey:@"itemStructureList"];
            _itemStructureList = [searchResult copy];
            //[_itemStructureList setArray:searchResult];
            [self didChangeValueForKey:@"itemStructureList"];
        }
        
        return;
    }
    
    //WhereUsed
    if ([resourcePath hasSuffix:@"whereused"]){
        _isItemWhereUsedListLoading = NO;
        _isWhereUsedListLoaded = YES;
        //Set by KVC
        [self willChangeValueForKey:@"itemWhereUsedList"];
        [_itemWhereUsedList setArray:searchResult];
        [self didChangeValueForKey:@"itemWhereUsedList"];
        
        return;
    }
    
    
    // BOM
    if ([resourcePath hasSuffix:@"bom"]){
        // Set for KVC
        _isItemBomListLoading = NO;
        _isBomListLoaded = YES;
        
        if (!_itemBomList){
            _itemBomList = [[NSMutableArray alloc] initWithArray:searchResult];
        }else {
            
            // Set by KVC
            [self willChangeValueForKey:@"itemBomList"];
            [_itemBomList setArray:searchResult];
            [self didChangeValueForKey:@"itemBomList"];
        }
        
        return;
    }
    
    //Statushistory
    if ([resourcePath hasSuffix:@"statushistory"]){
        _isStatusHistoryLoading = NO;
        _isStatusHistoryLoaded = YES;
        //Set by KVC
        [self willChangeValueForKey:@"itemStatusHistory"];
        [_itemStatusHistory setArray:searchResult];
        [self didChangeValueForKey:@"itemStatusHistory"];
        
        return;
    }
    
    //next available status
    if ([resourcePath hasSuffix:@"nextstatus"]){
        
        _isItemNextStatesListLoading = NO;
        _isNextAvailableStatusListLoaded = YES;
        //Set by KVC
        if (!_itemNextAvailableStatusList){
            _itemNextAvailableStatusList = [[NSMutableArray alloc]initWithArray:searchResult];
        } else {
            
            [self willChangeValueForKey:@"itemNextAvailableStatusList"];
            
            [_itemNextAvailableStatusList setArray:searchResult];
            [self didChangeValueForKey:@"itemNextAvailableStatusList"];
            
        }
        return;
    }
    
    if ([resourcePath hasSuffix:@"versions"]){
        
        _isItemVersionListLoading = NO;
        _isVersionListLoaded = YES;
        //Set by KVC
        if (!_itemVersionsList){
            _itemVersionsList = [[NSMutableArray alloc]initWithArray:searchResult];
        } else {
            
            [self willChangeValueForKey:@"itemVersionsList"];
            
            [_itemVersionsList setArray:searchResult];
            [self didChangeValueForKey:@"itemVersionsList"];
            
        }
        return;
    }
    
    
    // FilesList
    if ([resourcePath hasSuffix:@"files"]){
        
        _isItemFileslistLoading = NO;
        _isFilesListLoaded = YES;
        if (!_itemFilesList) {
            _itemFilesList = [[NSMutableArray alloc ]initWithArray:searchResult];
            
        }else {
            //set by KVC
            [self willChangeValueForKey:@"itemFilesList"];
            [_itemFilesList setArray:searchResult];
            [self didChangeValueForKey:@"itemFilesList"];
        }
        
        // Set elementKey to every file
        [_itemFilesList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            KTFileInfo *file = (KTFileInfo*)obj;
            file.elementKey = self.itemKey;
        }];
        
        return;
    }
    
    //notes
    if ([resourcePath hasSuffix:@"notes"]){
        
        _isItemNotesListLoading = NO;
        _isNotesListLoaded = YES;
        if (!_itemNotesList) {
            _itemNotesList = [[NSMutableArray alloc ]initWithArray:searchResult];
        }else {
            //set by KVC
            [self willChangeValueForKey:@"itemNotesList"];
            [_itemNotesList setArray:searchResult];
            [self didChangeValueForKey:@"itemNotesList"];
        }
        
        return;
    }
    
}

#pragma mark Thumbnail handling

/// Resets the thumbnail-cache for this Element
-(void)resetThumbnail{
    
    if(![thumbnailCache objectForKey:self.itemThumbnailHint]){
        [thumbnailCache removeObjectForKey:self.itemThumbnailHint];
        
    }
    
    
}

static long numberOfThumbnailsLoaded;




//Loads items thumbnail
-(void)loadItemThumbnail{
    
    if (!_isItemThumnailLoaded){
        
        // Im Test kann der ThumbnailKey druchaus leer sein
        NSString* thumbnailKey;
        if (self.itemThumbnailHint && self.itemThumbnailHint.length>0){
            thumbnailKey = self.itemThumbnailHint;
        }else {
            thumbnailKey = self.itemKey;
            //TODO: Kein Thumbnail, sondern klassenschlüssel laden
        }
        
        if (!thumbnailCache){
            thumbnailCache =  [[NSCache alloc]init];
        }
        
        if ([thumbnailCache objectForKey:thumbnailKey]) {
            
            // found!
            [self willChangeValueForKey:@"itemThumbnail"]; //Start KVC
            _itemThumbnail = [thumbnailCache objectForKey:thumbnailKey];
            _isItemWhereUsedListLoading = NO;
            _isItemThumnailLoaded = YES;
            [self didChangeValueForKey:@"itemThumbnail"]; //End KVC
            
            return;
        }
        
        // Nicht im cache vorhanden; lade dann neu.
        
        
        // Another load process my be in queue. Test this and let this thread wait a bit
        if (!thumbnailLoadingQueue)
            thumbnailLoadingQueue = [[NSMutableSet alloc]init];
        
        if ([thumbnailLoadingQueue containsObject:thumbnailKey]) {
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
            
            dispatch_async(queue, ^{
                // Load is in progress. wait as long as the Object in queued
                NSDate *startDate = [NSDate date];
                
                while ([thumbnailLoadingQueue containsObject:thumbnailKey]) {
                    
                    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
                    if ([[NSDate date] timeIntervalSinceDate:startDate] > _thumbnailLoadingTimeout) {
                        
                        // NSLog(@"*** Time out for loading thumnail for %@ after %f seconds...", thumbnailKey, _thumbnailLoadingTimeout);
                        _isItemThumbnailLoading = NO;
                        _isItemThumnailLoaded = YES;
                        
                        // Remove the queue flag
                        
                        [self removeThumbnailKeyFromQueue:thumbnailKey];
                        
                        return;
                        //TODO: What to do if no thumbnail cound be loaded?
                    }
                }
                
                
                // Some other proces has loaded my requesed thumbnail
                _isItemThumnailLoaded = YES;
                _isItemThumbnailLoading = NO;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // Returning the now cached thumbnail
                    [self willChangeValueForKey:@"itemThumbnail"]; //Signaling KVC that value has changed
                    _itemThumbnail = [thumbnailCache objectForKey:thumbnailKey];
                    [self didChangeValueForKey:@"itemThumbnail"]; //
                });
            });
            
            //return; // Queue ended valueshould
            
        }
        
        // Add current Object to Wait-For-Load queue
        [thumbnailLoadingQueue addObject:[thumbnailKey copy]];
        
        NSString *resource = [NSString stringWithFormat:@"elements/%@/thumbnail", self.itemKey];
        NSMutableURLRequest *request = [[RKObjectManager sharedManager].HTTPClient requestWithMethod:@"GET" path:resource parameters:nil ];
        
        NSURLSession *defaultSession = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask *dataTask =
        [defaultSession downloadTaskWithRequest:request
                              completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                  
                                  @try {
                                      dispatch_sync(dispatch_get_main_queue(), ^{
                                      [self willChangeValueForKey:@"itemThumbnail"]; //Start KVC
                                      });
                                }
                                  @catch(NSException* __unused exception){}
                                  
                                  
                                  numberOfThumbnailsLoaded ++;
                                  
#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
                                  _itemThumbnail = [[NSImage alloc] initWithContentsOfURL:location];
                                  
#else
                                  NSData *data = [NSData dataWithContentsOfURL:location];
                                  _itemThumbnail = [[UIImage alloc]initWithData:data];
                                  
#endif
                                  _isItemThumnailLoaded = YES;
                                  _isItemThumbnailLoading = NO;
                                  
                                  
                                  
                                  if(_itemThumbnail) {  // might be NIL if server did not respond
                                      [thumbnailCache setObject:_itemThumbnail forKey:thumbnailKey];
                                  }
                                  // Remove hint from download-queue
                                  [self removeThumbnailKeyFromQueue:thumbnailKey];
                                  
                                  @try{
                                      dispatch_sync(dispatch_get_main_queue(), ^{
                                      [self didChangeValueForKey:@"itemThumbnail"];
                                      });
                                    }
                                  @catch(NSException * __unused exception){}
        
                                
                              }];
        
        
        [dataTask resume];
        
        
    }
    
}


-(void)dealloc{
    
}

- (void)removeThumbnailKeyFromQueue:(NSObject <NSCopying> *)thumbnailKey
{
    dispatch_barrier_async(_barrierQueue, ^
                           {
                               [thumbnailLoadingQueue removeObject:thumbnailKey];
                           });
}


-(BOOL)isKeyValueListLoaded{
    return _keyValueList !=nil;
}



-(BOOL)isFileListAvailable{
    // Dokumente oder Mappen können Dateien besitzten
    if ([self.itemClassType isEqualToString:@"DO"] ||[self.itemClassType isEqualToString:@"FD"] ){
        return YES;
    }else{
        return NO;
    }
    
}


-(BOOL)isBomAvailable{
    if ([self.itemClassType isEqualToString:@"MI"] ){
        return YES;
    }
    return NO;
}

/*
 Gibt die erweiterte Liste der Eigenschaften zurück
 */
-(NSArray*)KeyValueList{
    return _keyValueList;
}

-(id)valueForKey:(NSString*)key{
    return [super valueForKey:key];
}

-(void)setValue:(id)value forKey:(NSString*)key{
    [super setValue:value forKey:key];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"Set Value for Undefined Key:'%@'",key);
}

-(id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"Undefined Key:'%@'",key);
    return nil;
}


/*
 -(void)setValue:(id)value forKey:(NSString *)key{
 [super setValue:value forKey:key];
 // Ansonsten im eigenen dictionary suchen
 
 }
 */

//Helps debugging output
-(NSString*)description{
    return [NSString stringWithFormat:@"item: %@",[self itemName]];
}

-(NSString *)debugDescription{
    return self.itemDescription;
}

// Return full qualified FileID
-(NSString *)fileURLOfFileID:(int)fileID{
    
    
    NSString* fileURL = [NSString stringWithFormat:@"/elements/%@/files/%d",self.itemKey, fileID];
    return fileURL;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        numberOfThumbnailsLoaded = 0;
        // Pre allocate some mutables arrays to support lazy loading
        
        ktManager= [[KTKeytech alloc]init];
        _itemStatusHistory = [[NSMutableArray alloc]init];
        _itemStructureList = [[NSMutableArray alloc]init];
        _itemFilesList = [[[NSMutableArray alloc]init]init];
        _itemNotesList = [[NSMutableArray alloc]init];
        _itemNextAvailableStatusList = [[NSMutableArray alloc]init];
        _itemWhereUsedList = [[NSMutableArray alloc]init];
        _itemBomList = [[NSMutableArray alloc]init];
        _itemVersionsList = [[NSMutableArray alloc]init];
        
        _isDeleted = NO;
        
        _barrierQueue = dispatch_queue_create("de.claus-software.keytechPLM-ThumbnailDownloader", DISPATCH_QUEUE_CONCURRENT);
        
    #ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
        [NSImage imageNamed:NSImageNameAdvanced]; // Placeholder image
#else
        
        //[UIImage imageNamed:NSImageNameAdvanced];
#endif
        // Just for a placehodlder for a dictionary - there should be a better way
        dummy = [[NSObject alloc]init];
        
    }
    return self;
}



-(void)deleteItem:(void (^)(KTElement *element))success
          failure:(void (^)(KTElement *element, NSError *error))failure{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    [manager deleteObject:self path:nil parameters:nil
                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                      _isDeleted = YES;
                      if (success) {
                          success(self);
                      }
                      
                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                      if (failure){
                          failure(self,nil);
                      }
                  }];
    
    // TODO: BLOCKS:
    // Wenn Delete OK, dann im Element ein Deleted - Status setzen.
    // Von 'aussen' ein Block weiterleiten lassen und das erfolgreiche Löschen signalisieren lassen
    // Wenn nicht erfolgreich dann ein Alert kommen lassen
    
    
}
/**
 Svaes this current Item
 */
-(void)saveItem:(void (^)(KTElement *))success failure:(void (^)(KTElement *, NSError *))failure{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager putObject:self
                  path:nil parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   if (success) {
                       success(self);
                   }
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                   NSDictionary *userInfo = @{NSLocalizedDescriptionKey:[[response allHeaderFields]objectForKey:@"X-ErrorDescription"]};
                   NSError *outError = [NSError errorWithDomain:@"" code:0 userInfo:userInfo];
                   if (failure) {
                       failure(self,outError);
                   }
               }];
}

/// Reloads the current element form Database
-(void)refresh:(void(^)(KTElement *element))success{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    __block KTElement *mySelf = self;
    
    [manager getObject:self path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"New element: %@",mappingResult.firstObject);
        if (mappingResult.firstObject == mySelf) {
            NSLog(@"classes are equal");
        } else {
            NSLog(@"classes are not equal");
        }
        
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error refreshing element: %@",error.localizedDescription);
    }];
    
}

@end









