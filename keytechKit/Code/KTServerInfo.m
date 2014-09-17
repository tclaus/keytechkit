//
//  KTServerInfo.m
//  keytechKit
//
//  Created by Thorsten Claus on 13.05.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTServerInfo.h"
#import "KTKeyValue.h"

@implementation KTServerInfo{

}
    static KTServerInfo *_serverInfo;

@synthesize keyValueList = _keyValueList;

// Mapping for Class
static RKObjectMapping *_mapping;
static RKObjectManager *_usedManager;

static KTServerInfo *_sharedServerInfo;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [KTServerInfo mappingWithManager:[RKObjectManager sharedManager]];
        _isLoaded = YES;
        _isloading = NO;
    }
    return self;
}

/// Creates a shared instance and loads Data
+(instancetype)sharedServerInfo{
    if (!_sharedServerInfo) {
        _sharedServerInfo = [[KTServerInfo alloc]init];
        [_sharedServerInfo reload];
    }
    return _sharedServerInfo;
}

// Sets the Object mapping for JSON
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
       
        
        RKObjectMapping *kvMapping = [RKObjectMapping mappingForClass:[KTKeyValue class]];
        [kvMapping addAttributeMappingsFromDictionary:@{@"Key":@"key",
                                                       @"Value":@"value"}];
       
         _mapping = [RKObjectMapping mappingForClass:[self class]];
        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ServerInfoResult" toKeyPath:@"keyValueList" withMapping:kvMapping]];
        /*
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"ServerInfoResult"
                                                    toKeyPath:@"keyValueList"
                                                  withMapping:kvMapping];
        */
        
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *serverInfoDescriptor = [RKResponseDescriptor
                                                      responseDescriptorWithMapping:_mapping
                                                      method:RKRequestMethodAny
                                                      pathPattern:@"serverinfo"
                                                      keyPath:nil
                                                      statusCodes:statusCodes];
        
        
        [_usedManager addResponseDescriptorsFromArray:@[ serverInfoDescriptor ]];
        
        
    }
    
    return _mapping;
}

BOOL _isloading;
BOOL _isLoaded;


/// Loads the serverinfo in background
-(void)reload{
    if (!_isloading) {
        _isLoaded = NO;
        _isloading = YES;
    
        RKObjectManager *manager = [RKObjectManager sharedManager];
        [KTServerInfo mappingWithManager:manager];
        
        
        [manager getObject:nil path:@"serverinfo" parameters:nil
                   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       KTServerInfo *serverInfo = mappingResult.firstObject;
                       _keyValueList = [serverInfo.keyValueList mutableCopy];
                       _isLoaded = YES;
                       _isloading = NO;
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       NSLog(@"Error while getting the API version: %@",error.localizedDescription);
                       _isLoaded = NO;
                       _isloading = NO;
                   }];

        
        [self waitUnitlLoad];
    }
    
    
}

/// Wait until request comnples
/// No async here, case the values matters
-(void)waitUnitlLoad{
    // Do some polling to wait for the connections to complete
#define POLL_INTERVAL 0.2 // 200ms
#define N_SEC_TO_POLL 30.0 // poll for 30s
#define MAX_POLL_COUNT N_SEC_TO_POLL / POLL_INTERVAL
    
    if (!_isloading && !_isLoaded) {
        // Load was not triggered
        return;
    }
    
    NSUInteger pollCount = 0;
    while (_isloading && (pollCount < MAX_POLL_COUNT)) {
        NSDate* untilDate = [NSDate dateWithTimeIntervalSinceNow:POLL_INTERVAL];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
        pollCount++;
    }
    
    if (pollCount== MAX_POLL_COUNT) {
        NSLog(@"Loading Error!");
    }
    
}

/// Extract the values from the key value list
-(id)valueForKey:(NSString *)key{
    
    for (KTKeyValue *kv in self.keyValueList) {
        if ([kv.key isEqualToString:key]) {
            return kv.value;
        }
    }
    return nil;
}

+(instancetype)serverInfo{
    if (!_serverInfo) {
        _serverInfo = [[KTServerInfo alloc]init];
        [_serverInfo reload];
    }
    return _serverInfo;
}

-(NSString*)serverID{
    [self waitUnitlLoad];

    return [self valueForKey:@"ServerID"];
}

-(NSString *)APIKernelVersion{
        [self waitUnitlLoad];
    return [self valueForKey:@"keytech version"];
}

-(NSString *)APIVersion{
    [self waitUnitlLoad];
    return [self valueForKey:@"API version"];
}

-(NSString *)licencedCompany{
    [self waitUnitlLoad];
    return [self valueForKey:@"LicensedCompany"];
}

@end
