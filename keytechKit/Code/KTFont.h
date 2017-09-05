//
//  KTFont.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 29.03.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Simple Font description for a control in editor or lister
 Describes a fonttype- and style
 */
@interface KTFont : NSObject <NSCoding>


/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
/**
 Name of a font. (Arial, Heletica, Sans Srif)
 */
@property (nonatomic,copy) NSString* fontName;
/**
 Name of a font style (Bold,Italic, underlne)
 */
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


NS_ASSUME_NONNULL_END
