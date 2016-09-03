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
@synthesize controlType = _controlType;
@synthesize controlName = _controlName;
@synthesize controlPosition = _controlPosition;
@synthesize controlSequence = _controlSequence;
@synthesize controlSize = _controlSize;
@synthesize font = _font;
@synthesize rect = _rect;
@synthesize textAlignment = _textAlignment;



static RKObjectMapping* _mapping = nil;
static RKObjectManager*_usedManager;

// Sets the mapping
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        _mapping = [RKObjectMapping mappingForClass:[KTSimpleControl class]];
        
        [_mapping addAttributeMappingsFromDictionary:@{
                                                       @"AttributeAlignment": @"controlAlignmentIntern",
                                                       @"AttributeName": @"controlAttributeName",
                                                       @"ControlType": @"controlType",
                                                       @"Displayname": @"controlDisplayName",
                                                       @"Name": @"controlName",
                                                       @"Sequence": @"controlSequence",
                                                       @"DefaultValue":@"defaultValue",
                                                       @"IsEditable":@"isEditable",
                                                       @"IsNullable":@"isNullable"
                                                       }];
        
        
        [_mapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:@"Position" toKeyPath:@"controlPosition" withMapping:[KTPosition mappingWithManager:manager]]];
        [_mapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:@"Size" toKeyPath:@"controlSize" withMapping:[KTSize mappingWithManager:manager]]];
        [_mapping addPropertyMapping:
         [RKRelationshipMapping relationshipMappingFromKeyPath:@"Font" toKeyPath:@"font" withMapping:[KTFont mappingWithManager:manager]]];
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        
        RKResponseDescriptor *simpleControlDescriptor =  [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                                                                      method:RKRequestMethodAny pathPattern:nil keyPath:@"DesignerControls" statusCodes:statusCodes];
        
        
        [[RKObjectManager sharedManager]addResponseDescriptor:simpleControlDescriptor];
        
    }
    
    return _mapping;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_controlAlignmentIntern forKey:@"controlAlignment"];
    [aCoder encodeObject:self.controlAttributeName forKey:@"controlAttributeName"];
    [aCoder encodeObject:self.controlDisplayName forKey:@"controlDisplayName"];
    [aCoder encodeObject:self.controlType forKey:@"controlType"];
    [aCoder encodeObject:self.controlName forKey:@"controlName"];
    [aCoder encodeInteger:self.controlSequence forKey:@"controlSequence"];
    [aCoder encodeObject:self.controlPosition forKey:@"controlPosition"];
    [aCoder encodeObject:self.controlSize forKey:@"controlSize"];
    [aCoder encodeObject:self.font forKey:@"controlFont"];
    [aCoder encodeObject:self.defaultValue forKey:@"defaultValue"];
    [aCoder encodeBool:self.isEditable forKey:@"isEditable"];
    [aCoder encodeBool:self.isNullable forKey:@"isNullable"];
    
    
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _controlAlignmentIntern = [coder decodeObjectForKey:@"controlAlignment"];
        self.controlAttributeName = [coder decodeObjectForKey:@"controlAttributeName"];
        self.controlDisplayName = [coder decodeObjectForKey:@"controlDisplayName"];
        self.controlName = [coder decodeObjectForKey:@"controlName"];
        self.controlType = [coder decodeObjectForKey:@"controlType"];
        self.controlSequence = [coder decodeIntegerForKey:@"controlSequence"];
        self.controlPosition = [coder decodeObjectForKey:@"controlPosition"];
        self.controlSize = [coder decodeObjectForKey:@"controlSize"];
        self.font = [coder decodeObjectForKey:@"controlFont"];
        self.defaultValue =[coder decodeObjectForKey:@"defaultValue"];
        self.isNullable = [coder decodeBoolForKey:@"isNullable"];
        self.isEditable = [coder decodeBoolForKey:@"isEditable"];
        
    }
    return self;
}



// Gets the api valuestring for the alignment
-(void)setControlAlignmentIntern:(NSString*)value{
    _controlAlignmentIntern = [value copy];
}

//#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
/**
 Returns the NSTextAlignment enum for correct behavior in Views.
 */
-(CTTextAlignment)textAlignment{
    
    NSString *alignmentString = _controlAlignmentIntern.uppercaseString;
    
    if ([alignmentString isEqualToString:@"LEFT"]){ // from keytech API: Left
        return kCTLeftTextAlignment;
    }
    
    if ([alignmentString isEqualToString:@"CENTER"]){ // from keytech API: Center
        return kCTCenterTextAlignment;
    }
    if ([alignmentString isEqualToString:@"RIGHT"]){ // from keytech API: Right
        return kCTRightTextAlignment;
    }
    
    // Return meaningful defaultvalue
    return kCTNaturalTextAlignment;
}



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
