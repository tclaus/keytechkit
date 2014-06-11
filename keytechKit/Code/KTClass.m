//
//  KTClass.m
//  keytechKit
//
//  Created by Thorsten Claus on 01.03.14.
//  Copyright (c) 2014 Claus-Software. All rights reserved.
//

#import "KTClass.h"

#import <RestKit/RestKit.h>

@implementation KTClass{
    
    
    /// Is load in progress
    BOOL _isSmallClassImageLoading;
    
    // Das Classimage muss geladen werden
    
    // Kleines und grosses Klassenbild
    // Laden (Async)
    // (Notification senden?
    // Delegate?
    // KVO ?
    
    
    
}
@synthesize isSmallClassImageLoaded = _isSmallImageLoaded;

static RKObjectMapping *_mapping = nil;
static RKObjectManager *_usedManager;
static NSDictionary *_classTypes;


+(NSDictionary*)classApplications{
    if (!_classTypes) {
        
        // List from K_t_ClassTypes Table
        
        _classTypes =@{@"ACAD":@"AutoCAD",
                       @"CATDRAW":@"CATIA",
                       @"CATPART":@"CATIA",
                       @"CATPROD":@"CATIA",
                       @"DWG":@"DWG",
                       @"EPL":@"EPLAN",
                       @"FILE":@"File",
                       @"INVASM":@"Inventor",
                       @"INVDRW":@"Inventor",
                       @"INVIPN":@"Inventor",
                       @"INVPRT":@"Inventor",
                       @"ME10":@"ME10",
                       @"PP":@"Microsoft Office",
                       @"PRJ":@"Microsoft Office",
                       @"PROEASM":@"ProE",
                       @"PROEDRW":@"ProE",
                       @"PROEPRT":@"ProE",
                       @"SCDOC":@"SpaceClaim",
                       @"SEASM":@"Solid Edge",
                       @"SEDFT":@"Solid Edge",
                       @"SEPAR":@"Solid Edge",
                       @"SEPSM":@"Solid Edge",
                       @"SEPWD":@"Solid Edge",
                       @"SLDASM":@"SolidWorks",
                       @"SLDDRW":@"SolidWorks",
                       @"SLDPRT":@"SolidWorks",
                       @"TRIGA":@"Triga",
                       @"UGASM":@"UG",
                       @"UGDRW":@"UG",
                       @"UGPRT":@"UG",
                       @"VIS":@"Microsoft Office",
                       @"WW":@"Microsoft Office",
                       @"XL":@"Microsoft Office",
                       @"GENFILE":@"GenericFile",
                       @"SCAM":@"SolidCAM",
                       @"PL":@"PowerLogic",
                       @"PPCB":@"PowerPCB",
                       @"MGDX":@"DXDesigner",
                       @"PROUT":@"Router",
                       @"PHYP":@"Hyperlynx",
                       @"DSIGHT":@"DraftSight",
                       @"SWE":@"SWElectrical",
                       @"WF":@"Folder"
                       };
    }
    return _classTypes;
}



+(NSInteger)version{
    return 4; //Incement with every class property change!
}

+(RKObjectMapping*)mappingWithManager:(RKObjectManager*)manager{
    
    if (_usedManager !=manager){
        _usedManager = manager;
        
        _mapping = [RKObjectMapping mappingForClass:[KTClass class]];
        [_mapping addAttributeMappingsFromDictionary:@{@"AllowElementCopy":@"classAllowsElementCopy",
                                                       @"ClassKey":@"classKey",
                                                       @"Description":@"classDescription",
                                                       @"Displayname":@"classDisplayname",
                                                       @"HasChangeManagement":@"classHasChangeManagement",
                                                       @"HasVersionControl":@"classHasVersionControl",
                                                       @"IsActive":@"isActive"
                                                       }];
        
        [_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"AttributesList" toKeyPath:@"classAttributesList" withMapping:[KTClassAttribute mappingWithManager:manager]]];
        
        [_usedManager addResponseDescriptor:
         [RKResponseDescriptor responseDescriptorWithMapping:_mapping method:RKRequestMethodAny
                                                 pathPattern:nil
                                                     keyPath:@"ClassConfigurationList"
                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
        
        
    }
    
    return _mapping;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.classVersion = [KTClass version];
    }
    
    return self;
}

-(NSString *)debugDescription{
    return [NSString stringWithFormat:@"%@: %@",self.classKey, self.classDisplayname];
}

-(NSString *)description{
    return self.classDisplayname;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.classVersion = [coder decodeIntegerForKey:@"classVersion"];
        
        self.classAllowsElementCopy = [coder decodeBoolForKey:@"classAllowsElementCopy"];
        self.classKey = [coder decodeObjectForKey:@"classKey"];
        self.classDescription = [coder decodeObjectForKey:@"classDescription"];
        self.classDisplayname = [coder decodeObjectForKey:@"classDisplayName"];
        self.classHasChangeManagement = [coder decodeBoolForKey:@"classHasChangeManagement"];
        self.classHasVersionControl = [coder decodeBoolForKey:@"classHasVersionControl"];
        self.isActive = [coder decodeBoolForKey:@"isActive"];
        self.classAttributesList =[coder decodeObjectForKey:@"classAttributesList"];
        
        
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.classVersion forKey:@"classVersion"];
    
    [aCoder encodeBool:self.classAllowsElementCopy forKey:@"classAllowsElementCopy"];
    [aCoder encodeObject:self.classKey forKey:@"classKey"];
    [aCoder encodeObject:self.classDescription forKey:@"classDescription"];
    [aCoder encodeObject:self.classDisplayname forKey:@"classDisplayName"];
    [aCoder encodeBool:self.classHasVersionControl forKey:@"classHasVersionControl"];
    [aCoder encodeBool:self.classHasChangeManagement forKey:@"classHasChangeManagement"];
    [aCoder encodeBool:self.isActive forKey:@"isActive"];
    [aCoder encodeObject:self.classAttributesList forKey:@"classAttributesList"];
    
}

-(NSString *)classApplicationName{
    if (self.classKey) {
        NSCharacterSet *typeDivider = [NSCharacterSet characterSetWithCharactersInString:@"_"];
        
        NSString *classtype = [[self.classKey componentsSeparatedByCharactersInSet:typeDivider] lastObject];
        return [[KTClass classApplications]objectForKey:classtype];
    }
    return nil;
}

-(NSString *)classType{
    return  [self.classKey ktClassType];
}

-(NSString *)smallClassImageURL{
    return  [NSString stringWithFormat:@"classes/%@/smallImage",self.classKey ];
}
-(NSString *)largeClassImageURL{
    return [NSString stringWithFormat:@"classes/%@/largeImage",self.classKey];
}
@end




