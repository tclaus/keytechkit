//
//  KTUser.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 30.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTIdentifiedDataSource.h"
#import "KTLoaderDelegate.h"

/**
 Represets a group object
 */
@interface KTGroup : NSObject <KTIdentifiedDataSource>

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 The uniqe key. Represents the shortname (loginname)
 */
@property (nonatomic,copy)NSString* groupKey;
@property (readonly,copy)NSString* identifier;

/**
The users longname. 
*/
@property (nonatomic,copy) NSString* groupLongName;

/**
 Contains the userslist of all assigned user
 */
@property (nonatomic,readonly) NSMutableArray *usersList;

/**
 Returns a shared instance of group which represents the 'ALL' group. All is a placeholder for everybody, assigned to all user and group instances.
 */
+(KTGroup*)groupAll;
/**
 Returns a shared instance of group which represents the 'None' group. None is a placeholder for nobody, not assigned.
 */
+(KTGroup*)groupNone;

@end
