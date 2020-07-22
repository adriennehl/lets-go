//
//  ProfileViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "TripCell.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *pastTripsTableView;
@property (nonatomic, strong) NSArray *trips;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pastTripsTableView.delegate = self;
    self.pastTripsTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchPastTrips];
}

// enable user log out
- (IBAction)onLogOut:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    // create storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // create new instance of view controller in storyboard
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    // set root view controller
    sceneDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

// get past trips from user's trips relation
- (void)fetchPastTrips {
    PFRelation *relation = [PFUser.currentUser relationForKey:@"trips"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"startDate"];
    [query whereKey:@"endDate" lessThan:[NSDate date]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
      if (!error) {
          self.trips = trips;
          [self.pastTripsTableView reloadData];
      } else {
          NSLog(@"Error: %@", error.localizedDescription);
      }
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

// set height based on the photo aspect ratio
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Trip *trip = self.trips[indexPath.row];
    if (trip.aspectRatio != 0 ){
        return 150 * trip.aspectRatio + 130;
    }
    return 150 * 1.5 +70;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"detailSegue"]){
           // get destination view controller
           TripViewController *destinationViewController = [segue destinationViewController];
           TripCell *tappedCell = sender;
           // get indexPath of tapped cell
           NSIndexPath *indexPath = [self.pastTripsTableView indexPathForCell:tappedCell];
           // get trip of tapped cell
           destinationViewController.trip = self.trips[indexPath.row];
       }
}

@end
