//
//  KTResponseLoader.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 02.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTKeytech.h"

@interface KTResponseLoader : NSObject <KTLoaderDelegate>

/**
 The collection of objects loaded from the RKObjectLoader the receiver is acting as the delegate for.
 */
@property (nonatomic) NSArray *objects;
/**
 Represents the first object in the responseArray
 */
@property (nonatomic) NSObject *firstObject;
@property (nonatomic) NSError *error;

+ (KTResponseLoader *)responseLoader;

-(void)waitForResponse;


-(void)requestDidProceed:(NSArray*)searchResult fromResourcePath:(NSString*)resourcePath;
-(void)requestProceedWithError:(KTLoaderInfo*)loaderInfo error:(NSError*)theError;



@end
