//
//  KTBomItem.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 19.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "KTSimpleItem.h"


@class KTSimpleItem;
@interface KTBomItem : NSObject

///Provides the JSON mapping.
+(id)setMapping;

/**
 Provides the element which is represented by this bom
 */
@property (readonly) KTSimpleItem* element;

/**
 Contains the full key-value list of all bom attribes, including all element attributes
 */
@property (readonly)NSMutableArray* keyValueList;


/**
 Gets the value by keyValueList of all attributes
 */
-(id)getValueByKey:(NSString*)key;


@end
