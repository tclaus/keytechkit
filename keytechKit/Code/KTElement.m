//
//  simpleItem.m
//  keytech search ios
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import "KTElement.h"
#import "Webservice.h"
#import "KTNotifications.h"
#import "KTLoaderInfo.h"

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
    
    
    
    // Hilfsobjekt, das weitere Eigenschaften nachladen kann durchführt
    KTKeytech* ktManager;
}

NSTimeInterval _thumbnailLoadingTimeout = 4; //* 4 Seconds Timeout for thumbnails

/// Provides a process-wide cache of all Thumbnails
static NSCache* thumbnailCache;

/// Provides a list of currently processing thumbnail loading queues.
static NSMutableSet* thumbnailLoadingQueue;

static NSObject* dummy;



#pragma mark Properties
@synthesize itemStatusHistory = _itemStatusHistory;
@synthesize isStatusHistoryLoaded = _isStatusHistoryLoaded;

@synthesize itemStructureList = _itemStructureList;
@synthesize isStructureListLoaded = _isStructureListLoaded;

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


// Mapping für diese Klasse merken
static RKObjectMapping* _mapping;



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
+(RKObjectMapping*)mapping{
    
    if (_mapping==nil){
        RKObjectManager *manager = [RKObjectManager sharedManager];
        
        _mapping = [RKObjectMapping mappingForClass:[KTElement class]];
        
        [_mapping addAttributeMappingsFromDictionary:@{@"ElementDescription":@"itemDescription",
                                                       @"ElementTypeDisplayName":@"itemDisplayTypeName",
                                                       @"ElementKey":@"itemKey",
                                                       @"ElementName":@"itemName",
                                                       @"ElementStatus":@"itemStatus",
                                                       @"ElementVersion":@"itemVersion",
                                                       @"CreatedAt":@"itemCreatedAt",
                                                       @"CreatedBy":@"itemCreatedBy",
                                                       @"CreatedByLong":@"itemCreatedByLong",
                                                       @"ChangedAt":@"itemChangedAt",
                                                       @"ChangedBy":@"itemChangedBy",
                                                       @"ChangedByLong":@"itemChangedByLong",
                                                       @"ThumbnailHint":@"itemThumbnailHint"
                                                       }];
        
        RKMapping *keyValueMapping = [KTKeyValue mapping];
        
        RKRelationshipMapping *KeyalueRelationShip =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"KeyValueList"
                                                    toKeyPath:@"keyValueList"
                                                  withMapping:keyValueMapping];
        
        [_mapping addPropertyMapping:KeyalueRelationShip];
        
        // Zentralisiert ?
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *elementDescriptor = [RKResponseDescriptor
                                                   responseDescriptorWithMapping:_mapping
                                                   method:RKRequestMethodAny
                                                   pathPattern:nil keyPath:@"ElementList" statusCodes:statusCodes];
        
        // Path Argument
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElement class]
                                           pathPattern:@"/elements/:elementKey"
                                           method:RKRequestMethodGET]] ;
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElement class]
                                           pathPattern:@"/elements"
                                           method:RKRequestMethodPOST]] ;
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTElement class]
                                           pathPattern:@"/elements/:elementKey"
                                           method:RKRequestMethodPUT]] ;
        
        
        [manager addResponseDescriptorsFromArray:@[ elementDescriptor ]];
    }
    
    return _mapping;
}




#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
//Multiplattform supportet. Returns thumnail or classicon. Whatever ist implemented
-(NSImage*)itemThumbnail{
    
    if (_isItemThumnailLoaded &! _isItemThumbnailLoading){
        return _itemThumbnail;
        
    }else
        
        if (!_isItemThumbnailLoading){
            _isItemThumbnailLoading = YES;
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
        _isItemThumbnailLoading = YES;
        [self loadItemThumbnail];
        //[self performSelectorInBackground:@selector(loadItemThumbnail) withObject:nil];
        return _itemThumbnail;
    }
}
#endif


-(NSMutableArray*)itemWhereUsedList{
    if (_isWhereUsedListLoaded &!_isItemWhereUsedListLoading){
        return _itemWhereUsedList;
    }else {
        _isItemWhereUsedListLoading = YES;
        [ktManager performGetElementWhereUsed:self.itemKey loaderDelegate:self];
        return _itemWhereUsedList;
    }
}

// Returns the current list or queries a new one.
-(NSMutableArray*)itemNextAvailableStatusList{
    if (_isNextAvailableStatusListLoaded &!_isItemNextStatesListLoading){
        return _itemNextAvailableStatusList;
    }else {
        
        _isItemNextStatesListLoading = YES;
        // Starts the query and returns the current (empty) list
        [ktManager performGetElementNextAvailableStatus:self.itemKey loaderDelegate:self];
        return _itemNextAvailableStatusList;
    }
}

