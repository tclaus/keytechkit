//
//  KTLayouts.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 25.03.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTLayout.h"
#import "KTKeytech.h"

@protocol KTLayoutDelegate <NSObject>
@optional

/// Will be performed after lister and editor layout is loaded
-(void)layoutDidLoad:(KTLayout*)layout;

@end

@interface KTLayouts : NSObject <KTLoaderDelegate>


@property (nonatomic, unsafe_unretained) id<KTLayoutDelegate> delegate;

/// Returns the shared instance of layouts
+(instancetype)sharedLayouts;

/**
 Returns the layoutdata for the given class. Starts a download in background if not already loaded;
 */
-(KTLayout*)layoutForClassKey:(NSString*) classKey;

/**
 Returns a value that indicates that the layoutdata is already loaded
 */
-(BOOL)isLayoutLoaded:(NSString*)classKey;

/**
 Clears all Layout data
 */
-(void)clearLayoutData;

@end
