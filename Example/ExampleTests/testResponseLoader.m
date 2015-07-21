//
//  testResponseLoader.m
//  keytechKit
//
//  Created by Thorsten Claus on 02.02.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "testResponseLoader.h"

@implementation testResponseLoader{
    int timeout;
    BOOL awaitingResponse;
    
}

NSString * const TestResponseLoaderTimeoutException = @"TestResponseLoaderTimeoutException";

@synthesize objects = _objects;
@synthesize firstObject = _firstObject;
@synthesize error =_error;

// Loads a new responseLoader object

+ (testResponseLoader *)responseLoader {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        timeout = 20;
        awaitingResponse = NO;
    }
    
    return self;
}

- (void)waitForResponse {
    awaitingResponse = YES;
    NSDate *startDate = [NSDate date];
    
    while (awaitingResponse) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        if ([[NSDate date] timeIntervalSinceDate:startDate] > timeout) {
            awaitingResponse = NO;
            //[NSException raise:TestResponseLoaderTimeoutException format:@"*** Operation timed out after %d seconds...", timeout];
            
        }
    }
}

-(void)requestDidProceed:(NSArray *)searchResult fromResourcePath:(NSString *)resourcePath{
    awaitingResponse = NO;
    self.objects = searchResult;
    
    if (searchResult !=nil)
        if (searchResult.count>0)
            self.firstObject = searchResult[0];
    

}

-(void)requestProceedWithError:(id)loaderInfo error:(NSError *)theError{
    awaitingResponse = NO;
    self.error = theError;
    
}


@end





