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

@interface KTSimpleControl : NSObject

@property (nonatomic,copy) NSString* controlName;
@property (nonatomic,copy) NSString* controlAttributeName;

/**
 Localized displaytext. (in Case if Label-Controls)
 */
@property (nonatomic,copy) NSString* controlDisplayName;
/**
 Gets or stes a keytech controltype Valid types are TEXT, CHECK, LABEL for Textfields, Switchbuttons or uneditable labelfields.
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

/**
 Sets the object mapping for this class
 */
+(id)mapping;

@end
