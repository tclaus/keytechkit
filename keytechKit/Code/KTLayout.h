//
//  KTLayout.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTSimpleControl.h"

/**
 Provides lister and editorlayout for a specific classtype.
 */
@interface KTLayout : NSObject <NSCoding>

- (instancetype)initWithCoder:(NSCoder *)coder;

-(void)encodeWithCoder:(NSCoder *)aCoder;

/**
 The decoded class version. Must be equal to the objects version
 */
@property (nonatomic) NSInteger classVersion;

/**
 Returns a list of lister layout controls
 */
@property (nonatomic,copy) NSArray <KTSimpleControl*> * listerLayout;

/**
 Returns a list of editor controls
 */
@property (nonatomic,copy) NSArray<KTSimpleControl*> * editorLayout;

/**
 Returns or sets the classkey for this Layout
 */
@property (nonatomic,copy) NSString *classKey;

/**
 Returns the Classtype
 */
@property (readonly,copy) NSString *classType;

/**
 Return true if listerlayout and editorlayout is loaded
 */
@property (NS_NONATOMIC_IOSONLY, getter=isLoaded, readonly) BOOL loaded;

@end
