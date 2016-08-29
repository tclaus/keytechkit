//
//  KTClass.h
//  keytechKit
//
//  Created by Thorsten Claus on 01.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//
/**
 Represents a keytech class with its definition and all assign attributes.
 Every element lives in a class of a distinct type. A Class has properties which describes ist behavior. 
 
 There are three main classifications: Documents, Items and Folders. 
 Documents and Folders can have subtypes described in classtype and class labes such as "FileTypes", "3D CAD Files" or "Customer Folder", "Misc Folder"
 and so on.
 */
#import <Foundation/Foundation.h>
#import "KTClassAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface KTClass : NSObject <NSCoding>


/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

- (id)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

/**
 Returns a dictionary with ClassType names mapped to its application name
 */
+(NSDictionary <NSString*,NSString*> *)classApplications;

/**
 The decoded class version. Must be equal to the objects version
 */
@property (nonatomic) NSInteger classVersion;

/**
 The unique classkey. Has the <classLabel>_<ClassType> notation. eg: "3DSLD_DRW"
 */
@property (nonatomic,copy) NSString * classKey;

/**
 The non localized application name of this classtype. This is the main application for filecontents in this class or a base name.
 */
@property (nonatomic,readonly) NSString *classApplicationName;
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
@property (nonatomic) NSArray <KTClassAttribute*> *classAttributesList;
/**
 A non localized descriptive text of a class
 */
@property (nonatomic,copy) NSString *classDescription;
/**
 If YES any status changes of elements of this class must follow the status change rules defined. 
 Any change of a status may start a status-change-action
 */
@property (assign) BOOL classHasChangeManagement;

/**
 A YES indicates that new elements of this class use a auto number generator to set its unique name property. 
 A client must not fill the name attribute manually.
 If NO every new element of this classtype must have a unique new name set by the client.
 */
@property (assign) BOOL classHasNumberGenerator;

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

/**
 For informative purposes: A newly created element of this classtype will have an initial status descibed in this object
 */
@property (nonatomic) NSObject *classInitialStatus;

@property (readonly) BOOL isSmallClassImageLoaded;

/// Returns a URL to load the small class Image
@property (readonly,copy) NSString *smallClassImageURL;

/// Returns a URL to load the large Class Image
@property (readonly,copy) NSString *largeClassImageURL;

/**
 Returns the main classtype as a string value. One of DO,MI,FD.
 */
@property (readonly,copy) NSString *classType;

/**
 Loads a specific class by its classKey
 @param classKey A Classkey e.g: Default_MI
 @param success Will be called after class definition is received
 @param failure A failure handler
 */
+(void)loadClassByKey:(NSString*)classKey
              success:(void(^)(KTClass* ktclass))success
              failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END



