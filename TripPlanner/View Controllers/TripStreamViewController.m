//
//  TripStreamViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TripStreamViewController.h"
#import "Trip.h"
#import "TripCell.h"

@interface TripStreamViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tripsTableView;
@property (strong, nonatomic) NSArray *trips;
@end

@implementation TripStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tripsTableView.delegate = self;
    self.tripsTableView.dataSource = self;
    
    // get trips
    PFRelation *relation = [PFUser.currentUser relationForKey:@"trips"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"startDate"];
    [query whereKey:@"startDate" greaterThan:[NSDate date]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
      if (!error) {
          self.trips = trips;
          [self.tripsTableView reloadData];
      } else {
          NSLog(@"Error: %@", error.localizedDescription);
      }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripCell *cell = [self.tripsTableView dequeueReusableCellWithIdentifier:@"TripCell" forIndexPath:indexPath];
    cell = [cell setCell:self.trips[indexPath.row]];
    return cell;
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
