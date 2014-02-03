//
//  KTSize.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides a size for a layout control
 */
@interface KTSize : NSObject

/**
 Sets the object mapping for this class
 */
+(id)mapping;

/**
 The height in points
 */
@property (nonatomic) NSInteger height;
/**
 The width in points
 */
@property (nonatomic) NSInteger width;

@end
