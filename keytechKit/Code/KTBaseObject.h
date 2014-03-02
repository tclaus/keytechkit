//
//  KTBaseObject.h
//  keytechKit
//
//  Created by Thorsten Claus on 02.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Not in use
 */
@interface KTBaseObject : NSObject


/**
 Normalized elementKeys, Replaces a % in a classkey with the URL-friendly "DEFAULT"
 */
+(NSString*)normalizeElementKey:(NSString*)elementKey;


@end
