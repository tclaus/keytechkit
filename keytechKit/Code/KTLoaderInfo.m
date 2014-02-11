//
//  KTLoaderInfo.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 10.07.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTLoaderInfo.h"

@implementation KTLoaderInfo
@synthesize ressourcePath = _ressourcePath;


+(instancetype)ktLoaderInfo{
    return [[KTLoaderInfo alloc]init];
}


/// Initialies a new instance og this type
+(instancetype)loaderInfoWithResourceString:(NSString *)resourceString{
    
    KTLoaderInfo *loaderInfo = [self new];
    loaderInfo.ressourcePath = resourceString;
    return loaderInfo;
    
}





@end