-(NSMutableArray*)itemStatusHistory{
    if (_isStatusHistoryLoaded &!_isStatusHistoryLoading){
        return _itemStatusHistory;
    }else{
        
        _isStatusHistoryLoading = YES;
        // Return preparied (empty) array but perform fill the list
        [ktManager performGetElementStatusHistory:self.itemKey loaderDelegate:self];
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
        _isItemBomListLoading = YES;
        [ktManager performGetElementBom:self.itemKey loaderDelegate:self];
        return _itemBomList;
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
        _isStructureLoading = YES;
        [ktManager performGetElementStructure:self.itemKey loaderDelegate:self];
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
    if ([loaderInfo.ressourcePath hasSuffix:@"statushistory"])
        _isStatusHistoryLoading = NO;
    
    if ([loaderInfo.ressourcePath hasSuffix:@"nextstatus"])
        _isItemNextStatesListLoading = NO;
    
    if ([loaderInfo.ressourcePath hasSuffix:@"structure"])
        _isStructureLoading = NO;
    
    if ([loaderInfo.ressourcePath hasSuffix:@"files"])
        _isItemFileslistLoading = NO;
    
    if ([loaderInfo.ressourcePath hasSuffix:@"notes"])
        _isItemNotesListLoading = NO;
    
    if ([loaderInfo.ressourcePath hasSuffix:@"whereused"])
        _isItemWhereUsedListLoading = NO;
    
    if ([loaderInfo.ressourcePath hasSuffix:@"bom"])
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
            [_itemStructureList setArray:searchResult];
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



/// Resets the thumbnail-cache for this Element
-(void)resetThumbnail{
    
    if(![thumbnailCache objectForKey:self.itemThumbnailHint]){
        [thumbnailCache removeObjectForKey:self.itemThumbnailHint];
        
    }
    
    
}

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
            [self didChangeValueForKey:@"itemThumbnail"]; //Start KVC
            
            return;
        }
        
        // Nicht im cache vorhanden; lade dann neu.
        
        
        // Another load process my be in queue. Test this and let this thread wait a bit
        if (!thumbnailLoadingQueue)
            thumbnailLoadingQueue = [[NSMutableSet alloc]init];
        
        if ([thumbnailLoadingQueue containsObject:thumbnailKey]) {
            
            // Load is in progress. wait as long as the Object in queued
            NSDate *startDate = [NSDate date];
            while ([thumbnailLoadingQueue containsObject:thumbnailKey]) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
                if ([[NSDate date] timeIntervalSinceDate:startDate] > _thumbnailLoadingTimeout) {
                    // NSLog(@"*** Time out for loading thumnail for %@ after %f seconds...", thumbnailKey, _thumbnailLoadingTimeout);
                    _isItemThumbnailLoading = NO;
                    _isItemThumnailLoaded = NO;
                    
                    // Remove the queue flag
                    [thumbnailLoadingQueue removeObject:self.itemThumbnailHint];
                    return;
                    //TODO: What to do if no thumbnail cound be loaded?
                }
            }
            
            // Some other proces has loaded my requesed thumbnail
            _isItemThumnailLoaded = YES;
            _isItemThumbnailLoading = NO;
            
            // Returning the now cached thumbnail
            [self willChangeValueForKey:@"itemThumbnail"]; //Signaling KVC that value has changed
            _itemThumbnail = [thumbnailCache objectForKey:thumbnailKey];
            [self didChangeValueForKey:@"itemThumbnail"]; //
            return; // Queue ended valueshould
            
        }
        
        // Add current Object to Wait-For-Load queue
        [thumbnailLoadingQueue addObject:thumbnailKey];
        
        NSString *resource = [NSString stringWithFormat:@"/elements/%@/thumbnail", self.itemKey];
        NSMutableURLRequest *request = [[RKObjectManager sharedManager].HTTPClient requestWithMethod:@"GET" path:resource parameters:nil ];
        
        NSURLSession *defaultSession = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask *dataTask =
        [defaultSession downloadTaskWithRequest:request
                              completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                  NSLog(@" Data received");
                                  
                                  
                                  [self willChangeValueForKey:@"itemThumbnail"]; //Start KVC
                                  
#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
                                  _itemThumbnail = [[NSImage alloc] initWithContentsOfURL:location];
                                  
#else
                                  _itemThumbnail = [[UIImage alloc]initWithContentsOfURL:location];
                                  
#endif
                                  _isItemThumnailLoaded = YES;
                                  _isItemThumbnailLoading = NO;
                                  
                                  if(_itemThumbnail) {  // might be NIL if server did not respond
                                      [thumbnailCache setObject:_itemThumbnail forKey:thumbnailKey];
                                  }
                                  // Remove hint from download-queue
                                  if ([thumbnailLoadingQueue containsObject:thumbnailKey]) {
                                      [thumbnailLoadingQueue removeObject:thumbnailKey];
                                  }
                                  
                                  
                                  [self didChangeValueForKey:@"itemThumbnail"];
                                  
                              }];
        
        
        [dataTask resume];
        
        
    }
    
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
        
        // Pre allocate some mutables arrays to support lazy loading
        
        ktManager= [[KTKeytech alloc]init];
        _itemStatusHistory = [[NSMutableArray alloc]init];
        _itemStructureList = [[NSMutableArray alloc]init];
        _itemFilesList = [[[NSMutableArray alloc]init]init];
        _itemNotesList = [[NSMutableArray alloc]init];
        _itemNextAvailableStatusList = [[NSMutableArray alloc]init];
        _itemWhereUsedList = [[NSMutableArray alloc]init];
        _itemBomList = [[NSMutableArray alloc]init];
        
        // Just for a placehodlder for a dictionaly - there should be a better way
        dummy = [[NSObject alloc]init];
        
    }
    return self;
}


@end
