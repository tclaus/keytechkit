//
//  NSString+ClassType.h
//  keytechKit
//
//  Created by Thorsten Claus on 10.06.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Adds string functions for getting classkeys from strings
@interface NSString (ClassType)


/// If string represents a ElementKey this method returns a classkey. (Converts a full ElementKey to a classKey, without the nummeric ID)
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *ktClassKey;

/// If string represents a classkey or a element Key this returns the classtype (DO,MI,FD)
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *ktClassType;
    
@end
