//
//  KTAttributeMapping.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 18.10.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTAttributeMapping : NSObject
/// Provides the obejct mapping. For internal Use unly.
+(id)mapping;

/**
 The classkey that identifies the target class of the mapping.
 Can be a placeholder of [ALL] for all classes of any type.
 */
@property (nonatomic,copy) NSString *classKey;

/**
 A user defined comment on this mapping
 */
@property (nonatomic,copy) NSString *comment;
/**
 A nummeric ID for internal identification
 */
@property (nonatomic,assign) int internalID;

@property (nonatomic,assign) int order;
/**
 The value that will be copied. Can be a internal attribut (eg as_mi__name) or any alphanummeric value that needs to be copied directly to the target attribute.
 */
@property (nonatomic,copy) NSString *sourceValue;
/**
 Internal status. (TBD)
 */
@property (nonatomic,copy) NSString *status;

/**
 Target attribute. The internal attribute name in the target class. The value or sour attribute content will be copied to this target attribute.
*/
@property (nonatomic,copy) NSString *targetAttribute;

/**
 The type of mapping. Can be a value of SETDEF, ST_DO_LNK, SWXPROP or more values. Depends of keytech internal use
 */
@property (nonatomic,copy) NSString *typeName;

@end



