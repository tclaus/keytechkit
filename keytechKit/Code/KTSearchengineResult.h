//
//  KTSearchengineResult.h
//  keytechKit
//
//  Created by Thorsten Claus on 06.11.14.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTElement.h"

/**
 Represents a manager object to retrive search results within files
 */
@interface KTSearchengineResult : NSObject
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 The underlying element that contains the searched value
 */
@property (nonatomic) KTElement *element;

/**
 The internal Solr ID to uniquely identify the element in the search index.
 */
@property (nonatomic) NSString *solrIndexID;

@end
