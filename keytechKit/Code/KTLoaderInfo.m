//
//  KTLoaderInfo.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 10.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTLoaderInfo.h"

@implementation KTLoaderInfo
@synthesize resourcePath = _resourcePath;
@synthesize response = _response;



/**
 Returns the X-ErrorDescription header if applicable
 */
-(NSString*)description{
    
    NSString *headerDescription =  [[self.response allHeaderFields]objectForKey:@"X-ErrorDescription"];
    if (headerDescription) {
        return headerDescription;
    }
    if ([self.response statusCode] >400)
        return NSLocalizedString(@"Forbidden. Username or password failure or you have no access to the resource", nil);
    
    return [super description];
}

+(instancetype)ktLoaderInfo{
    return [[KTLoaderInfo alloc]init];
}

+(instancetype)loaderInfoWithResourceString:(NSString*)resourceString{
    KTLoaderInfo *loader = [[KTLoaderInfo alloc]initWithResourcePath:resourceString];
    return loader;
}

+(instancetype)loaderInfoWithResponse:(NSHTTPURLResponse*)response resourceString:(NSString*)resourcePath{
    KTLoaderInfo *loader = [[KTLoaderInfo alloc]init];
    
     loader.resourcePath= resourcePath;
    
    loader.response = response;
    return loader;
}

-(id)initWithResourcePath:(NSString*)resource{
    self = [super init];
    if (self) {
        self.resourcePath = resource;

    }
    return self;
}


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


@end
