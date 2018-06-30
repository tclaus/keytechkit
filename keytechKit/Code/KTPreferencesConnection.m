//
//  KTPreferencesConnection.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 10.04.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTPreferencesConnection.h"


@implementation KTPreferencesConnection
@synthesize servername =_servername;
@synthesize username = _username;
@synthesize password = _password;

-(NSString*)password {
    if(_password == nil){
        _password = @"";
    }
    return _password;

}
-(void)setPassword:(NSString *)password {
    _password = password;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _servername   = [aDecoder decodeObjectForKey:@"servername"];
        _username   = [aDecoder decodeObjectForKey:@"username"];
        _password   = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder {
    // encoden
    [aCoder encodeObject:self.servername forKey:@"servername"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    
}
@end
