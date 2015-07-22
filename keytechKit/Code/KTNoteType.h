//
//  KTNoteType.h
//  Pods
//
//  Created by Thorsten Claus on 22.07.15.
//
//

#import <Foundation/Foundation.h>

/**
 A simple type of a note. Contains information about permission and valid conetexts.
 */
@interface KTNoteType : NSObject

@property (nonatomic) NSString *noteTypeID;
@property (nonatomic) BOOL allowModify;
@property (nonatomic) BOOL isPostItType;
@property (nonatomic) NSString *displaytext;
@property (nonatomic) BOOL isFolderInfo;
@property (nonatomic) BOOL isMasteritemInfo;
@property (nonatomic) BOOL isDocumentInfo;
@property (nonatomic) BOOL isSystemInfo;
@property (nonatomic) BOOL shouldCopyOnElementCopy;
@property (nonatomic) BOOL shouldCopyOnNewVersion;

/**
 Returns a list of current valid notetypes
 */
+(void)loadNoteTypesSuccess:(void (^)(NSArray *noteTypes))success failure:(void (^)(NSError *error))failure;

@end
