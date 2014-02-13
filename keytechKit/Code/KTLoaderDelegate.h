//
//  KTLoaderDelegate.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 31.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTLoaderInfo.h"

/**
 All requests are delegated here.
 Required to implement: requestDidProceed.
 */
@protocol KTLoaderDelegate <NSObject>

@required
/** 
 Is called after a query returns with data
 */
-(void)requestDidProceed:(NSArray*)searchResult fromResourcePath:(NSString*)resourcePath;


/** 
 Query stops with an error
 */
-(void)requestProceedWithError:(KTLoaderInfo*)loaderInfo error:(NSError*)theError;
@end


