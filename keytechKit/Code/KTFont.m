//
//  KTFont.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 29.03.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTFont.h"
#import <RestKit/RestKit.h>

static RKObjectMapping* _mapping;

@implementation KTFont


+(id)mapping{
    if (!_mapping) {
        
        _mapping = [RKObjectMapping mappingForClass:[KTFont class]];
        
        [_mapping addAttributeMappingsFromDictionary:@{@"FontName":@"fontName",
                                                       @"FontSize":@"fontSize",
                                                       @"FontStyle":@"fontStyle"}];
        
        RKResponseDescriptor *fonts =
        [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                     method:RKRequestMethodAny
                                                pathPattern:nil
                                                    keyPath:@"Font"
                                                statusCodes:nil];
        
        [[RKObjectManager sharedManager] addResponseDescriptor:fonts];
        
        
    }
    return _mapping;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.fontName = [coder decodeObjectForKey:@"fontName"];
        self.fontSize = [coder decodeObjectForKey:@"fontSize"];
        self.fontStyle = [coder decodeObjectForKey:@"fontStyle"];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.fontName forKey:@"fontName"];
    [aCoder encodeObject:self.fontSize forKey:@"fontSize"];
    [aCoder encodeObject:self.fontStyle forKey:@"fontStyle"];
    
}


// Find the underline token
-(BOOL)isUnderlined{
    if ([self.fontStyle rangeOfString:@"UNDERLINE" options:NSCaseInsensitiveSearch].location !=NSNotFound){
        return YES;
    }
    return NO;
}

// Finds the italic token
-(BOOL)isItalic{
    if ([self.fontStyle rangeOfString:@"ITALIC" options:NSCaseInsensitiveSearch].location !=NSNotFound){
        return YES;
    }
    return NO;
}

// finds the bold token
-(BOOL)isBold{
    if ([self.fontStyle rangeOfString:@"BOLD" options:NSCaseInsensitiveSearch].location !=NSNotFound){
        return YES;
    }
    return NO;
}

@end
