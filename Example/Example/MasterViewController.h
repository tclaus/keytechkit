//
//  MasterViewController.h
//  Example
//
//  Created by Thorsten Claus on 03.09.16.
//  Copyright © 2017 Claus-Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

