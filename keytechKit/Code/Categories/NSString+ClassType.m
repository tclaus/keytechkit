//
//  NSString+ClassType.m
//  keytechKit
//
//  Created by Thorsten Claus on 10.06.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "NSString+ClassType.h"

/// Adds string functions for getting classkeys from strings
@implementation NSString (KTElementType)

/// If string represents a ElementKey this method returns a classkey. (Converts a full ElementKey to a classKey, without the nummeric ID)
-(NSString*) ktClassKey{
    NSArray *components=[self componentsSeparatedByString:@":"];
    
    if(components.count>=2)
        return [NSString stringWithFormat:@"%@",components[0]];
    
    return self;
}

/// If string represents a classkey or a element Key this returns the classtype (DO,MI,FD)
-(NSString*) ktClassType{
    
    NSArray *components=[self componentsSeparatedByString:@":"];
    NSString *classKey;
    
    if(components.count>=2) // SLD_DRW:123
        classKey= [NSString stringWithFormat:@"%@",components[0]];
    
    if (components.count==1) // SLD_DRW, then this is already a classkey
        classKey = self;
    if (classKey) {
        
        if ([classKey rangeOfString:@"_MI"].location !=NSNotFound) return @"MI";
        if ([classKey rangeOfString:@"_FD"].location !=NSNotFound) return @"FD";
        if ([classKey rangeOfString:@"_WF"].location !=NSNotFound) return @"FD";
    }
    
    return @"DO";
    
}
@end
