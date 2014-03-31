//
//  NSCompoundPredicate+PredicateKTFormat.h
//  keytechKit
//
//  Created by Thorsten Claus on 16.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Adds a predicateFormat that is suitable for keytech API queries
 */
@interface NSPredicate (PredicateKTFormat)

-(NSString*)predicateKTFormat;

-(NSString*)predicateKTQueryText;

-(BOOL)isQueryText;

@end



