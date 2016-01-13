//
//  KTElement
//  keytech search ios
//
//  Created by Thorsten Claus on 07.08.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//


#import "KTManager.h"
#import "KTNotifications.h"
#import "KTElement.h"
#import "KTClass.h"
#import "KTSendNotifications.h"
#import "KTBomItem.h"
#import "KTBaseObject.h"
#import "KTLicenseData.h"

@interface KTElement()

@end

@implementation KTElement{
@private
    
    /// Notifies about loading in process
    BOOL _isStatusHistoryLoading;
    
    BOOL _isStructureListLoaded;
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
    /// Noti
    BOOL _isItemStructureListLoading;
    
    /// Notifies is load is in progress
    BOOL _isItemVersionListLoading;
    
    
    NSMutableArray *_itemStructureList;
    NSMutableArray *_itemBomList;
    NSMutableArray *_itemWhereUsedList;
    NSMutableArray *_itemStatusHistory;
    NSMutableArray *_itemNotesList;
    NSMutableArray *_itemVersionsList;
    NSMutableArray *_itemFilesList;
    
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

/// The maximum number of items to be returned in one query
int maxPagesize=500;


#pragma mark Properties

@synthesize isStatusHistoryLoaded = _isStatusHistoryLoaded;

@synthesize isVersionListLoaded = _isVersionListLoaded;

@synthesize isFilesListLoaded = _isFilesListLoaded;

@synthesize isBomListLoaded = _isBomListLoaded;

@synthesize isNotesListLoaded =_isNotesListLoaded;

@synthesize itemThumbnail = _itemThumbnail;
//Sonderfall

@synthesize isStructureListLoaded = _isStructureListLoaded;

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

-(void)setItemKey:(NSString *)itemKey{
    
    // change any % - classtypes to 'default'
    _itemKey = [KTBaseObject normalizeElementKey:itemKey];
    
}

-(void)setItemClassKey:(NSString *)itemClassKey{
    // Will fail if assigned to a already full Element
    assert(self.itemID == -1);
    
    self.itemKey = itemClassKey;
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
                                                       @"ReleasedAt":@"itemReleasedAt",
                                                       @"ReleasedBy":@"itemReleasedBy",
                                                       @"ReleasedbyLong":@"itemReleasedByLong",
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
        RKResponseDescriptor *responseGETDescriptor = [RKResponseDescriptor
                                                    responseDescriptorWithMapping:_mapping
                                                    method:RKRequestMethodGET
                                                    pathPattern:nil
                                                    keyPath:@"ElementList"
                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        

        RKResponseDescriptor *responsePOSTDescriptor = [RKResponseDescriptor
                                                       responseDescriptorWithMapping:_mapping
                                                       method:RKRequestMethodPOST | RKRequestMethodPUT
                                                       pathPattern:nil
                                                       keyPath:nil
                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        

        // Only for Searches with Solr
        RKResponseDescriptor *responseDescriptorSearchEngine = [RKResponseDescriptor
                                                    responseDescriptorWithMapping:_mapping
                                                    method:RKRequestMethodGET
                                                    pathPattern:nil
                                                    keyPath:@"Element"
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
        

        [manager addResponseDescriptorsFromArray:@[ responseGETDescriptor,responsePOSTDescriptor, responseDescriptorSearchEngine ]]; // GET
        [manager addRequestDescriptor:elementRequestDescriptor]; // POST, PUT        
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


-(NSArray*)itemWhereUsedList{
    
    return _itemWhereUsedList;
}



-(NSArray*)itemStatusHistory{
    return [NSArray arrayWithArray:_itemStatusHistory];
}

/**
 Returns the BOM list. Load bom with the load selector
 */
-(NSArray*)itemBomList{
    return [NSArray arrayWithArray:_itemBomList];
}

/**
 Performs a load of Versionslist - if hasVersion is True
 */
-(NSArray *)itemVersionsList{
    
    return [NSArray arrayWithArray:_itemVersionsList];
    
}

-(BOOL)isEqual:(id)object{
    if ([object class] == [KTElement class]) {
        return [super isEqual:object];
    }
    if ([object class] == [NSString class]) {
        return [((NSString*)object) isEqualToString:self.itemKey];
    }
    
    return NO;
}

-(void)removeLinkTo:(NSString *)linkToElementKey success:(void(^)(void))success failure:(void(^)(NSError* error))failure{
    
    KTElementLink *newLink = [[KTElementLink alloc]initWithParent:self.itemKey childKey:linkToElementKey];
    [newLink deleteLink:^{
        
        if (_isStructureListLoaded) {
            [_itemStructureList removeObject:linkToElementKey];
        }
        
        [[KTSendNotifications sharedSendNotification] sendElementChildLinkRemoved:linkToElementKey removedFromFolder:self.itemName];
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

-(void)addLinkTo:(NSString *)linkToElementKey success:(void (^)(KTElement *elementLink))success failure:(void (^)(NSError * error))failure{
    
    KTElementLink *newLink = [[KTElementLink alloc]initWithParent:self.itemKey childKey:linkToElementKey];
    [newLink saveLink:^(KTElement *childElement) {
        
        if (_isStructureListLoaded) {
            [_itemStructureList addObject:childElement]; // Der Struktur hinzufügen
        }
        
        [[KTSendNotifications sharedSendNotification] sendElementHasNewChildLink:linkToElementKey addedtoFolder:self.itemName];
        
        if (success) {
            success(childElement);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
    
    
}


NSMutableDictionary *_lastPages;

-(void)setPageDefinitionForResource:(NSString*)resourcePath PageDefinition:(PageDefinition)pageDefinition{
    
    if (!_lastPages) {
        _lastPages = [NSMutableDictionary dictionary];
    }
    
    NSValue *value = [NSValue valueWithBytes:&pageDefinition objCType:@encode(PageDefinition)];
    [_lastPages setObject:value forKey:resourcePath];
    
}

-(PageDefinition)pageDefinitionForResource:(NSString*)resourcePath
{
    if (!_lastPages) {
        _lastPages = [NSMutableDictionary dictionary];
    }
    
    
    PageDefinition structValue;
    NSValue *value = [_lastPages objectForKey:resourcePath];
    [value getValue:&structValue];
    
    return structValue;
    
}

-(void)loadDataToArray:(NSMutableArray*)targetArray
           resoucePath:(NSString*)resourcePath
              fromPage:(int)page
              withSize:(int)size
               success:(void (^)(NSArray *itemsList))success
               failure:(void (^)(NSError *error))failure

{
    
    
    if (page==0) {
        page=1;
    }
    
    if (size==0) {
        size=maxPagesize;
    }
    
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    rpcData[@"page"] = @((int)page);
    rpcData[@"size"] = @((int)size);
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager getObjectsAtPath:resourcePath parameters:rpcData
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          PageDefinition pageDefinition = [self pageDefinitionForResource:resourcePath];
                          
                          // add new arrays in a sequence
                          if (pageDefinition.page != page-1 || pageDefinition.size != size) {
                              [targetArray removeAllObjects];
                          }
                          
                          pageDefinition.size = size;
                          pageDefinition.page = page;
                          
                          [self setPageDefinitionForResource:resourcePath PageDefinition:pageDefinition];
                          
                          [targetArray addObjectsFromArray:mappingResult.array];
                          
                          if (success) {
                              success(targetArray);
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          
                          NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                          
                          if (failure) {
                              failure(transcodedError);
                          }
                          
                      }];
    
}

/// Returns the current list of child elements
-(NSArray*)itemStructureList{
    return _itemStructureList;
}

// Returns the current list or queries a new one.
-(NSMutableArray*)itemNextAvailableStatusList{
    return _itemNextAvailableStatusList;
}

/// Loads next available statuslist
-(void)loadNextAvailableStatusListSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSString *elementKey = [KTBaseObject normalizeElementKey:self.itemKey];
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/nextstatus",elementKey];
    
    [self loadDataToArray:_itemNextAvailableStatusList
              resoucePath:resourcePath
                 fromPage:0
                 withSize:0
                  success:^(NSArray *itemsList) {
                      _isNextAvailableStatusListLoaded = YES;
                      if (success) {
                          success(itemsList);
                      }
                  }
                  failure:failure];
    
}

-(void)loadWhereUsedListPage:(int)page
                    withSize:(int)size
                     success:(void (^)(NSArray *))success
                     failure:(void (^)(NSError *))failure
{
    
    NSString *elementKey = [KTBaseObject normalizeElementKey:self.itemKey];
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/whereused",elementKey];
    
    [self loadDataToArray:_itemWhereUsedList
              resoucePath:resourcePath
                 fromPage:page
                 withSize:size
                  success:^(NSArray *itemsList) {
                      _isWhereUsedListLoaded = YES;
                      if (success) {
                          success(itemsList);
                      }
                  }
                  failure:failure];
}

/**
 Loads the structure with the given page and pagesize. Every query adds the structure list to the internal array.
 */
-(void)loadStatusHistoryListSuccess:(void(^)(NSArray* itemsList))success
                            failure:(void(^)(NSError *error))failure
{
    
    NSString *elementKey = [KTBaseObject normalizeElementKey:self.itemKey];
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/statushistory",elementKey];

    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTStatusHistoryItem mappingWithManager:manager];
    
    [self loadDataToArray:_itemStatusHistory
              resoucePath:resourcePath
                 fromPage:0
                 withSize:0
                  success:^(NSArray *itemsList) {
                      _isStatusHistoryLoaded = YES;
                      if (success) {
                          success(itemsList);
                      }
                  } failure:failure];
}


-(void)loadNotesListSuccess:(void(^)(NSArray* itemsList))success
                    failure:(void(^)(NSError *error))failure
{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTNoteItem mappingWithManager:manager];
    
    NSString *elementKey = [KTBaseObject normalizeElementKey:self.itemKey];
    
    NSString *resourcePath = [NSString stringWithFormat:@"elements/%@/notes", elementKey];
    [self loadDataToArray:_itemNotesList
              resoucePath:resourcePath
                 fromPage:0
                 withSize:0
                  success:^(NSArray *itemsList) {
                      _isNotesListLoaded = YES;
                      if (success) {
                          success(itemsList);
                      }
                  }
                  failure:failure];
    
}

/**
 Loads the structure with the given page and pagesize. Every query adds the structure list to the internal array.
 */
-(void)loadStructureListPage:(int)page
                    withSize:(int)size
                     success:(void(^)(NSArray* itemsList))success
                     failure:(void(^)(NSError *error))failure
{
    
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/structure",self.itemKey];
    
    [self loadDataToArray:_itemStructureList
              resoucePath:resourcePath
                 fromPage:page
                 withSize:size
                  success:^(NSArray *itemsList) {
                      _isStructureListLoaded = YES;
                      if (success) {
                          success(itemsList);
                      }
                  } failure:failure];
    
}

-(void)loadBomListPage:(int)page
              withSize:(int)size
               success:(void(^)(NSArray* itemsList))success
               failure:(void(^)(NSError *error))failure
{
    
    [KTBomItem mappingWithManager:[RKObjectManager sharedManager]];
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/bom",self.itemKey];
    
    [self loadDataToArray:_itemBomList
              resoucePath:resourcePath
                 fromPage:page
                 withSize:size
                  success:^(NSArray *itemsList) {
                      _isBomListLoaded = YES;
                      if (success) {
                          success(itemsList);
                      }
                  }

                  failure:failure];
    
}

-(void)loadFileListSuccess:(void(^)(NSArray* itemsList))success
                   failure:(void(^)(NSError *error))failure
{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTFileInfo mappingWithManager:manager];
    
    NSString *elementKey = [KTBaseObject normalizeElementKey:self.itemKey];
    
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/files", elementKey];
    [self loadDataToArray:_itemFilesList
              resoucePath:resourcePath
                 fromPage:0
                 withSize:0
                  success:^(NSArray *itemArray) {
                      _isFilesListLoaded = YES;
                      [itemArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                          KTFileInfo *fileInfo = (KTFileInfo*)obj;
                          fileInfo.elementKey = self.itemKey;
                      }];
                      
                      if(success){
                          success(itemArray);
                      }
                  }
                  failure:failure];
    
}

/// Loads all Versions of this element
-(void)loadVersionListSuccess:(void(^)(NSArray* itemsList))success
                      failure:(void(^)(NSError *error))failure
{
    
    NSString *elementKey = [KTBaseObject normalizeElementKey:self.itemKey];
    
    NSString* resourcePath = [NSString stringWithFormat:@"elements/%@/versions",elementKey];
    [self loadDataToArray:_itemVersionsList
              resoucePath:resourcePath
                 fromPage:0
                 withSize:0
                  success:^(NSArray *itemsList) {
                      _isVersionListLoaded = YES;
                      if (success) {
                          success(itemsList);
                      }
                  }
                  failure:failure];
    
}



-(KTFileInfo*)masterFile{
    if (_isFilesListLoaded) {
        for (KTFileInfo *fileInfo in self.itemFilesList) {
            if (fileInfo.fileStorageType ==FileTypeMaster) {
                return fileInfo;
            }
        }
    }
    return nil;
}

// Return current filelist or requests a new one from server
-(NSMutableArray*)itemFilesList{
    
    return _itemFilesList;
}

// Return current notes list or requests a new one from server.
-(NSMutableArray*)itemNotesList{
    
    return _itemNotesList;
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
        
        NSString *resource = [NSString stringWithFormat:@"elements/%@/preview", self.itemKey];
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


- (void)removeThumbnailKeyFromQueue:(NSObject <NSCopying> *)thumbnailKey
{
    dispatch_barrier_async(_barrierQueue, ^
                           {
                               [thumbnailLoadingQueue removeObject:thumbnailKey];
                           });
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


-(BOOL)isReserved{
    if ([self.itemClassType isEqualToString:@"DO"]) {
        NSString *reservedBy =  [self valueForAttribute:@"as_do__reserved"];
        if (!reservedBy) {
            return NO; // unknown, advanced information
        } else {
            //TODO: need to swap from short name to fullname
            return YES;
        }
    }
    return NO;
}

-(void)setIsReserved:(BOOL)isReserved{
    //TODO: SetIsReserverd
}

-(NSString *)isReservedBy{
    // My return nil
    return [self valueForAttribute:@"as_do__reserved"];
}


/*
 Gibt die erweiterte Liste der Eigenschaften zurück
 */
-(NSMutableArray*)keyValueList{
    if (!_keyValueList) {
        _keyValueList = [NSMutableArray array];
    }
    return _keyValueList;
}

/// Returns a value for the specific attribute
-(id)valueForAttribute:(NSString*)attribute{
    for (KTKeyValue *kvPair in self.keyValueList) {
        if ([kvPair.key isEqualToString:attribute]) {
            
            // If string - and only 1 space then the string is empty
            // If date type and date is 1.1.1970 then there is no date really
            
            
            return kvPair.value;
        }
    }
    return nil;
}

/// Sets a Value for the attributename
-(void)setValueForAttribute:(id <NSCopying>)value attribute:(NSString*)attribute{
    for (KTKeyValue *kvPair in self.keyValueList) {
        if ([kvPair.key isEqualToString:attribute]) {
            kvPair.value = [value copyWithZone:nil];
            return;
        }
    }
    KTKeyValue *keyValue = [[KTKeyValue alloc]init];
    keyValue.key = attribute;
    keyValue.value = [value copyWithZone:nil];
    
    [self.keyValueList addObject:keyValue];
    
}

-(id)valueForUndefinedKey:(NSString *)key{
    return @"";
}

//Helps debugging output
-(NSString*)description{
    return [NSString stringWithFormat:@"item: %@",[self itemName]];
}

-(NSString *)debugDescription{
    return [NSString stringWithFormat:@"Key: %@, Description: %@",self.itemKey,self.itemDescription];
}

// Return full qualified FileID
-(NSString *)fileURLOfFileID:(int)fileID{
    
    
    NSString* fileURL = [NSString stringWithFormat:@"/elements/%@/files/%d",self.itemKey, fileID];
    return fileURL;
}

+(instancetype)elementWithElementKey:(NSString *)elementKey{
    KTElement *element = [[KTElement alloc]initWithElementKey:elementKey];
    return element;
    
}

-(instancetype)initWithElementKey:(NSString*)elementKey{
    
    KTElement *element=[self init];
    [element setItemKey:[elementKey copy]];
    return element;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [KTElement mappingWithManager:[RKObjectManager sharedManager]];
        
        numberOfThumbnailsLoaded = 0;
        // Pre allocate some mutables arrays to support lazy loading
        
        _itemStatusHistory = [[NSMutableArray alloc]init];
        _itemStructureList = [[NSMutableArray alloc]init];
        _itemFilesList = [[[NSMutableArray alloc]init]init];
        _itemNotesList = [[NSMutableArray alloc]init];
        _itemNextAvailableStatusList = [[NSMutableArray alloc]init];
        _itemWhereUsedList = [[NSMutableArray alloc]init];
        _itemBomList = [[NSMutableArray alloc]init];
        _itemVersionsList = [[NSMutableArray alloc]init];
        
        _itemReleasedBy = @"";
        _itemReleasedByLong = @"";

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
    [KTElement mappingWithManager:manager];
    
    
    [manager deleteObject:self path:nil parameters:nil
                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                      _isDeleted = YES;
                      [[KTSendNotifications sharedSendNotification]sendElementHasBeenDeleted:self];
                      
                      if (success) {
                          success(self);
                      }
                      
                  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     
                      NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                      
                      if (failure) {
                          failure(self,transcodedError);
                      }
                      
                  }];
    
    // TODO: BLOCKS:
    // Wenn Delete OK, dann im Element ein Deleted - Status setzen.
    // Von 'aussen' ein Block weiterleiten lassen und das erfolgreiche Löschen signalisieren lassen
    // Wenn nicht erfolgreich dann ein Alert kommen lassen
    
    
}
/**
 Saves this current Item
 */
-(void)saveItem:(void (^)(KTElement *))success failure:(void (^)(NSError *error))failure{

    if (![KTLicenseData sharedLicenseData].isValidLicense) {
        NSError *error = [KTLicenseData sharedLicenseData].licenseError;
        if (failure) {
            failure(error);
        }
        return;
    }
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // Make sure a mapping is set
    [KTElement mappingWithManager:manager];
    
    if (self.itemID == -1) {
        // POST, create a new element
        [manager postObject:self
                       path:nil
                 parameters:nil
                    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        // Refresh the current Element with Data from API.
                        // API may has changed or added some valued
                        NSHTTPURLResponse *response = [operation HTTPRequestOperation].response;
                        self.itemKey = [response.allHeaderFields objectForKey:@"Location"];
                        
                        // Element was created (Send a notification?)
                        // Who should get the notification?
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ElementDidCreate" object:self];
                        if (success) {
                            success(self);
                        }
                        
                    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                        NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                        
                        if (failure) {
                            failure(transcodedError);
                        }
                    }];
        
    } else { // PUT
        
        [manager putObject:self
                      path:nil parameters:nil
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       
                       [[KTSendNotifications sharedSendNotification]sendElementHasBeenChanged:self];

                       // Who should get the notification?
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"ElementDidChange" object:self];
                       
                       if (success) {
                           success(self);
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                       
                       if (failure) {
                           failure(transcodedError);
                       }
                   }];
    }
    
}

+(void)loadElementWithKey:(NSString *)elementKey success:(void (^)(KTElement *theElement))success failure:(void(^)(NSError *error))failure{
    [KTElement loadElementWithKey:elementKey withMetaData:KTResponseNoneAttributes
                          success:^(KTElement *theElement) {
                              success(theElement);
                          } failure:^(NSError *error) {
                              if (failure) {
                                  failure(error);
                              }
                              
                          }];
}

+(void)loadElementWithKey:(NSString *)elementKey withMetaData:(KTResponseAttributes)metadata
                  success:(void (^)(KTElement *theElement))success
                  failure:(void(^)(NSError *error))failure{
    
    if (![KTLicenseData sharedLicenseData].isValidLicense) {
        NSError *error = [KTLicenseData sharedLicenseData].licenseError;
        if (failure) {
            failure(error);
        }
        return;
    }
    
    [KTElement mappingWithManager:[RKObjectManager sharedManager]];
    KTElement* element = [[KTElement alloc]init];
    
    element.itemKey = elementKey;
    
    [element reload:metadata
            success:^(KTElement *element) {
                if  (success){
                    success(element);
                }
            }
            failure:^(NSError *error){
                if (failure) {
                    failure(error);
                }
            }
     ];
    
}

/// Reloads the current element form Database with no extra attributes
-(void)reload:(void(^)(KTElement *element))success failure:(void (^)(NSError *))failure{
    [self reload:KTResponseNoneAttributes success:success failure:failure];
}


/// Reloads the current element form Database
-(void)reload:(KTResponseAttributes)metadata success:(void(^)(KTElement *element))success failure:(void (^)(NSError *))failure{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    
    NSMutableDictionary *rpcData = [[NSMutableDictionary alloc] init ];
    
    // Elementlist
    switch (metadata) {
        case KTResponseNoneAttributes:
            // No special treatment
            break;
        case KTResponseFullAttributes:
            rpcData[@"attributes"] = @"ALL";
            break;
        case KTResponseEditorAttributes:
            rpcData[@"attributes"] = @"Editor";
            break;
        case KTResponseListerAttributes:
            rpcData[@"attributes"] = @"Lister";
            break;
        default:
            break;
    }
    
    _isBomListLoaded = NO;
    _isFilesListLoaded = NO;
    _isItemThumnailLoaded = NO;
    _isNextAvailableStatusListLoaded = NO;
    _isNotesListLoaded = NO;
    _isStatusHistoryLoaded = NO;
    _isStructureListLoaded = NO;
    _isVersionListLoaded = NO;
    _isWhereUsedListLoaded = NO;
    
    
    if (![KTLicenseData sharedLicenseData].isValidLicense) {
        NSError *error = [KTLicenseData sharedLicenseData].licenseError;
        if (failure) {
            failure(error);
        }
        return;
    }
    
    [manager getObject:self path:nil parameters:rpcData success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        

        
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
        
        if (failure) {
            failure(transcodedError);
        }
    }];
    
}

/// Moves to a new class
-(void)moveToClass:(NSString *)targetClassKey success:(void (^)(NSString *))success failure:(void (^)(NSError *error))failure
{
    /*
     Move Action: 
     {"MoveTo":<targetClassKey>}
     
     
     */
    NSString *baseURL =[[KTManager sharedManager].baseURL absoluteString];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@elements/%@",baseURL, self.itemKey]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [[KTManager sharedManager] setDefaultHeadersToRequest:urlRequest];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *jsonDictionary = @{@"MoveTo": targetClassKey};
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:kNilOptions error:&error];
    
    urlRequest.HTTPBody = jsonData;
    
    KTElement *theElement;
    theElement = self;
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                               if (!connectionError){
                                  
                                   if (httpResponse.statusCode>=400) {
                                       if (failure) {
                                           NSError *error = [NSError errorWithDomain:@"keytech" code:100
                                                                            userInfo:@{NSLocalizedDescriptionKey: @"Server has no 'move' implementation."}];
                                           failure(error);
                                           return;
                                       }
                                   } else {
                                       
                                       NSString *location =  [httpResponse allHeaderFields][@"Location"];
                                       
                                       // set the new location key after move
                                       theElement.itemKey = location;
                                       
                                       if (success){
                                           success(location);
                                       }
                                   }
                                   
                               } else {
                                    NSError *transcodedError = [KTManager translateErrorFromResponse:httpResponse error:connectionError];
                                   if (failure){

                                       failure(transcodedError);
                                   }
                               }
                           }];
    

    
}

