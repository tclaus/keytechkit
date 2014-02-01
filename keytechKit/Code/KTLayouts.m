//
//  KTLayouts.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 25.03.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTLayouts.h"

@implementation KTLayouts{
     KTKeytech* simpleSearch;
}

- (id)init
{
    self = [super init];
    if (self) {
        _layoutsList = [[NSMutableDictionary alloc]initWithCapacity:50];
        simpleSearch= [[KTKeytech alloc]init];
        
    }
    return self;
}


// Layout für die Klasse abholen
-(KTLayout*)layoutForClassKey:(NSString *)classKey{
    
    if (![_layoutsList valueForKey:classKey]){
        //Holen und per KVO später benachrichtigen
        [simpleSearch performGetClassEditorLayoutForClassKey:classKey loaderDelegate:self]; //EditorLayout
        [simpleSearch performGetClassListerLayout:classKey loaderDelegate:self]; // Lister Layout

        // Da Requests Asynchron kommen aber noch nicht in _layoutslist eingetragen wurden, kann dier selbe Anfrage immer wieder kommen, bevor eine
        // Antwort eingegangen ist.
        // Daher hier schon das dictionary auffüllen
        
        // In layouts einsortieren
        if (![_layoutsList valueForKey:classKey]){
            [_layoutsList setValue:[[KTLayout alloc]init] forKey:classKey];
        }
        
        return NULL;
    }	
    
    //
    return (KTLayout*)[_layoutsList valueForKey:classKey];
    
}

/* Suche kehrte mit einem Ergebnis zurück
 */
-(void)requestDidProceed:(NSArray *)searchResult fromResourcePath:(NSString *)resourcePath{
    // Habe nun Layoutcontrols zurückerhalten
    // Der Form /classes/classkey/editorLayout
    // Das in die Cache-Liste einbauen und Signalisieren
    NSArray *pathArray = [resourcePath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    
    NSString *forClassKey = pathArray[2];

    // In layouts einsortieren
    if (![_layoutsList valueForKey:forClassKey]){
        [_layoutsList setValue:[[KTLayout alloc]init] forKey:forClassKey];
    }

    
    // Editor und LIster - Daten einsortieren
    if ([pathArray[3] isEqualToString:@"editorlayout"]){
        KTLayout* layout = (KTLayout*)[_layoutsList valueForKey:forClassKey];
        layout.editorLayout  = searchResult;
    }

    if ([pathArray[3] isEqualToString:@"listerlayout"]){
        KTLayout* layout = (KTLayout*)[_layoutsList valueForKey:forClassKey];
        layout.listerLayout  = searchResult;
    }
    
}

@end
