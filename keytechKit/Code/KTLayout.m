//
//  KTLayout.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTLayout.h"

@implementation KTLayout

static KTKeytech* simpleSearch = nil;

@synthesize listerLayout =_listerLayout;
@synthesize editorLayout = _editorLayout;



- (id)init
{
    self = [super init];
    if (self) {
        if (!simpleSearch){
            simpleSearch = [[KTKeytech alloc]init];
        }
    }
    return self;
}


@end
