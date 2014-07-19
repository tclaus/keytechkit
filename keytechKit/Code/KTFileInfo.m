//
//  SimpleFileInfo.m
//  keytech search ios
//
//  Created by Thorsten Claus on 18.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//


#import "KTFileInfo.h"
#import "KTManager.h"

@implementation KTFileInfo
{
    NSString* _fileDivider;
}

@synthesize isLoading = _isLoading;
@synthesize localFileURL = _localFileURL;
@synthesize delegate;

static RKObjectMapping *_mapping;
static RKObjectManager *_usedManager;

- (id)init
{
    self = [super init];
    if (self) {
        _fileDivider = @"-+-";
    }
    return self;
}

/**
 Sets the object mapping
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTFileInfo class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"FileID":@"fileID",
                                                       @"FileName":@"fileName",
                                                       @"FileSize":@"fileSize",
                                                       @"FileStorageType":@"fileStorageType"
                                                       }];
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *notesDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                                                             method:RKRequestMethodGET | RKRequestMethodPOST | RKRequestMethodPUT
                                                                                        pathPattern:nil
                                                                                            keyPath:@"FileInfos" statusCodes:statusCodes];
        // DELETE
        [manager.router.routeSet addRoute:[RKRoute
                                           routeWithClass:[KTFileInfo class]
                                           pathPattern:@"elements/:elementKey/files/:fileID"
                                           method:RKRequestMethodDELETE]] ;
        
        [_usedManager addResponseDescriptor:notesDescriptor];
        
    }
    return _mapping;
}

-(id)copyWithZone:(NSZone *)zone{
    KTFileInfo *newcopy = [[KTFileInfo alloc] init];
    newcopy.fileID = self.fileID;
    newcopy.fileName = self.fileName;
    newcopy.fileStorageType = self.fileStorageType;
    newcopy.elementKey = self.elementKey;
    
    return newcopy;
}

// Returns the shortende filename
-(NSString*)shortFileName{
    if(self.fileName !=nil){
        //self.itemClassKey rangeOfString:@"_MI"].location !=NSNotFound
        
        NSUInteger location = [self.fileName rangeOfString:_fileDivider].location;
        
        if (location !=NSNotFound){ // Found divider
            
            NSArray *array = [self.fileName componentsSeparatedByString:@"."]; // Splitt to file attachment
            
            NSString* fileSuffix;
            NSString* fileNamePart;
            
            if ([array count]>1){
                fileSuffix = array[1];
                fileNamePart = array[0];
            } else
                fileNamePart = self.fileName;
            
            NSString* shortendFilename;
            
            // Find by divider
            NSArray* filenameParts = [fileNamePart componentsSeparatedByString:_fileDivider];
            if (filenameParts.count>1){
                // First part is the filename we want
                // second part can be thrown away
                
                shortendFilename = [NSString stringWithFormat:@"%@.%@",filenameParts[0],fileSuffix];
                
            }else
                shortendFilename = self.fileName;
            
            // Return the new, shortened filename
            return shortendFilename;
            
        }
        
    }
    
    return self.fileName;
}

/**
 Checks if the file is already transferd to local machine
 */
-(BOOL)isLocalLoaded{
    
    // Objekt ist nicht zugewiesen
    
    return self.localFileURL !=nil;
    
    
}

-(void)deleteFile:(void(^)(void))success failure:(void(^)(NSError* error))failure {
    
    if (!self.elementKey) {
        // Return an error
    }
    
    [[RKObjectManager sharedManager]deleteObject:self path:nil parameters:nil
                                         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                             // Delete has no mapping result
                                             if (success) {
                                                 success();
                                             }
                                         } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                             
                                             if (failure)
                                                 // Error- request
                                                 failure(error);
                                         }];
    
}

// Loads the file, if not locally available
-(void)loadRemoteFile{
    
    if (![self isLocalLoaded] && !_isLoading){
        _isLoading = YES;
        NSLog(@"Start download of %@",self.fileName);
        
        NSString* resource = [NSString stringWithFormat:@"files/%ld",(long)self.fileID];
        
        //NSURL *fileURL = [NSURL URLWithString:resource relativeToURL:[[RKObjectManager sharedManager].HTTPClient baseURL]];
        //NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:fileURL];
        
        NSMutableURLRequest *request = [[RKObjectManager sharedManager].HTTPClient requestWithMethod:@"GET" path:resource parameters:nil ];
        
        [[KTManager sharedManager] setDefaultHeadersToRequest:request];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

        
        NSURLSessionDownloadTask *getFileTask= [session downloadTaskWithRequest:request];
        [getFileTask resume];
        
        
        _isLoading = YES;
        return;
        
    } else {
        return;
    }
}



