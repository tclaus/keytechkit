//
//  KTElementPermissionList.h
//  Pods
//
//  Created by Thorsten Claus on 23.07.15.
//
//

#import <Foundation/Foundation.h>

@interface KTElementPermissionList : NSObject

/**
 Returns a value of true if current user can show this element. YES (true) normally.
 */
@property (nonatomic) BOOL allowShowElement;
/**
 Returns a value of true if current user can modify this element.
 */
@property (nonatomic) BOOL allowModifyElement;
/**
 Returns a value of true if current user can delete this element.
 */
@property (nonatomic) BOOL allowDeleteElement;
/**
 Returns a value of true if current user can change status of this element
 */
@property (nonatomic) BOOL allowChangeStatus;
/**
 Returns a value of true if current user is allowed to link this element. 
 */
@property (nonatomic) BOOL allowLinkElement;
/**
 Returns a value of true if current user can reserve this element. Reserved elements has a file lock. No other user can change the file or metadata of this element if true
 */
@property (nonatomic) BOOL allowReserveElement;
/**
 Returns a value iof true if current user can release a reservation
 */
@property (nonatomic) BOOL allowUnreserveElement;

// Only if a childElementkey - parameter was set

/**
  Returns a permission to create a Link. Returns NO (false) in no childElement was set
 */
@property (nonatomic) BOOL allowCreateLink;

/**
 Returns a permission to delete an existing link. Returns NO (false) in no childElement was set
 */
@property (nonatomic) BOOL allowDeleteLink;
@end
