//
//  KTSendNotifications.m
//  keytechKit
//
//  Created by Thorsten Claus on 06.08.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTSendNotifications.h"
#import "KTManager.h"


// Parse.com
//curl -X POST \
//-H "X-Parse-Application-Id: HIzV42mcFmWtGbButSMfaPanfjAVriWBpR7wd0im" \
//-H "X-Parse-REST-API-Key: hxIBBK60xY5xojEM6AWH5VAnzYpuOc2m6kVCtBCf" \
//-H "Content-Type: application/json" \
//-d '{
//"channels": [
//             "Giants",
//             "Mets"
//             ],
//"data": {
//    "alert": "The Giants won against the Mets 2-3."
//}
//}' \
//https://api.parse.com/1/push


// PushWoosh
// https://cp.pushwoosh.com/json/1.3/%methodName%
// API Token : BLB4PUNrf4V64SMpMT30hx4M0AhnSAnjpeop8yJjmXpprj8sxaxEnrQnM0UlAf2aQpFRPSwjrT2WeaUig7aB
// Keep it secret !



@implementation KTSendNotifications{

}

static KTSendNotifications *_sharedSendNotification;

/// Hard coded Parse.com access codes, Do not Share them!!!
/// Allow overwrite but no Read!
static NSString* ParseApplicationID = @"HIzV42mcFmWtGbButSMfaPanfjAVriWBpR7wd0im";
static NSString* ParseRestAPIKey = @"hxIBBK60xY5xojEM6AWH5VAnzYpuOc2m6kVCtBCf";

static NSString* ParseURL = @"https://api.parse.com/1/push";

// URL for PushWoosh service
static NSString* APNURL =@"https://cp.pushwoosh.com/json/1.3/%@";
static NSString* APNAPIToken =@"BLB4PUNrf4V64SMpMT30hx4M0AhnSAnjpeop8yJjmXpprj8sxaxEnrQnM0UlAf2aQpFRPSwjrT2WeaUig7aB";
static NSString* APNApplictionID =@"A1270-D0C69"; // The Server Application

-(instancetype) init {
    if (self = [super init])
    {
        
        self.serverID = [KTServerInfo sharedServerInfo].serverID;
        self.userID = [KTManager sharedManager].username;
        
        self.connectionSucceeded = NO;
        self.connectionFinished = NO;
    }
    return self;
}

+(instancetype)sharedSendNotification{
    if (!_sharedSendNotification) {
        _sharedSendNotification = [[KTSendNotifications alloc]init];

    }
    return _sharedSendNotification;
}

