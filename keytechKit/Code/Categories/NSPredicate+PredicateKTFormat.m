//
//  NSCompoundPredicate+PredicateKTFormat.m
//  keytechKit
//
//  Created by Thorsten Claus on 16.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "NSPredicate+PredicateKTFormat.h"


@implementation NSPredicate (PredicateKTFormat)

-(BOOL)isQueryText{
    
    if ([self class]==[NSCompoundPredicate class]) {
        NSCompoundPredicate *compoundPredicate = (NSCompoundPredicate*)self;
        for (NSPredicate *singlePredicate in compoundPredicate.subpredicates) {
            NSComparisonPredicate *cp = (NSComparisonPredicate*)singlePredicate;
            return cp.isQueryText;
        }
        return NO;
    }
    
    if ([self class]==[NSComparisonPredicate class]) {
        
        NSComparisonPredicate *cPredicate = (NSComparisonPredicate*)self;
        
        if ([cPredicate.leftExpression.keyPath isEqualToString:@"/*text*/"] ){
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

/// Filters the text search String
-(NSString*)predicateKTQueryText{
    if ([self class]==[NSCompoundPredicate class]) {
        NSCompoundPredicate *compoundPredicate = (NSCompoundPredicate*)self;
        for (NSPredicate *singlePredicate in compoundPredicate.subpredicates) {
            NSComparisonPredicate *cp = (NSComparisonPredicate*)singlePredicate;
            
            if ([cp.leftExpression.keyPath isEqualToString:@"/*text*/"]) {
                return [cp.rightExpression constantValue];
            }
            
        }
        
    }
    return @"";
}

/**
 Returns a formatstring with all field-queries. Format is <fieldname> <Operator> <Value>.
 The special predicate 'TEXT' is ripped of and must be fetched separatly
 */
-(NSString*)predicateKTFormat{
    NSMutableString *output = [[NSMutableString alloc]init];
    
    if ([self class]==[NSCompoundPredicate class]) {
        NSCompoundPredicate *compoundPredicate = (NSCompoundPredicate*)self;
        
        for (NSPredicate *singlePredicate in compoundPredicate.subpredicates) {
            if ([singlePredicate class] == [NSComparisonPredicate class]) {
                
                if (![singlePredicate isQueryText]) {
                    
                    if ([output length]>0) {
                        [output appendString:@":"];
                    }
                    [output appendString:[self predicateKTComarison:(NSComparisonPredicate*)singlePredicate]];
                }
                
                
            } else {
                // ??
                
            }
            
        }
        return output;
    }else {
        return [self predicateKTComarison:(NSComparisonPredicate*)self];
    }
    
    
}


-(NSString*)predicateKTComarison:(NSComparisonPredicate*)cp{
    NSMutableString *output = [[NSMutableString alloc]init];
    
    
    [output appendString:cp.leftExpression.keyPath]; // Left Expression
    [output appendString:[cp predicateKTOperatorTypeString]];
    
    if ([[[cp.rightExpression constantValue] className] isEqualToString:@"__NSDate"]) {
        // Date to JSON Convert
        NSDate *date = [cp.rightExpression constantValue];
        
        [output appendString:[NSString stringWithFormat:@"/DATE(%lli)/", [@(floor([date timeIntervalSince1970]*1000))longLongValue]]];
    }else {
        
        [output appendString:[cp.rightExpression description]];
    }
    
    return output;
    
}

-(NSString*)predicateKTOperatorTypeString{
    
    if ([self class] == [NSComparisonPredicate class]) {
        NSComparisonPredicate *cp = (NSComparisonPredicate*)self;
        
        
        switch (cp.predicateOperatorType ) {
            case NSLessThanPredicateOperatorType:
                return @" < ";
                break;
            case NSLessThanOrEqualToPredicateOperatorType:
                return @" <= ";
                break;
            case NSGreaterThanOrEqualToPredicateOperatorType:
                return @" >= ";
                break;
            case NSGreaterThanPredicateOperatorType:
                return @" > ";
                break;
            case NSEqualToPredicateOperatorType:
                return @" = ";
                break;
            case NSNotEqualToPredicateOperatorType:
                return @" <> ";
                break;
            case NSMatchesPredicateOperatorType:
                return @" MATCHES ";
                break;
            case NSLikePredicateOperatorType:
                return @" LIKE ";
                break;
            case NSBeginsWithPredicateOperatorType:
                return @" BEGINSWITH ";
                break;
            case NSEndsWithPredicateOperatorType:
                return @" ENDSWITH ";
                break;
            case NSInPredicateOperatorType:
                return @" IN ";
                break;
            case NSCustomSelectorPredicateOperatorType:
                return @" CUSTOM ";
                break;
            case NSContainsPredicateOperatorType:
                return @" CONTAINS ";
                break;
            case NSBetweenPredicateOperatorType:
                return @" BETWEEN ";
                break;
                
            default:
                return @" ";
                break;
        }
    }else {
        return @"";
    }
}

@end




