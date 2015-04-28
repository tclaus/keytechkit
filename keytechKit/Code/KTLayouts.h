//
//  KTLayouts.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 25.03.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTLayout.h"

/**
 Provides a list of classes and its specific layout data. 
 A Layout has always Editor controls (for just one elememnt and for user inputs) and Lister columns (for displaying masses of elememts in a table)
 */
@interface KTLayouts : NSObject


/// Returns the shared instance of layouts
+(instancetype)sharedLayouts;

/**
Loads a layout -Editor and lister- and waits until layout is loaded.
@param classKey of type classtype_classlabel. E.G.: Default_MI or 3DMISC_SLDDRW
 */
-(void)loadLayoutForClassKey:(NSString*)classKey;

/**
 Starts loading a special layout for the given classkey.
 @param classKey The classkey eg: 3DSLD_DRW to load the layout data for the current user context.
 @param success A success block will excecuted after loading the layout.
 @param failure A failure block. Will only fail in case of a server error or an unknown classkey. 
 */
-(void)loadLayoutForClassKey:(NSString*)classKey success:(void(^)(KTLayout *layout))success
                     failure:(void(^)(NSError* error))failure;

/**
 Loads the layout for BOM (Bill Of Material). Remember that BOM has only a lister layout. Not an editor layout. 
 @param success Will be called when request responds successfully
 @param failure Will be called in case of any error
 */
-(void)loadListerLayoutForBOM:(void(^)(NSArray* controls))success failure:(void(^)(NSError* error))failure;
                               

/**
 Starts loading all layouts for the current user
 */
//-(void)loadLayoutsWithCompletion:(void(^)(KTLayouts *layout))completion;
                                                        
/**
 Returns the layoutdata for the given class.
 @param classKey of type classtype_classlabel. E.G.: Default_MI or 3DMISC_SLDDRW
 */
-(KTLayout*)layoutForClassKey:(NSString*) classKey;

/**
 Returns a value that indicates that the layoutdata for a special classkey is already loaded.
 @param classKey of type classtype_classlabel. E.G.: Default_MI or 3DMISC_SLDDRW
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
