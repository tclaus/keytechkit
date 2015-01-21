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


@interface KTLayouts : NSObject


/// Returns the shared instance of layouts
+(instancetype)sharedLayouts;

/**
 Starts loading a layout for the class. A layout for the current user/group will be loaded. 
 Check finish loading with the isLoaded selector
 */
-(void)loadLayoutForClassKey:(NSString*)classKey;

/**
 Starts loading a special layout for the given classkey.
 @param classKey The classkey eg: 3DSLD_DRW to load the layout data for the current user context.
 @param success A success block will excecuted after loading the layout.
 @param failure A failure block. Will only fail in case of a server error or an unknown classkey. 
 */
-(void)loadLayoutForClassKey:(NSString*)classKey success:(void(^)(KTLayout *layout))success failure:(void(^)(NSError* error))failure;

/**
 Starts loading all layouts for the current user
 */
-(void)loadLayoutsWithCompletion:(void(^)(KTLayouts *layout))completion;
                                                        
/**
 Returns the layoutdata for the given class.
 */
-(KTLayout*)layoutForClassKey:(NSString*) classKey;

/**
 Returns a value that indicates that the layoutdata for a special classkey is already loaded.
 */
-(BOOL)isLayoutLoaded:(NSString*)classKey;

/**
 Returns a value that indicates if all layouts is loaded
 */
@property (nonatomic) BOOL isAllLoaded;

/**
 Clears all Layout data
 */
-(void)clearLayoutData;

@end
