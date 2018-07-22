//
//  KTClassAttribute.h
//  keytechKit
//
//  Created by Thorsten Claus on 01.03.14.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Represents a single atomic attribute of a class or of an element.
 Every element is described by a set of attributes. An attribute is represented as teh smalles storeable property of an element. 
 */
@interface KTClassAttribute : NSObject <NSCoding>

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;


-(instancetype)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

/**
 In case the attributeType is a text based type this is the maximum charcter count
 */
@property (nonatomic) int attributeLength;

/**
 A text representation of the attribute type:s TEXT, CHECK, DATE, INTEGER, DOUBLE.
 */
@property (nonatomic,copy) NSString *attributeType;

/**
 A descriptive text for this attribute. May not be localized on server side.
 */
@property (nonatomic,copy) NSString *attributeDescription; // mostly this is represented by a NSL key

/**
 A localized short name for this attribute
 */
@property (nonatomic,copy) NSString *attributeDisplayname; //localized displayname

/**
 This is the pure name of the attribute in a sepcific class
 */
@property (nonatomic,copy) NSString *attributeName; // the raw attribute name

/**
 Returns a stringvalue with a server side set default value.
 */
@property (nonatomic,copy) NSString *defaultValue;

/**
 If YES this attribute can be used in classlayouts
 */
@property (nonatomic) BOOL isLayoutRelevant;

/**
 If YES this attribute can be used in titleblocks. To store file related information
 */
@property (nonatomic) BOOL isTitleBlockRelevant;


@end

NS_ASSUME_NONNULL_END
