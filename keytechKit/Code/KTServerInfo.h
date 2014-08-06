//
//  KTServerInfo.h
//  keytechKit
//
//  Created by Thorsten Claus on 13.05.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTServerInfo : NSObject
/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Contains the full key-value list of all bom attribes, including all element attributes
 */
@property (readonly)NSMutableArray* keyValueList;

/**
 Returns the current API Version from Server
 */
@property (readonly)NSString *APIVersion;

/**
 Return the API Kernel version from Server
 */
@property (readonly)NSString *APIKernelVersion;

/**
 A unique key ti identify the current Server
 */
@property (readonly) NSString *ServerID;

+(instancetype)serverInfo;

-(void)reload;
@end
