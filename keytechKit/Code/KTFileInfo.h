//
//  SimpleFileInfo.h
//  keytech search ios
//
//  Created by Thorsten Claus on 18.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class KTFileInfo;
@protocol KTFileObjectDelegate <NSObject>

/**
 Send periodically to notify download progress 
 */
-(void)KTFileInfo:(KTFileInfo*)fileInfo downloadProgress:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten;
/**
 Send periodiacally to notify upload progress
 */
-(void)KTFileInfo:(KTFileInfo*)fileInfo uploadProgress:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent;


@end

/**
 Provides a fileinfo object and helps loading the file to local machine
 */
@interface KTFileInfo : NSObject <NSCopying, NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>

/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 A delegate to communicate upload und download progress
 */
@property (nonatomic) id <KTFileObjectDelegate> delegate;

/**
 Gets the unique fileID
 */
@property (nonatomic) NSInteger fileID;
/**
 Gets or sets the filename
 */
@property (nonatomic, copy) NSString* fileName;

/**
 Gets the elementkey this file belongs to
 */
@property (nonatomic,copy) NSString *elementKey;

/**
 Short filename is the filename without the ElementName. Shortend usually after the Divider '-+-' in filenames.
*/
 @property (nonatomic,readonly) NSString* shortFileName;

/**
 A text representation of the file Type : MASTER, PREVIEW, QUICKPREVIEW
 */
@property (nonatomic,copy) NSString* fileStorageType;
/**
 Gets the filesize in bytes
 */
@property (nonatomic) NSInteger fileSize;

/**
 Returns YES if the file is already locally loaded
 */
@property (readonly) BOOL isLocalLoaded;


/**
When file is loaded a local URL is returned. Nil otherwise
 */
@property (readonly) NSURL *localFileURL;

#pragma mark Methods

/**
  Loads the remote file to a temporary store
 */
-(void)loadRemoteFile;

/**
 Stores this file to API. Uses the delegate to inform about progress
 */
-(void)saveFile:(NSURL *)fileURL
        success:(void (^)(void))success
        failure:(void(^)(NSError *error))failure;

/**
 Delets this file from API. 
 A valid elementKey property is needed
 */
-(void)deleteFile:(void(^)(void))success failure:(void(^)(NSError* error))failure;

/**
 Cancels a running upload
 */
-(void)cancelUpload;
/**
 Cancels the current download
 */
-(void)cancelDownload;

/**
 Is YES while a file load is currently in progress.
 */
@property (readonly) BOOL isLoading;



@end




