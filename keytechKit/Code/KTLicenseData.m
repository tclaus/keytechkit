//
//  KTLicenseData.m
//  keytechKit
//
//  Created by Thorsten Claus on 08.05.15.
//  Copyright (c) 2015 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTLicenseData.h"
#import <KTServerInfo.h>

static NSString * const kSDFParseAPIBaseURLString = @"https://api.parse.com/1/";

static NSString * const kSDFParseAPIApplicationId = @"8QxCATxc4qKwwRC60RXfMVwvAyRx8dkRsCg9ofBZ";
static NSString * const kSDFParseAPIKey = @"fdB5jQ8x1gOF2ruzjzfMJdqVrWYYZkJuN2fpAPhZ";

@implementation KTLicenseData{
    
@private
    BOOL _lastEvaluatedValue;
    NSString* _APIURL;
    NSString* _APILicenseKey;
    
    /// Latest datetime when the license was checked
    NSDate* _lastLicenceCheck;

    NSError* _failureError;
    dispatch_source_t timer;
    
    NSMutableData *parseLicenseData;
}


static KTLicenseData* _sharedLicense;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLoaded = NO;
        parseLicenseData = [[NSMutableData alloc]init];
    }
    return self;
}

+(KTLicenseData *)sharedLicenseData{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLicense = [[KTLicenseData alloc]init];
    });
    return _sharedLicense;
    
}

//TODO: Send notification every X minutes, if no licence code
-(void)setAPIURL:(NSString *)APIURL{
    _APIURL = [APIURL copy];
}

-(void)setAPILicenseKey:(NSString *)APILicenseKey{
    _APILicenseKey =[APILicenseKey copy];
}

-(NSError*)licenseError{
    return _failureError;
}

-(NSCalendar*)calendar{
    static NSCalendar* _calendar;
    
    if (!_calendar) {
        _calendar =[[NSCalendar alloc]
                    initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _calendar;
}
-(BOOL)isValidLicense{
    // Check here all Data, when is loaded
    // what to do, if not loaded or License Server not available?
    
    // Not Available: Allow 1hour, then send Notification
    // Available, bit invalid: send Notification
    //   With Reason: 1. Invalid License (when not Active)
    //                2. Invalid serverURL (when target URL ius not allowed) (Should defaults to "ALL"
    //                3. Invalid max version:
    //                4. End Date reached (For time bombed Licenses)
    
    
    // Wenn bereits eingelesen, UND gültig => reload hat eine niedrige Priorität (1x pro stunde)
    // Wenn Server nicht erreichbar oder negative Antwort, dann höherer Priorität (1-2 Minuten)
    
    [self initializeTimer];
    
    if (!self.isLoaded) {
        [self readLicenceData];
        return _lastEvaluatedValue;
    }
    

    if (_lastLicenceCheck) {
        
    
    NSDateComponents *lastCheck =
    [[self calendar] components:NSMinuteCalendarUnit fromDate:_lastLicenceCheck];
    
    NSDateComponents *current =
    [[self calendar] components:NSMinuteCalendarUnit fromDate:[NSDate date]];
    
    
    if (lastCheck.minute - current.minute >2 || lastCheck.minute - current.minute <-2 ) {
        [self readLicenceData];
    }
    }
    
    return _lastEvaluatedValue;
}

-(void)initReading{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self initializeTimer];
    });
    
}

-(void)initializeTimer{
    static bool latestValue;
    static bool timerDidStart = NO;
    
    int timeValue = 60;
    
    if (!timer) {
             timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, nil);
    }
    
    if (_lastEvaluatedValue  ) {
        // Check 1x per hour
        timeValue = 120;

    } else {
        // Check 1x per minute
        timeValue = 60;
    }
    
    
    if (_lastEvaluatedValue != latestValue) {
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW,  timeValue * NSEC_PER_SEC, timeValue * NSEC_PER_SEC);
        latestValue = _lastEvaluatedValue;
    }

    if (!timerDidStart) {
        [self startTimer];
        timerDidStart = YES;
    }
    
}
-(void)startTimer{
    
    dispatch_source_set_event_handler(timer, ^{
        // Check for Code
        dispatch_async(dispatch_get_main_queue(), ^{
            [self readLicenceData];
        });
        
    });
    dispatch_resume(timer);
}

