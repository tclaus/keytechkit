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



/*
 Ruft das Layout für die angegebene Klasse ab
 */
-(KTLayout*)layoutForClassKey:(NSString*) classKey;



@end
