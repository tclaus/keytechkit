//
//  SimpleKeyValuePair.h
//  keytech search ios
//
//  Created by Thorsten Claus on 14.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Stellt ein einfaches Schlüssel - Wertepaar bereit
 */
@interface KTSimpleKeyValuePair : NSObject
/**
 The key of a value
 */
@property (nonatomic,copy) NSString* itemKey;
/**
 The value itself
 */
@property (nonatomic,copy) NSString* itemValue;

@end
