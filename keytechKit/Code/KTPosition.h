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
@interface KTPosition : NSObject <NSCoding>

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;


-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;


@end
