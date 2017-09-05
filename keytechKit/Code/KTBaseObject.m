//
//  KTBaseObject.m
//  keytechKit
//
//  Created by Thorsten Claus on 02.03.14.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTBaseObject.h"


@implementation KTBaseObject


#pragma mark Helper Functions

+(NSString*)normalizeElementKey:(NSString*)elementKey{
    if ([elementKey rangeOfString:@"%_"].location !=NSNotFound) {
        return [elementKey stringByReplacingOccurrencesOfString:@"%_" withString:@"DEFAULT_"];
    }
    return elementKey;
}

@end
