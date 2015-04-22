//
//  KTPagedObject.m
//  keytechKit
//
//  Created by Thorsten Claus on 22.09.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTPagedObject.h"

@implementation KTPagedObject
// Paged: a Size/Page object

@synthesize page =_page;
@synthesize size =_size;

-(void)setPage:(int)page{
    if (page>=0) {
        _page = page;
    }
}


-(void)setSize:(int)size{
    if (size>=0) {
        _size = size;
    }
}

/// Initializes the page Object with default avlues for page and size
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.size = 100;
    }
    return self;
}


+(instancetype)initWithPage:(unsigned int)page size:(unsigned int)size{
    KTPagedObject *pagedObject = [[KTPagedObject alloc]init];
    pagedObject.page = page;
    pagedObject.size = size;
    return pagedObject;
}

@end
