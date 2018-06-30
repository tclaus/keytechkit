//
//  KTPreferencesConnection.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 10.04.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides a Connection Setting for OSX
 */
@interface KTPreferencesConnection : NSObject <NSCoding>


/**
 keytech API host address
 */
@property (copy) NSString* servername;

/**
 keytech username
 */
@property (copy) NSString* username;

/**
 keytech users Password
 */
@property (copy) NSString* password;


@end

NS_ASSUME_NONNULL_END
