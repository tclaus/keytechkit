//
//  KTSearchengineResult.h
//  keytechKit
//
//  Created by Thorsten Claus on 06.11.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTElement.h"

@interface KTSearchengineResult : NSObject
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

@property (nonatomic) KTElement *element;
@property (nonatomic) NSString *solrIndexID;
@end
