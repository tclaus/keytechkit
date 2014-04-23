//
//  KTBomItem.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 19.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTElement.h"



@interface KTBomItem : NSObject

/**
 Returns the object mapping
 */
+(id)mapping;

/**
 Provides the element which is represented by this bom
 */
@property (readonly)KTElement* element;

/**
 Contains the full key-value list of all bom attribes, including all element attributes
 */
@property (readonly)NSMutableArray* keyValueList;




@end
