//
//  KTClasses.h
//  Pods
//
//  Created by Thorsten Claus on 17.04.16.
//
//

#import <Foundation/Foundation.h>
#import <KTClass.h>

/**
 Provides the full classlist of the server. In keytech terms a class is the definition of an elementtype.
 */
@interface KTClasses : NSObject

/**
 Returns the shared classes Object
 */
+(instancetype)sharedClasses;

-(KTClass*)classByClassKey:(NSString*) classKey;

/**
 Loads the classlist from WebAPI Server
 */
-(void)initClassList;


/**
 Load a list of available classes
 @param success Called after the object is successfully loaded
 @param failure Called when the object could not be loaded. The error object will have a localized error message
 */
+(void)loadClassListSuccess:(void(^)(NSArray<KTClass*> * classList))success
                    failure:(void(^)(NSError *error))failure;



@end
