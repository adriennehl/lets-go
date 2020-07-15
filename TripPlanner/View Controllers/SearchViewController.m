//
//  SearchViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/14/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "SearchViewController.h"
#import "TripViewController.h"
#import "LocationCell.h"
#import "APIUtility.h"
#import "Location.h"
#import "Key.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSArray *locations;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.locationsTableView.delegate = self;
    self.locationsTableView.dataSource = self;
    
}

- (void)getRequest {
    [APIUtility getPlaces:self.searchTerm withCompletion: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.locations = [dataDictionary valueForKeyPath:@"candidates"];
            [self.locationsTableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [self.locationsTableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    Location *place = [[Location alloc] initWithPlace: self.locations[indexPath.row]];
    cell = [cell setCell:place];
    return cell;
}

// set search term when value changes
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        self.searchTerm = searchText;
    }
    
}

// show cancel button on type
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

// removed text and hide keyboard on cancel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

// fetch results when search button is clicked
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self getRequest];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"creationSegue"]) {
        TripViewController *destinationViewController = [segue destinationViewController];
        LocationCell *tappedCell = sender;
        // get location of tapped cell
        destinationViewController.place = tappedCell.place;
    }
}

@end
