//
//  KTResponseLoader.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 02.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTKeytech.h"

/**
 Acts as a proxy between Restkit Load Responses and forwarding results to requester
 */
@interface KTResponseLoader : NSObject

/**
 Forwards the Restkit results to public accessable delegate
 */
@property (nonatomic,strong)  id<KTLoaderDelegate>  delegate;


@end
