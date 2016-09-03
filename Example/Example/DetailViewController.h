//
//  DetailViewController.h
//  Example
//
//  Created by Thorsten Claus on 03.09.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

