//
//  KTLayouts.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 25.03.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTLayouts.h"

@interface KTLayouts() {}
    typedef void(^successfulLadedLayout)(KTLayout *layout);
    

@end

@implementation KTLayouts{
    KTKeytech* _ktKeytech;
    
    /// A list of all layouts for all classes
    NSMutableDictionary *_layoutsList;
    
}
@synthesize isAllLoaded = _isAllLoaded;

static KTLayouts *_sharedLayouts;


+(instancetype)sharedLayouts{
    
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedLayouts = [[KTLayouts alloc]init];
    });
    
    return _sharedLayouts;
}

- (id)init
{
    if (!_sharedLayouts) {
        
        self = [super init];
        if (self) {
            _sharedLayouts = self;
            _layoutsList = [[NSMutableDictionary alloc]initWithCapacity:50];
            _ktKeytech= [[KTKeytech alloc]init];
            _isAllLoaded = NO;
        }
    } else {
        return _sharedLayouts;
    }
    
    return self;
}



/// Clears all layout data
-(void)clearLayoutData{
    [_layoutsList removeAllObjects];
    _isAllLoaded = NO;
}

-(BOOL)isLayoutLoaded:(NSString*)classKey{
    return ([_layoutsList objectForKey:classKey] !=nil);
}



-(void)loadLayoutForClassKey:(NSString *)classKey{
        [self loadLayoutForClassKey:classKey
                            success:nil
                            failure:nil];
}

/// Starts loading layout for the given classkey
-(void)loadLayoutForClassKey:(NSString *)classKey
                     success:(void (^)(KTLayout *))success
                     failure:(void (^)(NSError *))failure {
    

    if (!classKey) {
        return;
    }
    
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTSimpleControl mappingWithManager:manager];
    
    classKey = [KTBaseObject normalizeElementKey:classKey];
    
    
    NSString* editorResourcePath = [NSString stringWithFormat:@"classes/%@/editorlayout", classKey];
    NSString* listerResourcePath = [NSString stringWithFormat:@"classes/%@/listerlayout", classKey];
    
    // In layouts einsortieren
    if (![_layoutsList valueForKey:classKey]){
        KTLayout *layout =[[KTLayout alloc]init];
        layout.classKey =classKey;
        [_layoutsList setValue:layout forKey:classKey];
        
    }
   
    
    
    [manager getObjectsAtPath:editorResourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          [self layoutDidLoadForClassKey:classKey];
                          // Editor layout was loaded
                          KTLayout* layout = (KTLayout*)[_layoutsList valueForKey:classKey];
                          layout.editorLayout = mappingResult.array;
                          
                          
                          if (layout.isLoaded) {
                              if (success) {
                                  success(layout);
                              }
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          
                          
                      }];
    
    [manager getObjectsAtPath:listerResourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        
                          [self layoutDidLoadForClassKey:classKey];
                          // Lister layout was loaded
                          KTLayout* layout = (KTLayout*)[_layoutsList valueForKey:classKey];
                          layout.listerLayout = mappingResult.array;
                          
                          
                          if (layout.isLoaded) {
                              if (success) {
                                  success(layout);
                              }
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          
                          
                      }];
    
    
    
    
}


// Layout für die Klasse abholen
-(KTLayout*)layoutForClassKey:(NSString *)classKey{
 
    if (![_layoutsList valueForKey:classKey]){
        
        
        // In layouts einsortieren
        if (![_layoutsList valueForKey:classKey]){
            KTLayout *layout =[[KTLayout alloc]init];
            layout.classKey =classKey;
            [_layoutsList setValue:layout forKey:classKey];
            
        }
        
        return NULL;
    }	
    
    //
    return (KTLayout*)[_layoutsList valueForKey:classKey];
    
}

/**
 Add to layout list an return YES if layout is fully loaded
 */
-(void)layoutDidLoadForClassKey:(NSString*)classKey{

    // Add to Layouts list
    if (![_layoutsList valueForKey:classKey]){
        KTLayout *layout =[[KTLayout alloc]init];
        layout.classKey =classKey;
        [_layoutsList setValue:layout forKey:classKey];
    }

}

@end