-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"Download finished of: %@",self.fileName);
    
    if (location) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *err;
        NSURL *targetURL = [[[KTManager sharedManager]applicationDataDirectory] URLByAppendingPathComponent:self.fileName];
        
        targetURL = [NSURL fileURLWithPath:[targetURL path]];
        
        [manager moveItemAtURL:location toURL:targetURL error:&err];
        
        
        [self willChangeValueForKey:@"localFileURL"];
        _localFileURL = targetURL;
        _isLoading = NO;
        [self didChangeValueForKey:@"localFileURL"];
    } else {
        // Fehler, Datei konnte nicht geladen werden
        _isLoading = NO;
    }
    
}

///Uploaded Data - Ignore invalid SSL (Self signed Certificates, Ugly but needed..)
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}

/// Downloaded Data Ignore invalid SSL (Self signed Certificates, Ugly but needed..)
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    // SSL Certification
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
    
    
}

/// Download Progress
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    // Progress
    
   NSLog(@"Downloaded %@: %d / %d",self.fileName, (int)totalBytesWritten,(int)totalBytesExpectedToWrite);
    if (delegate){
        if ([self.delegate respondsToSelector:@selector(KTFileInfo:downloadProgress:totalBytesWritten:)]) {
            [self.delegate KTFileInfo:self downloadProgress:bytesWritten totalBytesWritten:totalBytesExpectedToWrite];
        }
    }
   
}

/// Upload Progress
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    NSLog(@"Uploaded %@: %d / %d",self.fileName, (int)totalBytesSent,(int)totalBytesExpectedToSend);
   
    if ([self.delegate respondsToSelector:@selector(KTFileInfo:uploadProgress:totalBytesSent:)]) {
        [self.delegate KTFileInfo:self uploadProgress:totalBytesSent totalBytesSent:totalBytesExpectedToSend];
    }

    
}

/// Saves the current file to API
-(void)saveFile:(NSURL *)fileURL
        success:(void (^)(void))success
        failure:(void (^)(NSError *))failure{

    // Check for Delegate
    // Check for element Key
    

    
    
    NSString *resourcePath = [NSString stringWithFormat:@"elements/%@/files", self.elementKey];
    
    
    NSURL *url =[[KTManager sharedManager].baseURL URLByAppendingPathComponent:resourcePath];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:url ];
    
    // Add Default- and Auth Header
    
    [[KTManager sharedManager]setDefaultHeadersToRequest:postRequest];
    
    
    // Set additional headers
    [postRequest setValue:self.fileName forHTTPHeaderField:@"Filename"];
    [postRequest setValue:self.fileStorageType forHTTPHeaderField:@"StorageType"]; //
    
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    
    // [postRequest setHTTPBody:data];
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /*
     sessionConfiguration.HTTPAdditionalHeaders = @{
     @"api-key"       : @"55e76dc4bbae25b066cb",
     @"Accept"        : @"application/json",
     @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
     };
     */
    
    // Create the session
    // We can use the delegate to track upload progress
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];

    // Data uploading task. We could use NSURLSessionUploadTask instead of NSURLSessionDataTask if we needed to support uploads in the background
    NSData *data = [NSData dataWithContentsOfURL:[fileURL filePathURL]];
    
    self.fileSize = [data length];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:postRequest fromData:data
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          
                                                          
                                                          if (error) {
                                                              NSLog(@"File upload finished with error: %@",error.localizedDescription);
                                                              if (failure)
                                                                  failure(error);
                                                              return;
                                                              
                                                          } else {
                                                              NSLog(@"File upload finished!");
                                                              // Now checking for error
                                                              
                                                              NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse*)response;
                                                              
                                                              if ([httpResponse statusCode]>299 ) {
                                                                  if (failure) {
                                                                      
                                                                      NSString *errorDescription = [httpResponse.allHeaderFields objectForKey:@"X-ErrorDescription"];
                                                                      
                                                                      if (!errorDescription) {
                                                                          errorDescription = [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]];
                                                                      }
                                                                      
                                                                      NSError *error = [[NSError alloc]
                                                                                        initWithDomain:NSURLErrorDomain
                                                                                        code:0
                                                                                        userInfo: @{ NSLocalizedDescriptionKey : errorDescription}];
                                                                      
                                                                      failure(error);
                                                                  }
                                                                  return;
                                                              } else {
                                                                  // Set Location with new Header
                                                                  NSString *location =[httpResponse.allHeaderFields objectForKey:@"Location"];
                                                                  self.fileID = [location intValue];
                                                                  
                                                              }
                                                              if (success) {
                                                                  success();
                                                              }
                                                          }
                                                          
                                                      }];
    [uploadTask resume];
    
    
}


/**
 Debugger helper
 */
-(NSString*)description{
    return [NSString stringWithFormat:@"ID: %ld, Filename: %@",(long)self.fileID, self.fileName];
}
@end





