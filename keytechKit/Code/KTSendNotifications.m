//
//  KTSendNotifications.m
//  keytechKit
//
//  Created by Thorsten Claus on 06.08.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTSendNotifications.h"
#import "KTManager.h"

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

@implementation KTSendNotifications{

}

static KTSendNotifications *_sharedSendNotification;

/// Hard coded Parse.com access codes, Do not Share them!!!
/// Allow overwrite but no Read!
static NSString* ParseApplicationID = @"HIzV42mcFmWtGbButSMfaPanfjAVriWBpR7wd0im";
static NSString* ParseRestAPIKey = @"hxIBBK60xY5xojEM6AWH5VAnzYpuOc2m6kVCtBCf";

static NSString* ParseURL = @"https://api.parse.com/1/push";

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

    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:payloadChannels
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