/// Makes the needed Checks
-(bool)checkLicenseData{
    
    // Check for general availability
    if (!self.isActive) {
        _failureError = [NSError errorWithDomain:@"License" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Your license was deactivated."}];
        return NO;
    }
    
    // Check for valid API URL
    if (![self.targetURL isEqualToString:@"*"] && ![self.targetURL isEqualToString:@"ALL"]) {
        // More checks are neede
        // * is part of URL
        // compare: http://*.keytech.de with http://demo.keytech.de
        // *.keytech.de
        
        if ([self.targetURL containsString:@"*"]) {
            // Check for a star
        
        NSString *checkURL;
        checkURL= [self.targetURL stringByReplacingOccurrencesOfString:@"http://" withString:@""
                                                                options:NSCaseInsensitiveSearch
                                                                  range:NSMakeRange(0,self.targetURL.length)];
        
        checkURL= [checkURL stringByReplacingOccurrencesOfString:@"https://"
                                                             withString:@""
                                                                options:NSCaseInsensitiveSearch
                                                                  range:NSMakeRange(0,checkURL.length)];
        
        checkURL = [checkURL stringByReplacingOccurrencesOfString:@"*." withString:@""];
            
            // Finaly compare last Suffix
            if (![_APIURL.uppercaseString  hasSuffix:checkURL.uppercaseString]) {
                // Matches part of API
                _failureError = [NSError errorWithDomain:@"License" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Your license does not match to the server URL."}];
                return NO;
            }
            
            
        } else {
            // Check for exact match
            if ([self.targetURL compare:_APIURL options:NSCaseInsensitiveSearch] != NSOrderedSame) {
                _failureError = [NSError errorWithDomain:@"License" code:0 userInfo:@{NSLocalizedDescriptionKey:@"our license does not match to the server URL."}];
                return NO;
            }
        }
        
    }
    
    // Check for Version
    // Exact Match, >version , ~>version
    if (self.APIVersion) {
        NSString *CheckAPIVersion = [KTServerInfo sharedServerInfo].APIVersion;
        // Form 13.1.2.11, main,sp.minor.build
        // 14.1.2.33
        // 14.1.1
        
        // is there a prefix?
        // >, =, ~>
        
        if ([self.APIVersion hasPrefix:@">"]) {
            
            NSComparisonResult result= [[self.APIVersion stringByReplacingOccurrencesOfString:@">" withString:@""]
                                        compare:CheckAPIVersion options:NSCaseInsensitiveSearch];
            
            // License: >13.1.2, API: 13.1.2, 13.2.2, 14.xx but not lower than 13.1.2
            if (result == NSOrderedDescending) {
                _failureError = [NSError errorWithDomain:@"License" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Your license needs a higher API version. "}];
                return NO;
            }
            
        } else if ([self.APIVersion hasPrefix:@"~>"]) {
            NSString *strippedAPIVersion = [self.APIVersion stringByReplacingOccurrencesOfString:@"~>" withString:@""];
            
            NSComparisonResult result= [strippedAPIVersion
                                        compare:CheckAPIVersion options:NSCaseInsensitiveSearch];
            
            // License: >13.1.2, API: 13.1.2, 13.2.2, 14.xx but not lower than 13.1.2
            if (result == NSOrderedDescending) {
                _failureError = [NSError errorWithDomain:@"License" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Your license needs a higher API version."}];
                return NO;
            }
            // Get Main Version Number
            NSString *mainVersionNumberOfAPI = [CheckAPIVersion componentsSeparatedByString:@"."][0];
            NSString *licenceVersion =[strippedAPIVersion componentsSeparatedByString:@"."][0];
            
            if ([mainVersionNumberOfAPI compare:licenceVersion] == NSOrderedDescending) {
                _failureError = [NSError errorWithDomain:@"License" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Your license is invalid for this major version number. Need a lower major version number."}];
                return NO;
            }
            
        } else {
            // No Prefix, direct match
            // 13.1.2.0 matches 13.1.2.0
            // 13.1.2   matches 13.1.2.X
            // 13.1     matches 13.1.x.y
        }
        
    }
    
    
    // Check for termination Date
    if ([self.endDate compare:[NSDate date]]== NSOrderedAscending) {
        _failureError = [NSError errorWithDomain:@"License" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Your license is expired."}];
        return NO;
    }
   
    return YES;
    
}


-(void)readLicenceData{
    
    if (!_APILicenseKey) {
        NSLog(@"Need to set a API Licence Key first");
        _isLoaded = YES;
        NSException *invalidParameter = [NSException exceptionWithName:@"API key was empty" reason:@"API to set APILicenceKey first. Use [KTmanager sharedManager]setLicenceKey:licenceKey " userInfo:nil];
        [invalidParameter raise];
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:[kSDFParseAPIBaseURLString stringByAppendingString:@"classes/LicenseKeys/"]];

    // Add LicenseKey
    URL = [URL URLByAppendingPathComponent:_APILicenseKey];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:kSDFParseAPIApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [urlRequest addValue:kSDFParseAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    
    // KTSendNotifications *connectionDelegate = [[KTSendNotifications alloc]init];
    _isLoaded = NO;
    [parseLicenseData setData:nil];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Failed reading licencedata with error: %@",error.localizedDescription);
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (!parseLicenseData) {
        parseLicenseData = [[NSMutableData alloc]initWithData:data];
    } else {
        [parseLicenseData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError* error;
    NSDictionary* licenceData = [NSJSONSerialization JSONObjectWithData:parseLicenseData
                                                                options:kNilOptions
                                                                  error:&error];
    
    
    if (!licenceData) {
        _lastEvaluatedValue = NO;
        _failureError = [NSError errorWithDomain:@"License" code:100 userInfo:@{NSLocalizedDescriptionKey:@"Invalid license key."}];
    }
    
    // Elaubt, wenn :
    // Ist Aktiv = 1
    // URL: exakter treffer: (http://demo.keytech.de), (Teil: http://*.keytech.de) (Regex?) oder alle (*)
    // Version: wie im GEM: mindest-Version: => 13.1.26, Alle Versionen bis zur nächsten Haupt Version: ~>13.1.26 heisst: >=13.1.26 aber <13.2
    //          GEM: Most of the version specifiers, like >= 1.0, are self-explanatory. The specifier ~> has a special meaning, best shown by example. ~> 2.0.3 is identical to >= 2.0.3 and < 2.1. ~> 2.1 is identical to >= 2.1 and < 3.0. ~> 2.2.beta will match prerelease versions like 2.2.beta.12.
    // Ende - Datum: Leer (nil) oder ein Datum zb 1.1.2022
    
    _isLoaded = YES;

    if ([licenceData[@"isActive"] isEqual:[NSNumber numberWithBool:YES]]){
        _isActive = YES;
    } else {
        _isActive = NO;
    }
    
    
    
    
    _targetURL = licenceData[@"targetURL"]; // * oder "ALL", ein * ersetzt Platzhalter, nil = Nichts erlaubt.
    _note = licenceData[@"note"];
    _APIVersion = licenceData[@"targetMaxVersion"];
    
    NSDictionary *targetDateDic = licenceData[@"endDate"];
    NSString *dateString =targetDateDic[@"iso"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    _endDate = [dateFormatter dateFromString:dateString];
    
    // remember last read
    _lastLicenceCheck = [NSDate date];
    
    // Check read data
    _lastEvaluatedValue =  [self checkLicenseData];
    
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}



@end