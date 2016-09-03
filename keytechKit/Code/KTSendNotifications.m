//
//  KTSendNotifications.m
//  keytechKit
//
//  Created by Thorsten Claus on 06.08.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTSendNotifications.h"
#import "KTManager.h"
#import "KTUser.h"



@interface KTSendNotifications ()


@end

@implementation KTSendNotifications{
    NSString *_hardwareID;
    NSString *_localDeviceLanguage;
    
    /// The device Token for registering
    NSData* _deviceToken;
    
}


static KTSendNotifications *_sharedSendNotification;

// PushWoosh
// https://cp.pushwoosh.com/json/1.3/%methodName%
// Keep it secret !

// URL for PushWoosh service
static NSString* APNURL =@"https://cp.pushwoosh.com/json/1.3/%@";


/// Is the Service enabled? API Token set?
/// If yes - sending notifications is allowed.
static bool ServiceEnabled;

-(void)setAPNAPIToken:(NSString *)APNAPIToken {
    _APNAPIToken = APNAPIToken;
    
    if (_APNAPIToken && _APNApplictionID ) {
        ServiceEnabled = YES;
    } else {
        ServiceEnabled = NO;
    }
    
}

-(void)setAPNApplictionID:(NSString *)APNApplictionID {
    _APNApplictionID = APNApplictionID;
    
    if (_APNAPIToken && _APNApplictionID) {
        ServiceEnabled = YES;
    } else {
        ServiceEnabled = NO;
    }
}

-(void)setDeviceToken:(NSData *)token {
    _deviceToken = [token copy];
}

-(void)setUniqueID:(NSString *)uniqueString {
    _hardwareID = [uniqueString copy];
}


-(void) setupService {
    
    if (ServiceEnabled) {
        
        
        if (self.serverID) {
            if (self.userName) {
                
                if (!self.userNameLong || (self.userNameLong).length == 0) {
                    self.userNameLong = self.userName;
                }
                
                NSLog(@"Push Service: Registering service");
                [self registerDevice];
                [self setTags];
                
            } else {
                NSLog(@"Push Service: No username set.");
            }
            
            
        } else {
            NSLog(@"Push Service: No ServerID set. ");
        }
        
        
    } else {
        // Service not enabled,APNToken / ApplicationOD not set
        NSLog(@"Push Service: No APNToken or APNApplicationID set. ");
    }
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _localDeviceLanguage = [NSLocale preferredLanguages][0]; // Set, until its overwritten by register Device
    }
    return self;
}

+(instancetype)sharedSendNotification{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSendNotification = [[KTSendNotifications alloc]init];
    });
    return _sharedSendNotification;
    
}


/// Registers this device for receiving push notifications
-(void)registerDevice {
    // Register deviceID to PushWoosh service
    // Method: registerDevice
    
    
    //
    //    {
    //        "request":{
    //            "application":"APPLICATION_CODE",
    //            "push_token":"DEVICE_PUSH_TOKEN",
    //            "language":"en",  // optional
    //            "hwid": "hardware device id",
    //            "timezone": 3600, // offset in seconds
    //            "device_type":1 // 1 iPhone, 7 Mac
    //        }
    //    }
    
    
    NSUInteger capacity = _deviceToken.length * 2;
    NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
    const unsigned char *buf = _deviceToken.bytes;
    NSInteger i;
    for (i=0; i<_deviceToken.length; ++i) {
        [sbuf appendFormat:@"%02lX", (unsigned long)buf[i]];
    }
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:APNURL,@"registerDevice"]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    urlRequest.HTTPMethod = @"POST";
    NSNumber *deviceType;
    
    // 1= iPhone, 7 = MacOS, PushWoosh device Type IDs
    
#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
    deviceType = @7;
#else
    deviceType = @1;
#endif
    
    
    NSDictionary *payload = @{@"request":@{
                                      @"application":self.APNApplictionID,
                                      @"push_token":sbuf,
                                      @"language":_localDeviceLanguage,
                                      @"hwid":_hardwareID,
                                      @"device_type":deviceType
                                      }};
    
    [self sendDataToService:urlRequest jsonPayload:payload];
    
}


-(void)unregisterDevice{
    
    // Unregisters from PushWoosh Service
    //unregisterDevice
    
    //    {
    //        "request":{
    //            "application":"APPLICATION_CODE",
    //            "hwid": "hardware device id"
    //        }
    //    }
    //
    
    
    
}

