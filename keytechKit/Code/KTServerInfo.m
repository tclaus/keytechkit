//
//  KTServerInfo.m
//  keytechKit
//
//  Created by Thorsten Claus on 13.05.14.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTServerInfo.h"
#import "KTKeyValue.h"
#import "KTManager.h"

@implementation KTServerInfo

static KTServerInfo *_serverInfo;

@synthesize isLoaded = _isLoaded;
@synthesize isLoading =_isLoading;

@synthesize keyValueList = _keyValueList;

// Mapping for class
static RKObjectMapping *_mapping;
static RKObjectManager *_usedManager;

static KTServerInfo *_sharedServerInfo;

- (instancetype)init {
    self = [super init];
    if (self) {
        [KTServerInfo mappingWithManager:[RKObjectManager sharedManager]];
        _isLoaded = NO;
        _isLoading = NO;
        _keyValueList = [NSMutableArray array];
    }
    return self;
}

/// Creates a shared instance and loads Data
+(instancetype)sharedServerInfo {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedServerInfo = [[KTServerInfo alloc]init];
    });
    
    return _sharedServerInfo;
}

// Sets the Object mapping for JSON
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager {
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        RKObjectMapping *kvMapping = [RKObjectMapping mappingForClass:[KTKeyValue class]];
        [kvMapping addAttributeMappingsFromDictionary:@{@"Key":@"key",
                                                        @"Value":@"value"}];
        
        _mapping = [RKObjectMapping mappingForClass:[self class]];
        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ServerInfoResult" toKeyPath:@"_keyValueList" withMapping:kvMapping]];
        /*
         [RKRelationshipMapping relationshipMappingFromKeyPath:@"ServerInfoResult"
         toKeyPath:@"keyValueList"
         withMapping:kvMapping];
         */
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *serverInfoDescriptor = [RKResponseDescriptor
                                                      responseDescriptorWithMapping:kvMapping
                                                      method:RKRequestMethodGET
                                                      pathPattern:nil
                                                      keyPath:@"ServerInfoResult"
                                                      statusCodes:statusCodes];
        
        [_usedManager addResponseDescriptorsFromArray:@[ serverInfoDescriptor ]];
    }
    
    return _mapping;
}

-(void)loadWithSuccess:(void (^)(KTServerInfo *))success
               failure:(void (^)(NSError *))failure {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTServerInfo mappingWithManager:manager];
    
    /*
     if (_isLoading) {
     [self waitUnitlLoad];
     if (success) {
     success(self);
     }
     return;
     }
     */
    
    _isLoading = YES;
    [manager getObject:_sharedServerInfo path:@"serverinfo" parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   [self.keyValueList removeAllObjects];
                   [self.keyValueList addObjectsFromArray:mappingResult.array];
                   
                   // Key Value liste austauschen
                   self->_keyValueList = [NSMutableArray arrayWithArray:mappingResult.array];
                   self->_isLoaded = YES;
                   self->_isLoading = NO;
                   
                   if (success) {
                       success(self);
                   }
                   
               } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   self->_isLoaded = NO;
                   self->_isLoading = NO;
                   NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                   
                   if (failure) {
                       failure(transcodedError);
                   }
               }];
}

/// Loads the serverinfo and waits until return
-(void)reload {
    if (!_isLoading) {
        _isLoaded = NO;
        _isLoading = YES;
        
        RKObjectManager *manager = [RKObjectManager sharedManager];
        [KTServerInfo mappingWithManager:manager];
        
        
        [manager getObject:nil path:@"serverinfo" parameters:nil
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       // Key Value liste austauschen
                       self->_keyValueList = [NSMutableArray arrayWithArray:mappingResult.array];
                       self->_isLoaded = YES;
                       self->_isLoading = NO;
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       self->_isLoaded = NO;
                       self->_isLoading = NO;
                   }];
        [self waitUnitlLoad];
    }
}


/// Wait until request comnples
/// No async here, case the values matters
-(void)waitUnitlLoad {
    // Do some polling to wait for the connections to complete
#define POLL_INTERVAL 0.2 // 200ms
#define N_SEC_TO_POLL 30.0 // poll for 30s
#define MAX_POLL_COUNT N_SEC_TO_POLL / POLL_INTERVAL
    
    if (!_isLoading && !_isLoaded) {
        // Load was not triggered
        return;
    }
    
    NSUInteger pollCount = 0;
    while (_isLoading && (pollCount < MAX_POLL_COUNT)) {
        NSDate* untilDate = [NSDate dateWithTimeIntervalSinceNow:POLL_INTERVAL];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
        pollCount++;
    }
    
    if (pollCount== MAX_POLL_COUNT) {
        NSLog(@"Loading Error!");
    }
}

/**
 Extract the values from the key value list
 @param key The key to retrive it's value
 */
-(id)valueForKey:(NSString *)key {
    
    for (KTKeyValue *kv in self.keyValueList) {
        if ([kv.key compare:key options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return kv.value;
        }
    }
    return nil;
}

/**
 Returns a Boolean value
 @param key The key to retrive it's boolean value
 */
-(BOOL)boolValueForKey:(NSString *)key {
    
    for (KTKeyValue *kv in self.keyValueList) {
        if ([kv.key compare:key options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            
            if ([kv.value compare:@"true" options:NSCaseInsensitiveSearch]==NSOrderedSame){
                return YES;
            };
            
            if ([kv.value compare:@"yes" options:NSCaseInsensitiveSearch]==NSOrderedSame){
                return YES;
            };
            
            if ([kv.value compare:@"1" options:NSCaseInsensitiveSearch]==NSOrderedSame){
                return YES;
            };
            
            return NO;
        }
    }
    
    return NO;
}

+(instancetype)serverInfo {
    return [KTServerInfo sharedServerInfo];
}

-(NSString*)serverID {
    
    return [self valueForKey:@"ServerID"];
}

-(BOOL)isIndexServerEnabled {
    return [self boolValueForKey:@"Supports Index Server"];
}


-(NSString *)databaseVersion {
    return [self valueForKey:@"keytech database version"];
}

-(NSString *)APIVersion {
    return [self valueForKey:@"API version"];
}

-(NSString *)licencedCompany {
    return [self valueForKey:@"LicensedCompany"];
}

-(NSString*)baseURL {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    return manager.baseURL.absoluteString;
}

@end
