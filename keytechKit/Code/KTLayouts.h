//
//  KTLayouts.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 25.03.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTLayout.h"
#import "KTKeytech.h"

@interface KTLayouts : NSObject <KTLoaderDelegate>{
    
    NSMutableDictionary* _layoutsList;
    
}

/// Returns the shared instance of layouts
+(instancetype)sharedLayouts;

/**
 Returns the layoutdata for the given class
 */
-(KTLayout*)layoutForClassKey:(NSString*) classKey;



@end
