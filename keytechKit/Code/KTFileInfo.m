//
//  SimpleFileInfo.m
//  keytech search ios
//
//  Created by Thorsten Claus on 18.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//


#import "KTFileInfo.h"
#import "KTManager.h"
#import "KTSendNotifications.h"
#import "SSZipArchive.h"

@implementation KTFileInfo
{
    NSString* _fileDivider;
    NSURLSession *_backgroundSession;
    
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
        _fileStorageType = FileTypeMaster;
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
                                                       @"FileStorageType":@"fileStorageTextType"
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

+(instancetype)fileInfoWithElement:(KTElement *)element{
    KTFileInfo *fileInfo = [[KTFileInfo alloc]init];
    if (fileInfo) {
        fileInfo.elementKey = element.itemKey;
    }
    return fileInfo;
}

-(void)setFileStorageTextType:(NSString*)storageType{
    if ([storageType compare:@"Master" options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
        self.fileStorageType =FileTypeMaster;
        return;
    }
    if ([storageType compare:@"Preview" options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
        self.fileStorageType =FileTypePreview;
        return;
    }
    
    if ([storageType compare:@"QuickPreview" options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
        self.fileStorageType =FileTypeQuickPreview;
        return;
    }
    
    if ([storageType compare:@"OleRef" options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
        self.fileStorageType =FileTypeOleRef;
        return;
    }
    
}

-(NSString*)fileStorageTextType{
    switch (self.fileStorageType) {
            
        case FileTypeMaster:
            return @"MASTER";
            break;
            
        case FileTypeOleRef:
            return @"OLEREF";
            break;
            
        case FileTypePreview:
            return @"PREVIEW";
            break;
            
        case FileTypeQuickPreview:
            return @"QUICKPREVIEW";
            break;
            
        default:
            NSLog(@"No filetype set!");
            return @"";
            break;
    }
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
        NSAssert(NO, @"ElementKey can not be nil");
    }
    
    [[RKObjectManager sharedManager]deleteObject:self path:nil parameters:nil
                                         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                             // Delete has no mapping result
                                             
                                             // Send notification Async
                                             if (self.fileStorageType == FileTypeMaster) {
                                                 [[KTSendNotifications sharedSendNotification]sendElementMasterFileHasBeenRemoved:self.elementKey];
                                                 
                                             } else {
                                                 [[KTSendNotifications sharedSendNotification]sendElementFileHasBeenRemoved:self.elementKey];
                                             }
                                             

                                             if (success) {
                                                 success();
                                             }
                                         } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                             
                                             NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response];
                                             
                                             if (failure) {
                                                 failure(transcodedError);
                                             }
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

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"Completes: %s",__PRETTY_FUNCTION__);
    
    if ([self.delegate respondsToSelector:@selector(FinishedUploadWithFileInfo:)]) {
        [self.delegate FinishedUploadWithFileInfo:self];
    }
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"Download finished of: %@",self.fileName);
    
    if (location) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *err;
        NSURL *targetURL = [[[KTManager sharedManager]applicationDataDirectory] URLByAppendingPathComponent:self.fileName];
        
        targetURL = [NSURL fileURLWithPath:[targetURL path]];
        
        [manager removeItemAtURL:targetURL error:&err];
        if (err) {
            NSLog(@"Target file can not be deleted.");
        }
        
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
#if DEBUG
    NSLog(@"Downloaded %@: %d / %d",self.fileName, (int)totalBytesWritten,(int)totalBytesExpectedToWrite);
#endif
    
    if (delegate){
        if ([self.delegate respondsToSelector:@selector(KTFileInfo:downloadProgress:totalBytesWritten:)]) {
            [self.delegate KTFileInfo:self downloadProgress:bytesWritten totalBytesWritten:totalBytesExpectedToWrite];
        }
    }
    
}

/// Upload Progress
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
#if DEBUG
    NSLog(@"Uploaded %@: %d / %d",self.fileName, (int)totalBytesSent,(int)totalBytesExpectedToSend);
#endif
    
    if ([self.delegate respondsToSelector:@selector(KTFileInfo:uploadProgress:totalBytesSent:)]) {
        [self.delegate KTFileInfo:self uploadProgress:totalBytesSent totalBytesSent:totalBytesExpectedToSend];
    }
    
    
}

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
-(void)saveFileInBackground:(NSURL *)fileURL{
    
    NSString *resourcePath = [NSString stringWithFormat:@"elements/%@/files", self.elementKey];
    
    
    NSURL *url =[[KTManager sharedManager].baseURL URLByAppendingPathComponent:resourcePath];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:url ];
    
    // Add Default- and Auth Header
    
    [[KTManager sharedManager]setDefaultHeadersToRequest:postRequest];
    
    
    // Set additional headers
    [postRequest setValue:self.fileName forHTTPHeaderField:@"Filename"];
    [postRequest setValue:self.fileStorageTextType forHTTPHeaderField:@"StorageType"]; //
    
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    
    
    // Create the session
    // We can use the delegate to track upload progress
    _backgroundSession = [self backgroundSession];
    
    // Data uploading task. We could use NSURLSessionUploadTask instead of NSURLSessionDataTask if we needed to support uploads in the background
    // NSData *data = [NSData dataWithContentsOfURL:[fileURL filePathURL]];
    
    //self.fileSize = [data length];
    
    NSURLSessionUploadTask *uploadTask = [_backgroundSession uploadTaskWithRequest:postRequest fromFile:fileURL];
    
    uploadTask.taskDescription =@"Add file to Element";
    
    [uploadTask resume];
    
}
#endif