/// Registers the device ID to the service
-(void)registerDevice:(NSString*)deviceID uniqueID:(NSString*)uniqueID{
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
//            "device_type":1 // 1 iPhone, / Mac
//        }
//    }


    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:APNURL,@"registerDevice"]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setHTTPMethod:@"POST"];

    NSDictionary *payload = @{@"request":@{
                                              @"application":APNApplictionID,
                                              @"push_token":deviceID,
                                              @"hwid":uniqueID,
                                              @"device_type":@"1"  // 1= iPhone, 7 = MacOS
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


//
-(void)sendNotificationPushWoosh{
   //createMessage
    
}


-(void)sendNotification:(NSString*)message{
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:APNURL,@"createMessage"]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSDictionary *payload = @{@"request":@{
                                      @"application":APNApplictionID,
                                      @"auth":APNAPIToken,
                                      @"notification":@[@{@"send_date":@"now",
                                                          @"ignore_user_timezone":@"true",
                                                          @"content":message,
                                                          @"data":@{@"Custom":@"Custom Data"},
                                                          @"platforms":@[@1,@7]
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

/// Actually send the notification and poayload data
-(void)sendNotificationToChannels:(NSArray*)targetingChannels localizedMessageKey:(NSString*)messageKey localizedArguments:(NSArray*)arguments elementKey:(NSString*)elementKey{
    
    if (!(self.serverID || self.userID)) {
        NSLog(@"You must have the ServerID and the userID set!");
        return ;
    }

    if (!elementKey) {
        NSLog(@"Elementkey can not be nil set to empty string instead.");
        elementKey = @"";
    }

    
    NSURL *URL = [NSURL URLWithString:ParseURL];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [urlRequest addValue:ParseApplicationID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [urlRequest addValue:ParseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [urlRequest setHTTPMethod:@"POST"];

  //loc-key , loc-args
   /*
    NSDictionary *payloadChannels = @{@"channels":@[self.serverID,self.userID] ,
                                          @"data":@{@"alert":alertMessage,
                                                    @"sound":@"default"}};
*/
    NSDictionary *payloadChannels = @{@"channels":@[self.serverID,self.userID] ,
                                      @"data":@{@"alert":@{@"loc-key":messageKey,@"loc-args":arguments},
                                                @"sound":@"default"},
                                                 @"EKey":elementKey};

    [self sendDataToService:urlRequest jsonPayload:payloadChannels];
    
    
}

/** 
 Send data to service
 */
-(void)sendDataToService:(NSMutableURLRequest*)urlRequest jsonPayload:(NSDictionary*)payload{
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:payload
                                                       options:kNilOptions error:&error];
    
    //print out the data contents
    NSString *JSONMessageBody = [[NSString alloc] initWithData:jsonData
                                                      encoding:NSUTF8StringEncoding];
    
    NSLog(@"Sending JSON: %@",JSONMessageBody);
    NSLog(@"Sending Request: %@",urlRequest);
    
    urlRequest.HTTPBody = jsonData;
    
    KTSendNotifications *connectionDelegate = [[KTSendNotifications alloc]init];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:urlRequest delegate:connectionDelegate];
    [connection start];
    
    // Do some polling to wait for the connections to complete
    // In Release dont wait - send in background!
    
#define POLL_INTERVAL 0.2 // 200ms
#define N_SEC_TO_POLL 3.0 // poll for 3s
#define MAX_POLL_COUNT N_SEC_TO_POLL / POLL_INTERVAL
    
    NSUInteger pollCount = 0;
    while (!connectionDelegate.connectionFinished && (pollCount < MAX_POLL_COUNT)) {
        NSDate* untilDate = [NSDate dateWithTimeIntervalSinceNow:POLL_INTERVAL];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
        pollCount++;
    }

}

/// Returns a lower case username
-(NSString *)userID{
    return _userID.lowercaseString;
}


-(void)sendMessageToPushWoosh{
    [self sendNotification:@"Element has changed"];
}

-(void)sendElementHasBeenChanged:(KTElement *)element{
    

    [self sendNotificationToChannels:@[self.serverID,self.userID]
                 localizedMessageKey:@"ELEMENT_CHANGED"   // "Element %@ has been changed", "Das element %@ wurde geändert"
                  localizedArguments:@[element.itemName]
                          elementKey:element.itemKey];
    
}

-(void)sendElementHasBeenDeleted:(KTElement *)element{
    [self sendNotificationToChannels:@[self.serverID,self.userID]
                 localizedMessageKey:@"ELEMENT_DELETED"   // "A Element was deleted", "Ein Element wurde gelöscht"
                  localizedArguments:@[element.itemName]
                          elementKey:nil]; // Dont transpport the element Key, after deletion a clint can not read the data
}


-(void)sendElementFileHasBeenRemoved:(NSString *)elementKey{
    [self sendNotificationToChannels:@[self.serverID,self.userID]
                 localizedMessageKey:@"ELEMENTFILE_REMOVED"   // "A file was removed from an element.", "Eine Datei wurde von einem Element entfernt."
                  localizedArguments:@[]
                          elementKey:elementKey];

}
-(void)sendElementFileUploaded:(NSString *)elementKey{
    [self sendNotificationToChannels:@[self.serverID,self.userID]
                 localizedMessageKey:@"ELEMENTFILE_ADDED"   // "A file was added to an element.", "Eine Datei wurde an einem Element hinzugefügt"
                  localizedArguments:@[]
                          elementKey:elementKey];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.connectionSucceeded = YES;
    self.connectionFinished = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Sending Notification Error: %@",error.localizedDescription);
    self.connectionSucceeded = NO;
    self.connectionFinished = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *JSONMessageBody = [[NSString alloc] initWithData:data
                                                      encoding:NSUTF8StringEncoding];
    NSLog(@"Response Data: %@",JSONMessageBody);
    
    self.connectionSucceeded = YES;
    self.connectionFinished = YES;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.connectionSucceeded = YES;
    self.connectionFinished = YES;
    NSLog(@"Response:  %@",response);
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    return request;
}

@end
