//
//  KTSize.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTSize : NSObject

/*
 Ruft ein ObjektMapping ab und weist das Mapping dem MappingManager zu
 */
+(id)setMapping;

@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;

@end
