//
//  KTGlobalSettingContext.h
//  keytechKit
//
//  Created by Thorsten Claus on 05.02.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

/**
 A named context in thej global settings list
 */
@interface KTGlobalSettingContext : NSObject

+(id)mapping;

@property (nonatomic) NSArray *contexts;

@end
