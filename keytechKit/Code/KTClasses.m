//
//  KTClasses.m
//  Pods
//
//  Created by Thorsten Claus on 17.04.16.
//
//

#import "KTClasses.h"
#import "KTManager.h"

@implementation KTClasses {
    NSMutableDictionary* _classList;
    BOOL _isClassListLoading;
    BOOL _isLoaded;
}

+(instancetype)sharedClasses {
    static KTClasses *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KTClasses alloc]init];
        
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _classList = [[NSMutableDictionary alloc]init];
        _isClassListLoading = NO;
        _isLoaded = NO;
        
    }
    return self;
}

/**
 Returns the classlist by its key
 */
-(KTClass *)classByClassKey:(NSString *)classKey {
    
    if (_isClassListLoading) {
        return nil;
    }
    
    if (!_isLoaded) {
        [self initClassList];
        return nil;
    }
    
    return _classList[classKey];
    
}

-(void)initClassList{
    
    // Force a reload in case of a server change
    
    
    [KTClasses loadClassListSuccess:^(NSArray<KTClass*> *classList) {
        
        [self->_classList removeAllObjects];
        for (KTClass* aClass in classList) {
            self->_classList[aClass.classKey] = aClass;
        }
        self->_isLoaded = YES;
        self->_isClassListLoading = NO;
        
    } failure:^(NSError* error){
        self->_isClassListLoading = NO;
    }
     ];
    
}

+(void)loadClassListSuccess:(void (^)(NSArray<KTClass*> * classList))success failure:(void (^)(NSError *))failure
{
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [KTClass mappingWithManager:manager];
    
    NSString *resourcePath = @"classes";
    
    [manager getObjectsAtPath:resourcePath parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          if (success) {
                              success([mappingResult.array mutableCopy]);
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSError *transcodedError = [KTManager translateErrorFromResponse:operation.HTTPRequestOperation.response error:error];
                          
                          if (failure) {
                              failure(transcodedError);
                          }
                      }];
}

@end
