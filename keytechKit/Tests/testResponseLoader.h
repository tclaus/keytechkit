//
//  testResponseLoader.h
//  keytechKit
//
//  Created by Thorsten Claus on 02.02.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface testResponseLoader : NSObject

/**
 The collection of objects loaded from the RKObjectLoader the receiver is acting as the delegate for.
 */
@property (nonatomic) NSArray *objects;
/**
 Represents the first object in the responseArray
 */
@property (nonatomic) NSObject *firstObject;
@property (nonatomic) NSError *error;

+ (testResponseLoader *)responseLoader;

-(void)waitForResponse;




@end
