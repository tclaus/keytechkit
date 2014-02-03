//
//  KTChangeAction.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 11.08.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTChangeAction : NSObject

/**
 Sets the object mapping for this class
*/
+(id)mapping;

@property (nonatomic,copy) NSString* actionName;
@property (nonatomic,assign) NSMutableArray* classList;
@property (nonatomic,copy) NSString* descriptionText;
@property (nonatomic,assign) BOOL isActive;
@property (nonatomic,copy) NSString* parameter;
@property (nonatomic,assign) NSMutableArray* sourceStatusList;
@property (nonatomic,assign) NSMutableArray* targetStatusList;

@end
