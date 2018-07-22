//
//  KTFileInfo.h
//  keytech search ios
//
//  Created by Thorsten Claus on 18.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@class KTElement;
@protocol KTFileObjectDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 A typedef for valid filetypes to send and receive
 */
typedef NS_ENUM(NSInteger, FileStorageType) {
    /// The main type of file. Any element can only have one file of this type.
    FileTypeMaster,
    /// A Preview file. May be visible in clients. Represents an image to represent the file.
    FileTypePreview,
    /// A smaller version of a preview of the masterfile. Quickpreview files are noramlly not visible as files in clients but its contents in preview panes
    FileTypeQuickPreview,
    /// A unknown filetype. Ask the AIP Team.
    FileTypeOleRef
};


/**
 Provides a fileinfo object and helps loading the file to local machine
 */
@interface KTFileInfo : NSObject <NSCopying, NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate,NSURLSessionDelegate>

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Creates and returns a file object attached to the element in the argument
 @param element The elementcontainer to which the file object will be attached to.
 */
+(instancetype)fileInfoWithElement:(KTElement*)element;

/**
 A delegate to communicate upload und download progress
 */
@property (nonatomic) id <KTFileObjectDelegate> delegate;

/**
 The unique fileID
 */
@property (nonatomic) NSInteger fileID;
/**
 Gets or sets the filename
 */
@property (nonatomic, copy) NSString* fileName;

/**
 Gets the elementkey this file belongs to
 */
@property (nonatomic,copy,nullable) NSString *elementKey;

/**
 Short filename is the filename without the ElementName. Shortend usually after the Divider '-+-' in filenames.
 */
@property (nonatomic,readonly) NSString* shortFileName;

/**
 A text representation of the file Type : MASTER, PREVIEW, QuickPreview, OLEREF,
 */
@property (nonatomic) FileStorageType fileStorageType;

/**
 Returns the text expression of the files storage Type
 */
@property (readonly) NSString* fileStorageTextType;

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

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
/**
 Saves a file in a background task
 @param fileURL The local URL to the file to upload
 */
-(void)saveFileInBackground:(NSURL *)fileURL;
#endif

/**
 Stores this file to API. Uses the delegate to inform about progress
 @param fileURL The local URL to the file to upload
 @param success A block to execute after file is uploaded
 @param failure A block to execite after file upload failed
 */
-(void)saveFile:(NSURL *)fileURL
        success: (void (^)(void)) success
        failure:(void(^)(NSError *error))failure;

/**
 Delets this file from API.
 A valid elementKey property is needed to set to this object first.
 @param success A block to execute after delete of file succeeds.
 @param failure A block to execute after delete fails
 */
-(void)deleteFile:(void(^)(void)) success
          failure:(void(^)(NSError* error)) failure;

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

/// A delegate to manage file upload or download statistics
@protocol KTFileObjectDelegate <NSObject>

/**
 Send periodically to notify download progress
 @param fileInfo The fileinfo object who sends the update.
 @param bytesWritten The ammount of bytes now sendet.
 @param totalBytesWritten The total ammout of bytes to receive
 */
-(void)fileInfo:(KTFileInfo*)fileInfo downloadProgress:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten;

/**
 Send periodiacally to notify upload progress
 @param fileInfo The fileinfo object who sends the update.
 @param bytesSent The ammount of bytes sendet by the server.
 @param totalBytesSent The total ammout of bytes to send
 */
-(void)fileInfo:(KTFileInfo*)fileInfo uploadProgress:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent;

@optional
/**
 Sends a response that a file was uploaded
 @param fileInfo The fileinfo object who sends the update.
 */
-(void)FinishedUploadWithFileInfo:(KTFileInfo*)fileInfo;

/**
 Sends a response that a file was uploaded
 @param fileInfo The fileinfo object who sends the update.
 */
-(void)FinishedDownloadWithFileInfo:(KTFileInfo*)fileInfo;

@optional
@end

NS_ASSUME_NONNULL_END