-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    if (error) {
        NSLog(@"Session become invalid with: %@",error);
    }
    
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
    [_backgroundSession invalidateAndCancel];
    _backgroundSession = nil;
}


#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
- (NSURLSession *)backgroundSession
{
    /*
     Using dispatch_once here ensures that multiple background sessions with the same identifier are not created in this instance of the application. If you want to support multiple background sessions within a single process, you should create each session with its own identifier.
     */
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Generate a Upload TAsk with this fileID
        NSURLSessionConfiguration *configuration;
        
        if (floor(NSAppKitVersionNumber)>NSAppKitVersionNumber10_9) {
            
            configuration= [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSString stringWithFormat:@"de.claus-software.keytech.upload:%@",self.elementKey]];
            
        } else {
            configuration= [NSURLSessionConfiguration backgroundSessionConfiguration:[NSString stringWithFormat:@"de.claus-software.keytech.upload:%@",self.elementKey]];
        }
        
        
        configuration.sharedContainerIdentifier =@"group.de.claus-software.keytech-plm";
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
    });
    return session;
}
#endif

/// Saves a preview file for the given apple iWork File
-(void)saveiWorkPreviewFile:(NSURL*)fileURL{
    

    // NSArray *validiWorkTypes = @[@"pages",@"numbers",@"key"];
    

    
    if  ( [[fileURL pathExtension] compare:@"pages" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
        [[fileURL pathExtension] compare:@"numbers" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
        [[fileURL pathExtension] compare:@"key" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        NSLog(@"Add preview file for iWork file");
        
        // iWork file format found
        // unzip
        // Is file zipped?
        // If not, zip it

        
        NSString *zipPath = [fileURL path];
        
        NSString *destinationPath = NSTemporaryDirectory();
        BOOL success = [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
        if (success){
        // If successfully unzipped, try to get the preview
            
            NSString *previewPath = @"Preview.jpg";
            previewPath = [destinationPath stringByAppendingPathComponent:previewPath];
            
            if ([[NSFileManager defaultManager]fileExistsAtPath:previewPath]) {
                // Preview file existiert, als Quick-Preview hochladen
                KTFileInfo *previewFile = [[KTFileInfo alloc]init];
                previewFile.fileName = @"preview.jpg";
                previewFile.fileStorageType = FileTypeQuickPreview;
                previewFile.elementKey = self.elementKey;
                
                [previewFile saveFile:[NSURL fileURLWithPath:previewPath]
                              success:nil
                              failure:nil];
                
            };
            
        }
        

        
        
    }
}

/// Saves the current file to API as normaul upload task
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
    [postRequest setValue:self.fileStorageTextType forHTTPHeaderField:@"StorageType"]; //
    
    
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    
    // [postRequest setHTTPBody:data];
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForRequest = 60;
    
    /*
     sessionConfiguration.HTTPAdditionalHeaders = @{
     @"api-key"       : @"55e76dc4bbae25b066cb",
     @"Accept"        : @"application/json",
     @"Content-Type"  : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
     };
     */
    
    // Create the session
    // We can use the delegate to track upload progress
    NSURLSession *session = [NSURLSession  sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    // Data uploading task. We could use NSURLSessionUploadTask instead of NSURLSessionDataTask if we needed to support uploads in the background
    NSData *data = [NSData dataWithContentsOfURL:[fileURL filePathURL]];
    self.fileSize = [data length];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:postRequest fromFile:fileURL
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          
                                                          
                                                          if (error) {
                                                              NSLog(@"File upload finished with error: %@",error.localizedDescription);
                                                              NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse*)response;
                                                              NSLog(@"With Status Code: %ld",(long)httpResponse.statusCode);
                                                              
                                                              if (failure)
                                                                  failure(error);
                                                              return;
                                                              
                                                          } else {
                                                              NSLog(@"File upload finished!");
                                                              // Now checking for error
                                                              
                                                              NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse*)response;
                                                              
                                                              if ([httpResponse statusCode]>299 ) {
                                                                  
                                                                  NSLog(@"http response : %ld",(long)[httpResponse statusCode]);
                                                                  
                                                                  if (failure) {
                                                                      
                                                                      NSString *errorDescription = [httpResponse.allHeaderFields objectForKey:@"X-ErrorDescription"];
                                                                      
                                                                      if (!errorDescription) {
                                                                          errorDescription = [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]];
                                                                      }
                                                                      
                                                                      NSError *error = [[NSError alloc]
                                                                                        initWithDomain:NSURLErrorDomain
                                                                                        code:[httpResponse statusCode]
                                                                                        userInfo: @{ NSLocalizedDescriptionKey : errorDescription}];
                                                                      
                                                                      failure(error);
                                                                  }
                                                                  return;
                                                              } else {
                                                                  // Set Location with new Header
                                                                  NSString *location =[httpResponse.allHeaderFields objectForKey:@"Location"];
                                                                  self.fileID = [location intValue];
                                                                  
                                                                  if (self.fileStorageType == FileTypeMaster){
                                                                      
                                                                      // Send notification Async
                                                                    //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                          [[KTSendNotifications sharedSendNotification]sendElementFileUploaded:self.elementKey];
                                                                    //  });
                                                                      
                                                                      // Check for iWork preview files
                                                                      [self saveiWorkPreviewFile:fileURL];
                                                                      
                                                                      
                                                                  };
                                                                  
                                                                  
                                                                  
                                                              }
                                                              if (success) {
                                                                  success();
                                                              }
                                                          }
                                                          
                                                      }];
    [uploadTask resume];
    // NSLog(@"Headers: %@",sessionConfiguration.HTTPAdditionalHeaders);
    
}


-(void)cancelDownload{
    [[RKObjectManager sharedManager]cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET
                                                           matchingPathPattern:@"/elements/:elementKey/files"];
    
}
-(void)cancelUpload{
    [[RKObjectManager sharedManager]cancelAllObjectRequestOperationsWithMethod:RKRequestMethodPOST
                                                           matchingPathPattern:@"/elements/:elementKey/files"];
    
}

/**
 Debugger helper
 */
-(NSString*)description{
    return [NSString stringWithFormat:@"ID: %ld, Filename: %@",(long)self.fileID, self.fileName];
}
@end





