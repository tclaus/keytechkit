//
//  KTLayout.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTLayout.h"
#import "NSString+ClassType.h"

@implementation KTLayout{
    
}


@synthesize listerLayout =_listerLayout;
@synthesize editorLayout = _editorLayout;
@synthesize classVersion = _classVersion;
@synthesize classKey = _classKey;


+(NSInteger)version{
    return 7; // Dev notice: Increment if definition if header changes
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.classVersion = [coder decodeIntegerForKey:@"classVersion"];
        self.listerLayout = [coder decodeObjectForKey:@"listerLayout"];
        self.editorLayout = [coder decodeObjectForKey:@"editorLayout"];
        self.classKey = [coder decodeObjectForKey:@"classKey"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.classVersion forKey:@"classVersion"];
    [aCoder encodeObject:self.listerLayout forKey:@"listerLayout"];
    [aCoder encodeObject:self.editorLayout forKey:@"editorLayout"];
    [aCoder encodeObject:self.classKey forKey:@"classKey"];

}

-(NSString *)classType{
    return  [self.classKey ktClassType];
}



-(BOOL)isLoaded{
    
    if ([self.classKey isEqualToString:@"BOM"]) {
        return _listerLayout !=nil;
    } else {
        
        return (_listerLayout !=nil && _editorLayout !=nil);
    }
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {

            self.classVersion = [KTLayout version];
    }
    return self;

}


@end
