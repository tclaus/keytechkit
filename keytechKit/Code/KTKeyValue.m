//
//  KTKeyValue.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 17.04.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTKeyValue.h"
#import <RestKit/RestKit.h>


@implementation KTKeyValue

static RKObjectMapping *_mapping;
static RKObjectManager *_usedManager;


+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager) {
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTKeyValue class]];
        
        [_mapping addAttributeMappingsFromDictionary:@{@"Key":@"key",
                                                       @"Value":@"value"}];
        
        RKResponseDescriptor *keyValues = [RKResponseDescriptor responseDescriptorWithMapping:_mapping method:RKRequestMethodAny pathPattern:nil keyPath:@"KeyValueList" statusCodes:nil];
       
        RKResponseDescriptor *serverkeyValues = [RKResponseDescriptor responseDescriptorWithMapping:_mapping method:RKRequestMethodAny pathPattern:nil keyPath:@"ServerInforesult" statusCodes:nil];
        
        [_usedManager addResponseDescriptorsFromArray:@[keyValues,serverkeyValues]];
        
    }
    
    return _mapping;
    
}

/// Returns teh Value as a datetype
-(NSDate*)valueAsDate{
    return [KTKeyValue dateFromJSONString:self.value];
}


/// Returns the actual value as a bool type.
-(BOOL)valueAsBool{
    if ([self.value isEqualToString:@"true"] ||
        [self.value isEqualToString:@"yes"] )
        //||                ![value isEqualToNumber:[NSNumber numberWithInt:0]]
    {
        return YES;
    }
    if ([self.value isEqualToString:@"false"] ||
        [self.value isEqualToString:@"no"] )
        //||                ![value isEqualToNumber:[NSNumber numberWithInt:0]]
    {
        return NO;
    }
    
    // Could not interpret the value
    return NO;
}


/**
 Tests for date occurence in JSON value. Returns nil if not convertible.
 */
+ (NSDate*) dateFromJSONString:(NSString *)dateString
{
    if ([dateString rangeOfString:@"/Date("].location  == NSNotFound) return nil;
    
    NSCharacterSet *charactersToRemove = [[ NSCharacterSet decimalDigitCharacterSet ] invertedSet ];
    NSString* milliseconds = [dateString stringByTrimmingCharactersInSet:charactersToRemove];
    
    if (milliseconds != nil && ![milliseconds isEqualToString:@"62135596800000"]) {
        NSTimeInterval  seconds = [milliseconds doubleValue] / 1000;
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

-(NSString *)debugDescription{
    return [NSString stringWithFormat:@"KEY:%@ VALUE:%@",self.key,self.value];
}

@end
