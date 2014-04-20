//
//  KTClass.h
//  keytechKit
//
//  Created by Thorsten Claus on 01.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//
/**
 Represents a keytech class with its definition and all assign attribites.
 */
#import <Foundation/Foundation.h>
#import "KTClassAttribute.h"

@interface KTClass : NSObject <NSCoding>
/**
 Sets the object mapping for this class
 */
+(id)mapping;

- (id)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

/**
 The decoded class version. Must be equal to the objects version
 */
@property (nonatomic) NSInteger classVersion;

/**
 The unique classkey. Has the <classLabel>_<ClassType> notation. eg: "3DSLD_DRW"
 */
@property (nonatomic,copy) NSString *classKey;
/**
 A displayable localized classname
 */
@property (nonatomic,copy) NSString *classDisplayname;
/**
 It should be allowed to create copies of elements with this classtype. However API can not reject newly created elements with the same data as the original.
 */
@property (nonatomic) BOOL classAllowsElementCopy;
/**
 This array contains a full list of class specific attributes (fields). Not all atributes sould be user writeable
 */
@property (nonatomic) NSArray *classAttributesList;
@property (nonatomic,copy) NSString *classDescription;
/**
 If YES any status changes of elements of this class must follow the status change rules defined. 
 Any change of a status may start a status-change-action
 */
@property (assign) BOOL classHasChangeManagement;
/**
 If YES a new version of this class will create a new version number defined on the core system.
 Any client must read the newVersion information to create a well defined new Version. 
 IF NO a client shuld reject this
 */
@property (nonatomic) BOOL classHasVersionControl;
/**
 If NO this class shuld be rejected from creation, editing, searching etc. A client should respect this. However the API core will
 */
@property (nonatomic) BOOL isActive;
@property (nonatomic) NSObject *classInitialStatus;

@property (readonly) BOOL isSmallClassImageLoaded;

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
/// Loads the classimage
-(NSImage*) classSmallImage;
-(NSImage*) classLargeImage;
#else
/// Loads the clasimage
-(UIImage*) classSmallImage;
-(UIImage*) classLargeImage;
#endif

@end





