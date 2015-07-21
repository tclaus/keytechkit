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

@interface testNotes : XCTestCase

@end

@implementation testNotes
{
@private

    NSString* elementKeyWithNotes;// = @"2DMISC_SLDDRW:2221"; //* Element with notes on Test API
    TestDefaults *_testdefaults;
    
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
 Creates a new note for this sepcific element
 */
-(void)testCreateNote{
    
    KTElement* element = [[KTElement alloc]initWithElementKey:elementKeyWithNotes];
    XCTestExpectation *expectation = [self expectationWithDescription:@"saveing notes"];
    
    KTNoteItem *newNote = [KTNoteItem noteItemForElementKey:element.itemKey];
    newNote.noteSubject = @"Dummy for Test";
    newNote.noteText = @"Lorem Ipsum";
   
    [newNote saveNote:^(KTNoteItem *noteItem) {
        [expectation fulfill];
    } failure:^(KTNoteItem *noteItem, NSError *error) {
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Failed uploading a file: %@",error);
        }
        
    }];
    
}

@end






