//
//  KTSimpleControl.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "KTSize.h"
#import "KTPosition.h"
#import "KTFont.h"

@interface KTSimpleControl : NSObject <NSCoding>

/**
 Provides the object Mapping for this class and given objectManager
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)initWithCoder:(NSCoder *)aDecoder;

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
/**
 Gets or stes a keytech controltype Valid types are TEXT, CHECK, LABEL,DOUBLE, INTEGER for Textfields, Switchbuttons or uneditable labelfields.
 */
@property (nonatomic,copy) NSString* controlType;
@property (nonatomic,strong) KTSize* controlSize; // {x,y} als .NET Size Typ
@property (nonatomic,strong) KTFont* font;

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
