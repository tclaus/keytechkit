//
//  KTResponseLoader.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 02.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//
// Should provide a capsule for external request delegates


#import "KTResponseLoader.h"

@implementation KTResponseLoader{
    int _timeout;
    BOOL _awaitingResponse;
    BOOL _requestTimeout;
}


@synthesize objects = _objects;
@synthesize firstObject = _firstObject;
@synthesize error =_error;
@synthesize loaderInfo = _loaderInfo;


- (id)init {
    self = [super init];
    if (self) {
        _timeout = 20; // Timeout in seconds
        _awaitingResponse = NO;
    }
    
    return self;
}

/// If a timeout occured in WaitForResponse, no lOaderinfo or error object is send
-(BOOL)requestTimeout{
    return _requestTimeout;
}

- (void)waitForResponse {
    _awaitingResponse = YES;
    NSDate *startDate = [NSDate date];
    
    while (_awaitingResponse) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        if ([[NSDate date] timeIntervalSinceDate:startDate] > _timeout) {
            _awaitingResponse = NO;
            //[NSException raise:TestResponseLoaderTimeoutException format:@"*** Operation timed out after %d seconds...", timeout];
            _requestTimeout = YES;
        }
    }
}

-(void)requestDidProceed:(NSArray *)searchResult fromResourcePath:(NSString *)resourcePath{
    _awaitingResponse = NO;
    self.objects = searchResult;
    
    if (searchResult !=nil)
        if (searchResult.count>0)
            self.firstObject = searchResult[0];
    
    
}

-(void)requestProceedWithError:(id)loaderInfo error:(NSError *)theError{
    _awaitingResponse = NO;
    self.error = theError;
    _loaderInfo = loaderInfo;
    
}


@end
