//
//  KTPagedObject.h
//  keytechKit
//
//  Created by Thorsten Claus on 22.09.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Holds information for querying a paged base object. 
 Provides a pagesize and a page count property. As a parameter for different query methods
 To get a response beginning woith the 100. element. Choose page and size to get 100. 
 On mobile connections keep size low. (e.g: page:5 size:20 are nice values)
 */
@interface KTPagedObject : NSObject
/**
 Will return elements on this page with size size
 */
@property (nonatomic) int page;
/**
 Will return the page of this size. Starting with the Element on position size x page
 */
@property (nonatomic) int size;

/**
 Initalizes a new paged object with page and size
 @param page The page. beginning with page "1"
 @param size The size of a page. Assuming every page has the same size.
 */
+(instancetype)initWithPage:(unsigned int)page size:(unsigned int)size;

@end
