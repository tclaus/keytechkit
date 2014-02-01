//
//  KTLayout.h
//  keytechFoundation
//
//  Created by Thorsten Claus on 01.01.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTSimpleControl.h"
#import "KTKeytech.h"

/**
 Stellt Layoutdaten für eine Klasse bereit (Lister und Editor) bereit
 */
@interface KTLayout : NSObject


/**
 Ruft die Controls-Liste des Listers ab
 */
@property (nonatomic,copy) NSArray* listerLayout;

/**
 Ruft die Controls-Liste des Editors ab */
@property (nonatomic,copy) NSArray* editorLayout;

@end
