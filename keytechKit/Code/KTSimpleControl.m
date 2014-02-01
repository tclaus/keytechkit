//
//  KTSimpleControl.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTSimpleControl.h"
#import <RestKit/RestKit.h>


@implementation KTSimpleControl{

    /// Provides the API value for the control alignment
    NSString* _controlAlignmentIntern;
}

@synthesize controlAttributeName = _controlAttributeName;
@synthesize controlDisplayName = _controlDisplayName;
@synthesize controlFontStyle = _controlFontStyle;
@synthesize controlType = _controlType;
@synthesize controlName = _controlName;
@synthesize controlPosition = _controlPosition;
@synthesize controlSequence = _controlSequence;
@synthesize controlSize = _controlSize;
@synthesize font = _font;
@synthesize rect = _rect;
@synthesize textAlignment = _textAlignment;



static RKObjectMapping* _mapping = nil;

// Sets the mapping
+(id)setMapping{

    if (!_mapping){
    
    _mapping = [RKObjectMapping mappingForClass:[KTSimpleControl class]];
        
        [_mapping addAttributeMappingsFromDictionary:@{
                                                      @"AttributeAlignment": @"controlAlignmentIntern",
                                                      @"AttributeName": @"controlAttributeName",
                                                      @"ControlType": @"controlType",
                                                      @"Displayname": @"controlDisplayName",
                                                      @"FontStyle": @"controlFontStyle",
                                                      @"Name": @"controlName",
                                                      @"Sequence": @"controlSequence"
                                                      }];
        
        
        [_mapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:@"Position" toKeyPath:@"controlPosition" withMapping:[KTPosition setMapping]]];
        [_mapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:@"Size" toKeyPath:@"controlSize" withMapping:[KTSize setMapping]]];
        [_mapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:@"Font" toKeyPath:@"font" withMapping:[KTFont setMapping]]];


    }
    
    return _mapping;
}

// Gets the api valuestring for the alignment
-(void)setControlAlignmentIntern:(NSString*)value{
    _controlAlignmentIntern = [value copy];
}

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
/**
 Returns the NSTextAlignment enum for correct behavior in Views.
 */
-(CTTextAlignment)textAlignment{
    if ([_controlAlignmentIntern isEqualToString:@"LEFT"]){ // from keytech API: Left
        return NSLeftTextAlignment;
    }

    if ([_controlAlignmentIntern isEqualToString:@"CENTER"]){ // from keytech API: Center
        return NSCenterTextAlignment;
    }
    if ([_controlAlignmentIntern isEqualToString:@"RIGHT"]){ // from keytech API: Right
        return NSRightTextAlignment;
    }
    
    // Return meaningful defaultvalue
    return NSNaturalTextAlignment;
}

#else
// IOS (Dont try to setup a keytech Editor on IOS!)
/**
 Returns the NSTextAlignment enum for correct behavior in Views.
 */
-(NSTextAlignment)textAlignment{
    if ([_controlAlignmentIntern isEqualToString:@"LEFT"]){ // from keytech API: Left
        return NSTextAlignmentLeft;
    }
    
    if ([_controlAlignmentIntern isEqualToString:@"CENTER"]){ // from keytech API: Center
        return NSTextAlignmentCenter;
    }
    if ([_controlAlignmentIntern isEqualToString:@"RIGHT"]){ // from keytech API: Right
        return NSTextAlignmentRight;
    }
    
    // Return meaningful defaultvalue
    return NSTextAlignmentNatural;
}
#endif

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
// Returns a rect structure to describe the boundaries of this control
-(NSRect)rect{
   NSRect bounds= NSMakeRect(self.controlPosition.x, self.controlPosition.y, self.controlSize.width, self.controlSize.height);
    return bounds;
}
#else
// Returns a rect structure to describe the boundaries of this control
-(CGRect)rect{
    //TODO: Return a rect structure
   //Rect bounds= NSMakeRect(self.controlPosition.x, self.controlPosition.y, self.controlSize.width, self.controlSize.height);
    CGRect bounds = CGRectMake(self.controlPosition.x, self.controlPosition.y, self.controlSize.width, self.controlSize.height);
    return  bounds;
}
#endif
@end
