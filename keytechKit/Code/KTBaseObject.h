//
//  KTBaseObject.h
//  keytechKit
//
//  Created by Thorsten Claus on 02.03.14.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Not in use
 */
@interface KTBaseObject : NSObject


/**
 Normalized elementKeys, Replaces a % in a classkey with the URL-friendly "DEFAULT". Changes "%_MI" to "DEFAULT_MI" 
 @param elementKey A elementKey to normalize
 */
+(NSString*)normalizeElementKey:(NSString*) elementKey;


@end
