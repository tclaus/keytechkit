//
//  KTPagedObject.h
//  keytechKit
//
//  Created by Thorsten Claus on 22.09.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTPagedObject : NSObject
@property (nonatomic) int page;
@property (nonatomic) int size;

/**
 Initalizes a new paged object with page and pagesize
 */
+(instancetype)initWithPage:(unsigned int)page size:(unsigned int)size;

@end
