//
//  MasterViewController.m
//  Example
//
//  Created by Thorsten Claus on 03.09.16.
//  Copyright © 2017 Claus-Software. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import <keytechkit/KTManager.h>
#import <keytechkit/KTQuery.h>

@interface MasterViewController () <UISearchResultsUpdating>

@property NSArray *objects;
@end

@implementation MasterViewController  {
    UISearchController *_searchController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    _searchController.searchBar.text = @"dampf";
 
    [self initializeKeytechAPI];
}


-(void)initializeKeytechAPI {
    NSString *serverURL = @"https://demo.keytech.de";
    NSString *username = @"jgrant";
    // No password so far
    
    // Setup credentials
    [KTManager sharedManager].servername = serverURL;
    [KTManager sharedManager].username = username;
    [[KTManager sharedManager] synchronizeServerCredentials];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    KTPagedObject *paging = [KTPagedObject initWithPage:1
                                                   size:10];

    if (searchController.searchBar.text.length > 1) {
        KTQuery *query = [[KTQuery alloc]init];
        [query queryByText:searchController.searchBar.text           // a text based search
                    fields:nil                  // no special fields
                 inClasses:nil                  // no special keytech classes (all in this case)
                    reload:false                //
                     paged:paging               // use a paging object
                   success:^(NSArray *results) {
                       
                        NSLog(@"Loaded a resultset");
                       // results is a array with KTElement Objects in it
                       _objects = results;
                       [self.tableView reloadData];
                   }
                   failure:^(NSError* error){
                       // Progress the error
                       NSLog(@"Failure reading from API: %@", error);
                   }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        KTElement *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    KTElement *object = self.objects[indexPath.row];
    
    cell.textLabel.text = object.itemName;
    cell.detailTextLabel.text = object.itemDisplayName;
    return cell;
}


@end
