//
//  SimpleNoteItem.h
//  keytech search ios
//
//  Created by Thorsten Claus on 17.10.12.
//  Copyright (c) 2012 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 A note can be interpreted as a informative text with a subject line and a body. Will describe an element, a status change or any othe object in the keytech API.
 */
@interface KTNoteItem : NSObject

/**
 Provides the object Mapping for this class and given objectManager
 @param manager A shared RKObjectmanager that contains the connection data to the API
 */
+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager;

/**
 Creates a new note item to be attached under this element 
 @param elementkey The element key on which the note is attached
 */
+(instancetype)noteItemForElementKey:(NSString*)elementkey;

@property (nonatomic) NSString *targetElementKey;

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
 An index line of a note. Mosty the version of the attached element
 */
@property (nonatomic,copy) NSString* noteIndex;

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

/** 
 Saves the current note
 @param success A block to be execute after the note is successfully saved
 @param failure A block to execute after saving the note failed
 */
-(void)saveNote:(void (^)(KTNoteItem *noteItem))success
        failure:(void (^)(KTNoteItem *noteItem, NSError *error))failure;

/**
 Deletes the current note
 @param success A block to be execute after the note is successfully deleted
 @param failure A block to execute after delete the note failed
 */
-(void)deleteNote:(void (^)())success
          failure:(void (^)(KTNoteItem *noteItem, NSError *error))failure;
@end




