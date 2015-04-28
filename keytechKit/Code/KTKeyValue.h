//
//  KTKeyValue.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 17.04.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A key value pair. Value can be of any type but will be represented as a string value
 */
@interface KTKeyValue : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Request mapping
 */
//+(RKObjectMapping*)requestMapping;
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
 @param dateString If value is of type Date (in EPOCH format) then a NSDate will be generated.
 */
+ (NSDate*) dateFromJSONString:(NSString *)dateString;

@end
