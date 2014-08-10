//
//  KTLayouts.m
//  keytechFoundation
//
//  Created by Thorsten Claus on 25.03.13.
//  Copyright (c) 2013 Claus-Software. All rights reserved.
//

#import "KTLayouts.h"

@implementation KTLayouts{
    KTKeytech* _ktKeytech;

    NSMutableDictionary *_layoutsList;
    
}

    static KTLayouts *_sharedLayouts;

@synthesize delegate;


+(instancetype)sharedLayouts{
    if (!_sharedLayouts) {
        _sharedLayouts = [[KTLayouts alloc]init];
    }

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
            
        }
    } else {
        return _sharedLayouts;
    }
    
    return self;
}



/// Clears all Layout data
-(void)clearLayoutData{
    [_layoutsList removeAllObjects];
}

-(BOOL)isLayoutLoaded:(NSString*)classKey{
    return ([_layoutsList objectForKey:classKey] !=nil);
}


/// Starts loading layout for the given classkey
-(void)loadLayoutForClassKey:(NSString*)classKey {
    
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
                          KTLayout* layout = (KTLayout*)[_layoutsList valueForKey:classKey];
                          layout.editorLayout = mappingResult.array;
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          
                          
                      }];
    
    [manager getObjectsAtPath:listerResourcePath
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          KTLayout* layout = (KTLayout*)[_layoutsList valueForKey:classKey];
                          layout.listerLayout = mappingResult.array;
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          
                          
                      }];
    
    
}


// Layout für die Klasse abholen
-(KTLayout*)layoutForClassKey:(NSString *)classKey{
 
    if (![_layoutsList valueForKey:classKey]){
        //Holen und per KVO später benachrichtigen
        [_ktKeytech performGetClassEditorLayoutForClassKey:classKey loaderDelegate:self]; //EditorLayout
        [_ktKeytech performGetClassListerLayout:classKey loaderDelegate:self]; // Lister Layout

        // Da Requests Asynchron kommen aber noch nicht in _layoutslist eingetragen wurden, kann dier selbe Anfrage immer wieder kommen, bevor eine
        // Antwort eingegangen ist.
        // Daher hier schon das dictionary auffüllen
        
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

-(void)requestProceedWithError:(KTLoaderInfo *)loaderInfo error:(NSError *)theError{
    
}

/* Suche kehrte mit einem Ergebnis zurück
 */
-(void)requestDidProceed:(NSArray *)searchResult fromResourcePath:(NSString *)resourcePath{
    // Habe nun Layoutcontrols zurückerhalten
    // Der Form /classes/classkey/editorLayout
    // Das in die Cache-Liste einbauen und Signalisieren
    NSArray *pathArray = [resourcePath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    
    NSString *forClassKey = pathArray[1];

    // In layouts einsortieren
    if (![_layoutsList valueForKey:forClassKey]){
        KTLayout *layout =[[KTLayout alloc]init];
        layout.classKey =forClassKey;
        [_layoutsList setValue:layout forKey:forClassKey];
    }

    
    // Set lister and editor arrays
    if ([pathArray[2] isEqualToString:@"editorlayout"]){
        KTLayout* layout = (KTLayout*)[_layoutsList valueForKey:forClassKey];
        layout.editorLayout  = searchResult;
        if (layout.listerLayout) {
            if ([delegate respondsToSelector:@selector(layoutDidLoad:)]){
                [delegate layoutDidLoad:layout];
            }
        }
    }

    if ([pathArray[2] isEqualToString:@"listerlayout"]){
        KTLayout* layout = (KTLayout*)[_layoutsList valueForKey:forClassKey];
        layout.listerLayout  = searchResult;
        if (layout.editorLayout) {
            
            if ([self.delegate respondsToSelector:@selector(layoutDidLoad:)]){
                [self.delegate layoutDidLoad:layout];
            }
        }
        
    }
    
}

@end
