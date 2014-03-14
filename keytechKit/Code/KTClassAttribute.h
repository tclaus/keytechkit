//
//  KTClassAttribute.h
//  keytechKit
//
//  Created by Thorsten Claus on 01.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTClassAttribute : NSObject <NSCoding>

/**
 Sets the object mapping for this class
 */
+(id)mapping;

/**
 Unachives the classAttribute
 */
- (id)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;


@property (nonatomic) int attributeLength;
/**
 A text representation of the attribute type: TEXT, CHECK, DATE, INTEGER, DOUBLE.
 */
@property (nonatomic,copy) NSString *attributeType;
@property (nonatomic,copy) NSString *attributeDescription; // mostly this is represented by a NSL key
@property (nonatomic,copy) NSString *attributeDisplayname; //localized displayname
/**
 This is the pure name of the attribute in a sepcific class
 */
@property (nonatomic,copy) NSString *attributeName; // the raw attribute name

/**
 If YES this attribute can be used in classlayouts
 */
@property (nonatomic) BOOL isLayoutRelevant;
/**
 If YES this attribute can be used in titleblocks. To store file related information
 */
@property (nonatomic) BOOL isTitleBlockRelevant;


@end
