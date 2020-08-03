//
//  TripStreamViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TripStreamViewController.h"
#import "TripDetailViewController.h"
#import "Trip.h"
#import "TripCell.h"
#import "ParseUtility.h"

@interface TripStreamViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tripsTableView;
@property (strong, nonatomic) NSArray *trips;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TripStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tripsTableView.delegate = self;
    self.tripsTableView.dataSource = self;
    
    // add a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTrips) forControlEvents:UIControlEventValueChanged];
    [self.tripsTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.activityIndicator startAnimating];
    [self fetchTrips];
}

// get trips from user's trips relation
- (void)fetchTrips {
   // update user's list of trips
    [ParseUtility updateCurrentUserTrips];
    
    PFRelation *relation = [PFUser.currentUser relationForKey:@"trips"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"startDate"];
    [query whereKey:@"endDate" greaterThan:[NSDate date]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
      if (!error) {
          self.trips = trips;
          [self.tripsTableView reloadData];
      } else {
          NSLog(@"Error: %@", error.localizedDescription);
      }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripCell" forIndexPath:indexPath];
    cell = [cell setCell:self.trips[indexPath.row]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"detailSegue"]){
        // get destination view controller
        TripDetailViewController *destinationViewController = [segue destinationViewController];
        TripCell *tappedCell = sender;
        // get indexPath of tapped cell
        NSIndexPath *indexPath = [self.tripsTableView indexPathForCell:tappedCell];
        // get trip of tapped cell
        destinationViewController.trip = self.trips[indexPath.row];
    }
}

@end
