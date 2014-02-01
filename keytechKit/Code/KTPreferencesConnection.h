//
//  KTPreferencesConnection.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 10.04.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

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
