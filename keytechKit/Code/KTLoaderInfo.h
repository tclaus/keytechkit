//
//  KTLoaderInfo.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 10.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <Restkit/RestKit.h>


/**
 Provides information about the request. Supports internal error handling.
 */
@interface KTLoaderInfo : NSObject

@property (nonatomic,copy) NSString* resourcePath;

/**
 Server side information
 */
@property (assign) NSHTTPURLResponse *response;

/**
 Server error description
 */
-(NSUInteger)errorCode;
/**
 Server error code. Zero (0) if not available
 */
-(NSString*)errorDescription;

/**
 Initiates the loaderInfo with a URLresponse object
 */
+(instancetype)loaderInfoWithResponse:(NSHTTPURLResponse*)response resourceString:(NSString*)resourcePath;

/**
 Initiates a new loaderInfo with the given resourceString
 */
+(instancetype)loaderInfoWithResourceString:(NSString*)resourceString;

/**
 Convenience init
 */
+(instancetype)ktLoaderInfo;

/**
 initializes an empty loader Info
 */
-(id)initWithResourcePath:(NSString*)resource;
// (For later use)


@end
