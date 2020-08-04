//
//  ContactsViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 8/3/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "ContactsViewController.h"
#import "UserCell.h"
#import "UsersTableViewUtility.h"
#import <Parse/Parse.h>

@interface ContactsViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (strong, nonatomic) UsersTableViewUtility *usersTableUtility;
@property (strong, nonatomic) NSMutableArray *contacts;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contacts = PFUser.currentUser[@"contacts"];
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    
    self.usersTableUtility = [[UsersTableViewUtility alloc] init];
    self.usersTableView.delegate = self.usersTableUtility;
    self.usersTableView.dataSource = self.usersTableUtility;
    
    self.searchBar.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    cell = [cell setCell:self.contacts[indexPath.row]];
    return cell;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
    [self.usersTableView setHidden:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // update users table view
    [self.usersTableUtility updateSearch:searchText withCompletion:^(BOOL finished) {
        [self.usersTableView reloadData];
    }];
}

// removed text and hide keyboard on cancel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.usersTableView setHidden:YES];
}

// fetch results when search button is clicked
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
