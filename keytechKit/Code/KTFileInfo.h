//
//  SimpleFileInfo.h
//  keytech search ios
//
//  Created by Thorsten Claus on 18.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


/**
 Provides a fileinfo object and helps loading the file to local machine
 */
@interface KTFileInfo : NSObject <NSCopying>

/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

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

/**
  Loads the remote file to a temporary store
 */
-(void) loadRemoteFile;

/**
 Stores this file to API
 */
-(void)saveFile:(NSData *)data fileInfo:(KTFileInfo *)fileInfo
        success:(void (^)(void))success
        failure:(void(^)(NSError *error))failure;

/**
 Delets this file from API. 
 A valid elementKey property is needed
 */
-(void)deleteFile:(void(^)(void))success failure:(void(^)(NSError* error))failure;

/**
 Is YES while a file load is currently in progress.
 */
@property (readonly) BOOL isLoading;



@end




