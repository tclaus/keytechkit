//
//  KTFont.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 29.03.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTFont : NSObject <NSCoding>


/**
 Sets the object mapping for this class
 */
+(id)mapping;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

@property (nonatomic,copy) NSString* fontName;
@property (nonatomic,copy) NSString* fontStyle;
@property (nonatomic,copy) NSNumber* fontSize;

/**
 Returns YES if the Text should be renderd Unerlined
 */
@property (readonly) BOOL isUnderlined;
/**
 Returns YES if the text should rendered bold
 */
@property (readonly) BOOL isBold;
/**
 Returns YES if the text should rendered italic
 */
@property (readonly) BOOL isItalic;

@end
