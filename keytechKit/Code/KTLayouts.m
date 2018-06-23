//
//  KTLayouts.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 25.03.13.
//  Copyright (c) 2017 Claus-Software. All rights reserved.
//

#import "KTLayouts.h"
#import "KTManager.h"
#import "KTBaseObject.h"

@interface KTLayouts() {}

/// A block definition to call a fully loaded layout
typedef void(^successfulLadedLayout)(KTLayout *layout);
    

@end

@implementation KTLayouts{
    
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

- (instancetype)init
{
    if (!_sharedLayouts) {
        
        self = [super init];
        if (self) {
            _sharedLayouts = self;
            _layoutsList = [[NSMutableDictionary alloc]initWithCapacity:50];
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
    if (_layoutsList[classKey] !=nil){
        KTLayout *layout =  _layoutsList[classKey];
        return layout.isLoaded;
    } else {
        return NO;
    }
}

// Returns the layout by its classekey
-(KTLayout*)layoutForClassKey:(NSString*) classKey{
    return _layoutsList[classKey];
}


-(void)loadLayoutForClassKey:(NSString *)classKey{
    
    if ([self isLayoutLoaded:classKey]){
        return;
    }
    
    
    __block BOOL awaitingResponse;
    awaitingResponse = YES;
    [self loadLayoutForClassKey:classKey
                            success:^(KTLayout *layout) {
                                awaitingResponse = NO;
                            } failure:^(NSError *error) {
                                awaitingResponse = NO;
                            }];
    
    //Wait...
    
    NSDate *startDate = [NSDate date];
    int timeout = 30;
    
    while (awaitingResponse) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        if ([[NSDate date] timeIntervalSinceDate:startDate] > timeout) {
            awaitingResponse = NO;
            //[NSException raise:TestResponseLoaderTimeoutException format:@"*** Operation timed out after %d seconds...", timeout];
            
        }
    }
    
}


-(void)loadListerLayoutForBOM:(void (^)(NSArray<KTSimpleControl *> *))success failure:(void (^)(NSError *))failure{
  
    NSString *classKey = @"BOM";
    
    if ([self isLayoutLoaded:classKey]) {
        if (success) {
            success([self layoutForClassKey:classKey].listerLayout);
            return;
        }
    }
    
    // In layouts einsortieren
    if (![_layoutsList valueForKey:classKey]){
        KTLayout *layout =[[KTLayout alloc]init];
        layout.classKey =classKey;
        [_layoutsList setValue:layout forKey:classKey];
        
    }
    
    NSString* listerResourcePath = [NSString stringWithFormat:@"classes/%@/listerlayout",classKey];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTSimpleControl mappingWithManager:manager];
    
    [manager getObjectsAtPath:listerResourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          [self layoutDidLoadForClassKey:classKey];
                          KTLayout* layout = (KTLayout*)[self->_layoutsList valueForKey:classKey];
                          layout.listerLayout = mappingResult.array;

                              if (success) {
                                  success(layout.listerLayout);
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                          
                          if (failure) {
                              failure(transcodedError);
                          }
                          
                      }];
    
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
   
    // Dont query again, if already loaded
    // Maybe implement a reload later
    if ([_layoutsList valueForKey:classKey]) {
        KTLayout *layout = (KTLayout*)[_layoutsList valueForKey:classKey];
        if (layout.isLoaded) {
            if (success) {
                success(layout);
                return;
            }
        }
        
    }
    
    [manager getObjectsAtPath:editorResourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          [self layoutDidLoadForClassKey:classKey];
                          // Editor layout was loaded
                          KTLayout* layout = (KTLayout*)[self->_layoutsList valueForKey:classKey];
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
                          KTLayout* layout = (KTLayout*)[self->_layoutsList valueForKey:classKey];
                          layout.listerLayout = mappingResult.array;
                          
                          
                          if (layout.isLoaded) {
                              if (success) {
                                  success(layout);
                              }
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                          
                          if (failure) {
                              failure(transcodedError);
                          }
                          
                      }];
    
    
    
    
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
