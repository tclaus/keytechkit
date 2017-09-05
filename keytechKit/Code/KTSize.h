//
//  KTSize.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides a size for a layout control
 */
@interface KTSize : NSObject <NSCoding>

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;


-(void)encodeWithCoder:(NSCoder *)aCoder;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;


/**
 The height in points
 */
@property (nonatomic) NSInteger height;
/**
 The width in points
 */
@property (nonatomic) NSInteger width;

@end
