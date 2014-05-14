//
//  KTKeyValue.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 17.04.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTKeyValue : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Returns or stets the key that identifies the value. 
 Represents typically a keytech attribute name
 */
@property (copy) NSString* key;
/**
 The value. Can be of any type. Check the named valuetypes.
 */
@property (copy) NSString* value;

/**
 Tries to interpret the value as a date value. Needs a valid JSON datetype
 */
-(NSDate*) valueAsDate;
/**
 Tries to interpret the value as a COCOA bool type.
 */
-(BOOL)valueAsBool;

/**
 Tests for Date occurence in JSON value. Returns nil if not convertible.
 */
+ (NSDate*) dateFromJSONString:(NSString *)dateString;

@end