-(void)setReserveStatus:(BOOL)newReserveStatus success:(void (^)(void))success failure:(void (^)(NSError *))failure {
    // {"ElementReserveAction" :{
    //    "ReserveElement": true,
    //    "UnreserveElement":true' }}
    
    
    NSString *baseURL =[[KTManager sharedManager].baseURL absoluteString];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@elements/%@",baseURL, self.itemKey]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [[KTManager sharedManager] setDefaultHeadersToRequest:urlRequest];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSError *error;
    NSDictionary *jsonDictionary;
    
    if (newReserveStatus == true) {
        // Reservieren
        jsonDictionary = @{@"ElementReserveAction":@{@"ReserveElement":@YES}};
    } else {
        // Entreservieren
        jsonDictionary = @{@"ElementReserveAction":@{@"UnreserveElement":@YES}};
    }
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:kNilOptions error:&error];
    
    urlRequest.HTTPBody = jsonData;
    
    KTElement *theElement;
    theElement = self;
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                               if (!connectionError){
                                   
                                   if (httpResponse.statusCode>=400) {

                                       if (failure) {
                                           NSError *error = [NSError errorWithDomain:@"keytech" code:100
                                                                            userInfo:@{NSLocalizedDescriptionKey: @"Server has no 'move' implementation."}];
                                           failure(error);
                                           return;
                                       }
                                   } else {
                                       
                                       NSString *location =  [httpResponse allHeaderFields][@"Location"];
                                       
                                       // set the new location key after move
                                       theElement.itemKey = location;
                                       
                                       if (success){
                                           success();
                                       }
                                   }
                                   
                               } else {
                                   if (failure){
                                       NSError *transcodedError = [KTManager translateErrorFromResponse:httpResponse error:connectionError];
                                       
                                       failure(transcodedError);
                                   }
                               }
                           }];
    
}


@end









