//
//  KTTask.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 25.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTTask : NSObject

/// Sets the attribute-Mapping
+(id)setMapping;


@property (nonatomic,copy) NSString* assignedUserName;
@property (nonatomic,copy) NSString* assignedUserNameLong;
/**
 Provides a semicolon-seperated list of attached elementkeys
 */
@property (nonatomic,copy) NSString* attachments;

/**
 The tasks message body. can be in RTF Format
 */
@property (nonatomic,copy) NSString* body;

/**
 Name of creator of this task
 */
@property (nonatomic,copy) NSString* createdBy;
@property (nonatomic,copy) NSString* createdByLong;

/**
 The date on which this task starts.
 */
@property (nonatomic,copy) NSDate* startDate;
/**
 If the tasks is finished - this is the enddate.
 */
@property (nonatomic,copy) NSDate* endDate;

@property (nonatomic) NSInteger finished;
@property (nonatomic,copy) NSString* taskID;

/**
 Tasks short description
 */
@property (nonatomic,copy) NSString* name;

@property (nonatomic) NSDate* plannedEnd;
@property (nonatomic) NSDate* plannedStart;

@property (nonatomic) NSInteger priority;
@property (nonatomic,copy) NSString* priorityText;

@property (nonatomic,copy)NSString* projectID;

/**
 If not nil or mindate this will start a remindert at the given time
 */
@property (nonatomic,copy) NSDate* reminderAt;

@property (nonatomic) NSInteger statusID;
/**
 Simple user defined task or assigned job.
 */
@property (nonatomic) NSString* taskType;

/**
 The localized status text of this task
 */
@property (nonatomic) NSString* warnLevel;

@end














