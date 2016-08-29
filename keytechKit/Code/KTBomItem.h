//
//  KTBomItem.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 19.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTElement.h"


/**
 A single bom entry. Contains element data and Bom data. 
 A BOM contains Size, Count, weight and other specific attribute of a specific item.
 */
@interface KTBomItem : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Provides the element which is represented by this bom
 */
@property (readonly)KTElement* element;

/**
 Contains the full key-value list of all bom attribes, including all element attributes
 */
@property (readonly)NSMutableArray <KTKeyValue*> * keyValueList;




@end
