//
//  KTFont.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 29.03.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTFont : NSObject

/*
 Ruft ein ObjektMapping ab und weist das Mapping dem MappingManager zu
 */
+(id)setMapping;

@property (nonatomic,copy) NSString* FontName;
@property (nonatomic,copy) NSString* FontStyle;
@property (nonatomic,copy) NSNumber* FontSize;

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
