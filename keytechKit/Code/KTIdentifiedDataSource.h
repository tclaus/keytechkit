//
//  KTIdentifiedDataSource.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 15.10.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Identifies a class to access its members by a identifier property
 */
@protocol KTIdentifiedDataSource <NSObject>

/**
 Identifies uniqely the object. Should be used to get data from API.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *identifier;
@end
