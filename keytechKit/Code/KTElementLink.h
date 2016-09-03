//
//  KTElementLink.h
//  keytechKit
//
//  Created by Thorsten Claus on 19.06.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class KTElement;

NS_ASSUME_NONNULL_BEGIN
/**
 Represents a simple Parent-Child relationship between elements in its structure
 */
@interface KTElementLink : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Contains the full elementkey as a childlink
 */
@property (nonatomic,copy) NSString* childLinkTo;

/**
 Contains the parent elementKey this link belongs to.
 A element can be linked under many other elements.
 */
@property (nonatomic,copy) NSString* parentElementKey;

/**
 Saves a new link to a parent element.  
 */
-(void)saveLink:(void (^)(KTElement *childElement))success failure:(void (^)(NSError * error))failure;
/**
 Deletes an existing link
 */
-(void)deleteLink:(void (^)(void))success failure:(void (^)(NSError * error))failure;

-(instancetype)initWithParent:(NSString*)parentElementKey childKey:(NSString*)childKey;

NS_ASSUME_NONNULL_END

@end
