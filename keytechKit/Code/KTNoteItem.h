//
//  SimpleNoteItem.h
//  keytech search ios
//
//  Created by Thorsten Claus on 17.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 A note of a element
 */
@interface KTNoteItem : NSObject

/**
 Sets the object mapping. 
 */
+(id)setMapping;

/**
 Unique nummeric noteID
 */
@property (nonatomic) NSInteger noteID;
/**
 keyvalue of this notetype.
 */
@property (nonatomic,copy) NSString* noteType;
/**
 Main text of the note
 */
@property (nonatomic,copy) NSString* noteText;
/**
 Subjectline of the note
 */
@property (nonatomic,copy) NSString* noteSubject;
/**
 Date of last change
 */
@property (nonatomic,copy) NSDate* noteChangedAt;
/**
 Short name (key) of who did last change
 */
@property (nonatomic,copy) NSString* noteChangedBy;
/**
 Full name of who did last changed this note
 */
@property (nonatomic,copy) NSString* noteChangedByLong;
/**
 Date of creation
 */
@property (nonatomic,copy) NSDate* noteCreatedAt;
/**
 Short name (key) of creator
 */
@property (nonatomic,copy) NSString* noteCreatedBy;
/**
 Long name of creator
 */
@property (nonatomic,copy) NSString* noteCreatedByLong;
@end