/*
 Notifies about an opend push
 */
-(void)sendPushOpend:(NSString*)pushHashValue{
    //    {
    //        "request":{
    //            "application": "DEAD0-BEEF0",
    //            "hwid": "HWID",
    //            "hash": "hash"         // received in the push notification in the "p" parameter
    //        }
    //    }
    
    if (ServiceEnabled) {
        
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:APNURL,@"pushStat"]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
        [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        urlRequest.HTTPMethod = @"POST";
        
        NSDictionary *payload = @{@"request":@{
                                          @"application":self.APNApplictionID,
                                          @"hwid":_hardwareID,
                                          @"hash":pushHashValue
                                          }};
        
        [self sendDataToService:urlRequest jsonPayload:payload];
    }
    
}


/// Sends the keytech ServerID and current username to APN Service as a filter Tag
-(void)setTags{
    
    //    {
    //        "request":{
    //            "application":"DEAD0-BEEF0",
    //            "hwid": "device hardware id",
    //            "tags": {
    //                "StringTag": "string value",
    //                "IntegerTag": 42,
    //                "ListTag": ["string1","string2"]
    //            }
    //        }
    //    }
    //
    
    if (!_hardwareID) {
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:APNURL,@"setTags"]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    urlRequest.HTTPMethod = @"POST";
    
    NSDictionary *payload = @{@"request":@{
                                      @"application":self.APNApplictionID,
                                      @"auth":self.APNAPIToken,
                                      @"hwid":_hardwareID,
                                      @"tags":@{@"serverid":self.serverID,
                                                @"username":self.userName,
                                                }
                                      }
                              };
    
    
    [self sendDataToService:urlRequest jsonPayload:payload];
}

/**
 Sends a pushwoosh notification, to the Owner of the element
 @param messageDictionary A Dictionary of form LanguageCode:Message that contains a List of localized messages to send
 @param elementKey The key for a specifix element
 @param elementOwner The short key as the element owner to send the push message to
 */
-(void)sendNotification:(NSDictionary*)messageDictionary elementKey:(NSString*)elementKey elementCreatedBy:(NSString*)elementOwner{
    
    
    if (!self.serverID) {
        // If not currently initialzed, then do not send any notifications
        return;
    }
    
    if (!ServiceEnabled) {
        // Dont send if no API token set or notification Service set up.
        return;
    }
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:APNURL,@"createMessage"]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    urlRequest.HTTPMethod = @"POST";
    
    NSArray *Tag_ConditionServerID = @[@"serverid",@"EQ",self.serverID];   // Array: <tagname>,<operator>,<value> ["SERVERID","EQ","<ID>"]
    NSArray *Tag_ConditionUsername =@[@"username",@"EQ",elementOwner]; //["UserID","EQ","<ID>"]
    
    NSDictionary *payload = @{@"request":@{
                                      @"application":self.APNApplictionID,
                                      @"auth":self.APNAPIToken,
                                      @"notifications":@[@{@"send_date":@"now",
                                                           @"ignore_user_timezone":@1,
                                                           @"content":messageDictionary, //message as a languageCode- Message dictionary,
                                                           @"data":@{@"elementkey":elementKey},
                                                           @"platforms":@[@1,@7],
                                                           @"conditions":@[Tag_ConditionServerID,Tag_ConditionUsername]
                                                           }]
                                      }
                              };
    
    
    [self sendDataToService:urlRequest jsonPayload:payload];
    
    
    
    //    {
    //        "request":{
    //            "application":"APPLICATION_CODE",
    //            "auth":"api_access_token",
    //            "notifications":[
    //                             {
    //                                 // Content settings
    //                                 "send_date":"now",           // YYYY-MM-DD HH:mm  OR 'now'
    //                                 "ignore_user_timezone": true,   // or false
    //                                 "content":{                  // Object( language1: 'content1', language2: 'content2' ) OR string. For Windows 8 this parameter is ignored, use "wns_content" instead.
    //                                     "en":"English"
    //                                 },
    //
    //                                 "data":{                     // JSON string or JSON object, will be passed as "u" parameter in the payload
    //                                     "custom": "json data"
    //                                 },
    //                                 "platforms": [1,7], // 1 - iOS; 2 - BB; 3 - Android; 5 - Windows Phone; 7 - OS X; 8 - Windows 8; 9 - Amazon; 10 - Safari
    //
    //                                 // iOS related
    //                                 "ios_root_params" : {     //Optional - root level parameters to the aps dictionary
    //                                     "aps":{
    //                                         "content-available": "1"
    //                                     }
    //                                 },
    //                                 // Mac OS X related
    //                                 "mac_root_params": {"content-available":1},
    //
    //                                 "filter": "FILTER_NAME" //Optional.
    //                                 "conditions": [TAG_CONDITION1, TAG_CONDITION2, ..., TAG_CONDITIONN] //Optional. See remark
    //                             }
    //                             ]
    //        }
    //   }
}


