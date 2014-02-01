//
//  RKTestResponseLoader.m
//  RestKit
//
//  Created by Blake Watters on 1/14/10.
//  Copyright (c) 2009-2012 RestKit. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "ResponseLoader.h"


// Set Logging Component

NSString * const TestResponseLoaderTimeoutException = @"TestResponseLoaderTimeoutException";

@interface ResponseLoader ()

@property (nonatomic, assign, getter = isAwaitingResponse) BOOL awaitingResponse;
@property (nonatomic, retain, readwrite) NSObject *response;
@property (nonatomic, copy, readwrite) NSError *error;
@property (nonatomic, retain, readwrite) NSArray *objects;

@end

@implementation ResponseLoader

@synthesize response;
@synthesize objects;
@synthesize error;
@synthesize successful;
@synthesize timeout;
@synthesize cancelled;
@synthesize unexpectedResponse;
@synthesize awaitingResponse;

+ (ResponseLoader *)responseLoader {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        timeout = 8;
        awaitingResponse = NO;
    }

    return self;
}


- (void)waitForResponse {
    awaitingResponse = YES;
    NSDate *startDate = [NSDate date];

    RKLogTrace(@"%@ Awaiting response loaded from for %f seconds...", self, self.timeout);
    while (awaitingResponse) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        if ([[NSDate date] timeIntervalSinceDate:startDate] > self.timeout) {
            [NSException raise:TestResponseLoaderTimeoutException format:@"*** Operation timed out after %f seconds...", self.timeout];
            awaitingResponse = NO;
        }
    }
}

- (void)loadError:(NSError *)theError {
    awaitingResponse = NO;
    successful = NO;
    self.error = theError;
}

- (NSString *)errorMessage {
    if (self.error) {
        return [[self.error userInfo] valueForKey:NSLocalizedDescriptionKey];
    }

    return nil;
}

- (void)request:(NSObject*)request didReceiveResponse:(NSObject *)response {
    // Implemented for expectations
}

- (void)request:(NSObject *)request didLoadResponse:(NSObject *)aResponse {
    // To be done
}

- (void)request:(NSObject *)request didFailLoadWithError:(NSError *)anError {
    // If request is an Object Loader, then objectLoader:didFailWithError:
    // will be sent after didFailLoadWithError:
    if (NO == [request isKindOfClass:[NSObject class]]) {
        [self loadError:anError];
    }

    // Ensure we get no further delegate messages

}

- (void)requestDidCancelLoad:(NSObject *)request {
    awaitingResponse = NO;
    successful = NO;
    cancelled = YES;
}

// Here comes the requests result
-(void)requestDidProceed:(NSArray *)searchResult fromResourcePath:(NSString *)resourcePath{
    self.objects = searchResult;
    awaitingResponse = NO;
    successful = YES;
}


// Request failed
-(void)requestProceedWithError:(KTLoaderInfo*)loaderInfo error:(NSError *)theError{
    
    [self loadError:theError];
}



- (void)objectLoaderDidFinishLoading:(NSObject *)objectLoader {
    // Implemented for expectations
}



@end
