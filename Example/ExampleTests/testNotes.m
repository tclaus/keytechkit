//
//  testNotes.m
//  keytechKit
//
//  Created by Thorsten Claus on 20.07.15.
//  Copyright (c) 2015 Claus-Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTManager.h"
#import "KTElement.h"
#import "testResponseLoader.h"
#import "TestDefaults.h"
#import "KTNoteItem.h"
#import "KTNoteType.h"

@interface testNotes : XCTestCase

@end

@implementation testNotes
{
@private

    NSString* elementKeyWithNotes;// = @"2DMISC_SLDDRW:2221"; //* Element with notes on Test API
    TestDefaults *_testdefaults;
    NSArray* loadedNoteTypes;

}

- (void)setUp
{
    [super setUp];
    
    _testdefaults =[[TestDefaults alloc]init];
    [_testdefaults setUp];
    
    // Put setup code here; it will be run once, before the first test case.
    

    elementKeyWithNotes = @"2DMISC_SLDDRW:2221"; //* Element with notes on Test API

}

/**
 Loads a list of note Types
 */
-(void)testLoadNoteTypes{
    XCTestExpectation *expectation = [self expectationWithDescription:@"load notetypes"];
    
    [KTNoteType loadNoteTypesSuccess:^(NSArray *noteTypes) {
        loadedNoteTypes = noteTypes;
        
        if (loadedNoteTypes.count == 0 ) {
            XCTFail(@"Could not load any note types");
        } else {
            NSLog(@"Loaded %lu notetypes",(unsigned long)noteTypes.count);
            KTNoteType *noteType = noteTypes[0];
            NSLog(@"Notetype: %@",noteType.displaytext);
        }
        
        [expectation fulfill];
        
    } failure:^(NSError *error) {
        XCTFail(@"Failed with error: %@",error);
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Failed loading notetypes with error: %@",error);
        }
        
    }];
    
}

/**
 Creates a new note for this sepcific element
 */
-(void)testCreateNote{
    
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithNotes];
    XCTestExpectation *expectation = [self expectationWithDescription:@"saving notes"];
    
    KTNoteItem *newNote = [KTNoteItem noteItemForElementKey:element.itemKey];
    newNote.noteSubject = @"Dummy for Test";
    newNote.noteText = @"Lorem Ipsum";
    newNote.noteType = @"NOTE";
    [newNote saveNote:^(KTNoteItem *noteItem) {
        
        NSLog(@"Note created: %@",noteItem);
        
        [expectation fulfill];
    } failure:^(KTNoteItem *noteItem, NSError *error) {
        XCTFail(@"Could not create a note: %@",error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Failed creating a note with error: %@",error);
        } else {
            // Delete it
            [newNote deleteNote:^{
                // Do nothing
            } failure:^(KTNoteItem * _Nonnull noteItem, NSError * _Nonnull error) {
                // do nothing
            }];
        }
        
    }];
    

}

/**
 Deletes a note on a test element
 */
-(void)testDeleteNote{
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithNotes];
    XCTestExpectation *expectation = [self expectationWithDescription:@"delete notes"];
    
    KTNoteItem *newNote = [KTNoteItem noteItemForElementKey:element.itemKey];
    newNote.noteSubject = @"Dummy for Test";
    newNote.noteText = @"Lorem Ipsum";
    newNote.noteType = @"NOTE";
    [newNote saveNote:^(KTNoteItem *noteItem) {
        
        NSLog(@"Note created: %@, now delete it!",noteItem);
        
        
        [noteItem deleteNote:^{
            NSLog(@"Note was deleted successfully");
            [expectation fulfill];
            
        } failure:^(KTNoteItem *noteItem, NSError *error) {
            XCTFail(@"Could not delete a note: %@",error);
            [expectation fulfill];
        }];
        
    } failure:^(KTNoteItem *noteItem, NSError *error) {
        XCTFail(@"Could not create a note: %@",error);
        [expectation fulfill];
    }];
    
    
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Failed deleting a note with error: %@",error);
        }
        
    }];
    
    
    
}

/**
 Updates an existing note for a sepcific element
 */
-(void)testEditNote{
    
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithNotes];
    XCTestExpectation *expectation = [self expectationWithDescription:@"saving notes"];
    
    KTNoteItem *newNote = [KTNoteItem noteItemForElementKey:element.itemKey];
    newNote.noteSubject = @"Dummy for Test";
    newNote.noteText = @"Lorem Ipsum";
    newNote.noteType = @"NOTE";
    [newNote saveNote:^(KTNoteItem *noteItem) {
        
        NSLog(@"Note created: %@",noteItem);
        
        noteItem.noteText = @"New, edited Text";
        [noteItem saveNote:^(KTNoteItem *noteItem) {
            
            NSLog(@"Note edited!");
            [expectation fulfill];
            
        } failure:^(KTNoteItem *noteItem, NSError *error) {
            XCTFail(@"Failed edit a note");
            [expectation fulfill];
        }];
        
        
        
    } failure:^(KTNoteItem *noteItem, NSError *error) {
        XCTFail(@"Could not create a note: %@",error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Failed creating a note with error: %@",error);
        } else {
            // Delete it
            [newNote deleteNote:^{
                // Do nothing
            } failure:^(KTNoteItem * _Nonnull noteItem, NSError * _Nonnull error) {
                // do nothing
            }];
        }
        
    }];
    
    
}

@end