/**
 Send data to service
 @param urlRequest The prepaired request to send
 @param payload The JSON payload to send to notification service
 */
-(void)sendDataToService:(NSMutableURLRequest*)urlRequest jsonPayload:(NSDictionary*)payload{
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:payload
                                                       options:kNilOptions error:&error];
    
    
#ifdef DEBUG
    //print out the data contents
    NSString *JSONMessageBody = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:payload
                                                                                               options:NSJSONWritingPrettyPrinted error:&error]
                                                      encoding:NSUTF8StringEncoding];
    
    NSLog(@"Sending JSON: %@",JSONMessageBody);
    NSLog(@"Sending Request: %@",urlRequest);
#endif
    
    urlRequest.HTTPBody = jsonData;
    
    // KTSendNotifications *connectionDelegate = [[KTSendNotifications alloc]init];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    //return;
    
}


/**
 Returns a localized text when an element has been changed
 @param elementName The element which has changed
 @param userName The own username
 */
-(NSDictionary*)localizedTextElementChanged:(NSString*)elementName userName:(NSString*)userName{
    NSDictionary *dict = @{@"de":[NSString stringWithFormat:@"Das Element %@ wurde von %@ geändert." ,elementName,userName],
                           @"en":[NSString stringWithFormat:@"The element %@ has been changed by %@.",elementName,userName]};
    return dict;
}

/**
 Returns a localized text when an element has been deleted
 @param elementName The element which has changed
 @param userName The own username
 */
-(NSDictionary*)localizedTextElementDeleted:(NSString*)elementName userName:(NSString*)userName{
    NSDictionary *dict = @{@"de":[NSString stringWithFormat:@"Das Element %@ wurde von %@ gelöscht.",elementName,userName],
                           @"en":[NSString stringWithFormat:@"The element %@ has been deleted by %@.",elementName,userName]};
    return dict;
}

/**
 Returns a localized text when an element has been removed from a structure (folder)
 @param elementName The element which has changed
 @param userName The own username
 @param folderName The displaytext of the parent folder
 */
-(NSDictionary*)localizedTextElementRemovedFromLink:(NSString*)elementName userName:(NSString*)userName folderName:(NSString*)folderName{
    NSDictionary *dict = @{@"de":[NSString stringWithFormat:@"Das Element %@ wurde von %@ aus der Mappe %@ entfernt.",elementName,userName,folderName],
                           @"en":[NSString stringWithFormat:@"The element %@ has been removed from %@.",elementName,folderName]};
    return dict;
}

/**
 Returns a localized text when a element has been added to a structure
 @param elementName The element which has changed
 @param userName The own username
 @param folderName The displaytext of the parent folder
 */
-(NSDictionary*)localizedTextElementAddedToLink:(NSString*)elementName userName:(NSString*)userName folderName:(NSString*)folderName{
    NSDictionary *dict = @{@"de":[NSString stringWithFormat:@"Das Element %@ wurde in die Mappe %@ eingefügt.",elementName,folderName],
                           @"en":[NSString stringWithFormat:@"The element %@ has been added to %@.",elementName,folderName]};
    return dict;
}

/**
 Returns a localized text when a element got a new file
 @param elementName: The element which has changed
 */
-(NSDictionary*)localizedTextElementFileAdded:(NSString*)elementName{
    NSDictionary *dict = @{@"de":[NSString stringWithFormat:@"Eine Datei wurde dem Element %@ hinzugefügt.",elementName],
                           @"en":[NSString stringWithFormat:@"A file was added to element %@",elementName]};
    return dict;
}

