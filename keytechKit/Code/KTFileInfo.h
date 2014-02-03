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
@interface KTFileInfo : NSObject

/**
 Sets the object mapping for this class
 */
+(id)mapping;

/**
 Gets the unique fileID
 */
@property (nonatomic) NSInteger fileID;
/**
 Gets or sets the filename
 */
@property (nonatomic, copy) NSString* fileName;

/**
 Short filename is the filename without the ElementName. Shortend usually after the Divider '-+-' in filenames.
*/
 @property (nonatomic,readonly) NSString* shortFileName;

/**
 Gets the filesize in bytes
 */
@property (nonatomic,readonly) NSInteger fileSize;

/**
 Returns YES if the file is already locally loaded
 */
@property (nonatomic,readonly) BOOL isLocalLoaded;

/**
 Returns the Path to the API representation of this file
 */
@property (readonly) NSURL* remoteURL;

/**
  Local fileURL. Returns nil if currently file is not loaded. Starts the loading of the file.
 */
@property (readonly) NSURL* localFileURL;

/**
 Is YES while a file load is currently in progress.
 */
@property (readonly) BOOL isLoading;


@end
