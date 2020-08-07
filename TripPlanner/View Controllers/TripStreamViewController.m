//
//  TripStreamViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TripStreamViewController.h"
#import "TripDetailViewController.h"
#import "AlertUtility.h"
#import "Trip.h"
#import "TripCell.h"
#import "ParseUtility.h"

@interface TripStreamViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tripsTableView;
@property (strong, nonatomic) NSMutableArray *trips;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
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
    
    // position activity indicator
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
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
    query.limit = 10;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
         if (!error) {
             self.trips = (NSMutableArray *) trips;
             [self.tripsTableView reloadData];
             if (self.trips.count > 0) {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                 [self.tripsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             }
         } else {
             UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Fetching Trips" action:@"Cancel" message:error.localizedDescription];
             [self presentViewController:alert animated:YES completion:nil];
         }
           [self.refreshControl endRefreshing];
           [self.activityIndicator stopAnimating];
       }];
}

// fetch more trips when user scrolls down
- (void)fetchMoreTrips {
    PFRelation *relation = [PFUser.currentUser relationForKey:@"trips"];
    PFQuery *query = [relation query];
    query.skip = self.trips.count;
    [query orderByAscending:@"startDate"];
    [query whereKey:@"endDate" greaterThan:[NSDate date]];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
        if (!error) {
            [self.trips addObjectsFromArray:trips];
            [self.tripsTableView reloadData];
        } else {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Fetching Trips" action:@"Cancel" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
        self.isMoreDataLoading = NO;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isMoreDataLoading) {
        // calculate th position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tripsTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tripsTableView.bounds.size.height;
        
        // when user is past threshold, request more data
        if (scrollView.contentOffset.y > scrollOffsetThreshold && self.tripsTableView.isDragging) {
            self.isMoreDataLoading = YES;
            [self.activityIndicator startAnimating];
            
            // request data from Parse server
            [self fetchMoreTrips];
        }
    }
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