/**
 Returns a localized text when a element master file has been removed
 @description A Masterfile is the most imporant file of a documenbt
 @param elementName The element which has changed
 */
-(NSDictionary*)localizedTextElementMasterFileRemoved:(NSString*)elementName{
    NSDictionary *dict = @{@"de":[NSString stringWithFormat:@"Die Masterdatei wurde vom Element %@ entfernt.",elementName],
                           @"en":[NSString stringWithFormat:@"The masterfile was removed from element %@.",elementName]};
    return dict;
    
}

/**
 Returns a localized text when a elements file has been removed
 @param elementName The element which has changed
 */
-(NSDictionary*)localizedTextElementFileRemoved:(NSString*)elementName{
    NSDictionary *dict = @{@"de":[NSString stringWithFormat:@"Eine Datei wurde vom Element %@ entfernt.",elementName],
                           @"en":[NSString stringWithFormat:@"A file was removed from element %@.",elementName]};
    return dict;
}



#pragma mark Send Notifications

-(void)sendElementHasBeenChanged:(KTElement *)element{
    
    
    [self sendNotification:[self localizedTextElementChanged:element.itemName userName:self.userNameLong]
                elementKey:element.itemKey
          elementCreatedBy:element.itemCreatedBy];
    
    return;
    
}

-(void)sendElementHasBeenDeleted:(KTElement *)element{
    
    [self sendNotification:[self localizedTextElementDeleted:element.itemName userName:self.userNameLong]
                elementKey:element.itemKey
          elementCreatedBy:element.itemCreatedBy];
    
    return;
    
}

-(void)sendElementMasterFileHasBeenRemoved:(NSString *)elementKey{
    
    
    [KTElement loadElementWithKey:elementKey success:^(KTElement *element) {
        [self sendNotification:[self localizedTextElementMasterFileRemoved:element.itemName]
                    elementKey:elementKey
              elementCreatedBy:element.itemCreatedBy];
        
    }
                          failure:nil];
    
    return;
    
}

-(void)sendElementFileHasBeenRemoved:(NSString *)elementKey{
    
    
    [KTElement loadElementWithKey:elementKey success:^(KTElement *element) {
        [self sendNotification:[self localizedTextElementFileRemoved:element.itemName]
                    elementKey:elementKey
              elementCreatedBy:element.itemCreatedBy];
        
    }
                          failure:nil];
    
    return;
    
}

-(void)sendElementFileUploaded:(NSString *)elementKey{
    [KTElement loadElementWithKey:elementKey success:^(KTElement *element) {
        [self sendNotification:[self localizedTextElementFileAdded:element.itemName]
                    elementKey:elementKey
              elementCreatedBy:element.itemCreatedBy];
    }
                          failure:nil];
    
    return;
    
}

-(void)sendElementHasNewChildLink:(NSString *)elementKey addedtoFolder:( NSString*)folderName{
    [KTElement loadElementWithKey:elementKey success:^(KTElement *element) {
        [self sendNotification:
         [self localizedTextElementAddedToLink:element.itemName userName:self.userNameLong folderName:folderName]
                    elementKey:elementKey
              elementCreatedBy:element.itemCreatedBy];
    }
                          failure:nil];
    
    
}


-(void)sendElementChildLinkRemoved:(NSString*)elementKey removedFromFolder:(NSString*)folderName{
    [KTElement loadElementWithKey:elementKey success:^(KTElement *element) {
        
        [self sendNotification:
         [self localizedTextElementRemovedFromLink:element.itemName userName:self.userNameLong folderName:folderName]
                    elementKey:elementKey
              elementCreatedBy:element.itemCreatedBy];
    }
                          failure:nil];
    
    
}


#pragma mark -
#pragma mark connectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.connectionSucceeded = YES;
    self.connectionFinished = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.connectionSucceeded = NO;
    self.connectionFinished = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //    NSString *JSONMessageBody = [[NSString alloc] initWithData:data
    //                                                      encoding:NSUTF8StringEncoding];
    //    NSLog(@"Response Data: %@",JSONMessageBody);
    //
    self.connectionSucceeded = YES;
    self.connectionFinished = YES;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.connectionSucceeded = YES;
    self.connectionFinished = YES;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    return request;
}

@end
