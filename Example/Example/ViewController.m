//
//  ViewController.m
//  test_podspec
//
//  Created by Thorsten Claus on 23.06.15.
//  Copyright (c) 2015 Claus-Software. All rights reserved.
//

#import "ViewController.h"
#import <keytechKit/KTManager.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *serverURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //[KTManager sharedManager].servername = @"https://demo.keytech.de";
    [KTManager sharedManager].servername = @"http://claus-pc.keytech.de:8080/keytech";
    [KTManager sharedManager].username = @"jgrant";
    [[KTManager sharedManager]  synchronizeServerCredentials];
    [[KTServerInfo sharedServerInfo] waitUnitlLoad];
    
    [[KTManager sharedManager] setLicenceKey:@"bla"];

    [[KTServerInfo sharedServerInfo]loadWithSuccess:^(KTServerInfo *serverInfo) {
        
        self.label.text = serverInfo.APIVersion;
        self.serverURL.text = [KTServerInfo sharedServerInfo].baseURL;
        
    } failure:^(NSError *error) {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                       message:error.localizedDescription
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        
    }];

    
    
    [[KTServerInfo sharedServerInfo] waitUnitlLoad];
    NSString *apiversion =  [KTServerInfo sharedServerInfo].APIVersion;

    NSLog(@"APIVersion: %@",apiversion);
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
