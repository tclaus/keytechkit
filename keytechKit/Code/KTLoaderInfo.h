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

@property (nonatomic,copy) NSString* ressourcePath;

/**
 Inits with the RKObjectLoader
 */
-(id)initWithObjectLoader:(id*)objectLoader;

@end
