//
//  KTPosition.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Stellt eine Position eines grafischen Objektes dar
 */
@interface KTPosition : NSObject
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

/**
 Sets the object mapping for this class
 */
+(id)mapping;

@end
