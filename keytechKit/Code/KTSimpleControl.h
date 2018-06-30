//
//  KTSimpleControl.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "KTSize.h"
#import "KTPosition.h"
#import "KTFont.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Represents a control for the keytech editor or lister. Contains everything you need to build you own views
 */
@interface KTSimpleControl : NSObject <NSCoding>

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;

/**
 Represents the controlname. In each layout a controlname must be unique
 */
@property (nonatomic,copy) NSString* controlName;

/**
 Represents the name of the underlying attribute. Only data controls are attached to a attribute.
 Label controls are normaly loose coupled and this property is empty or nil
 */
@property (nonatomic,copy) NSString* controlAttributeName;

/**
 Localized displaytext. (in Case if Label-Controls)
 */
@property (nonatomic,copy) NSString* controlDisplayName;

@property (nonatomic,copy) NSString *defaultValue;

/**
 Gets or stes a keytech controltype Valid types are TEXT, CHECK, LABEL,DOUBLE, INTEGER for Textfields, Switchbuttons or uneditable labelfields.
 */
@property (nonatomic,copy) NSString* controlType;
@property (nonatomic,strong) KTSize* controlSize; // {x,y} als .NET Size Typ
@property (nonatomic,strong) KTFont* font;

/**
 Returns YES if this textfield can be empty. A non nullable field should be rejected after user editing
 */
@property (nonatomic) BOOL isNullable;

/**
 A value of true indicates an editable field
 */
@property (nonatomic) BOOL isEditable;

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
/**
 Returns position and size as rect-Structure. Measurement is same as in keytech provided.
 */
@property (nonatomic,readonly) NSRect rect;

#else
@property (nonatomic,readonly) CGRect rect;
#endif

@property (nonatomic,strong) KTPosition* controlPosition;
@property (nonatomic) NSInteger controlSequence; // Reihenfolge in der Anzeige

/**
 Returns or sets the NStextAlignment enum for correct alignment in Views.
 see controlAlignment
 */
@property (nonatomic) CTTextAlignment textAlignment;

@end


NS_ASSUME_NONNULL_END
