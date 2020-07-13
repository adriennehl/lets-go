//
//  TripStreamViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TripStreamViewController.h"
#import "Trip.h"

@interface TripStreamViewController ()

@end

@implementation TripStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // test trip method
    NSMutableArray *guests = [[NSMutableArray alloc] initWithArray:@[@"user1",@"user2"]];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [Trip postUserTrip:[UIImage imageNamed:@"placeholder_image"] withGuests:guests withImages:images withDescription:@"a small quarantine trip" withTitle:@"my first trip" withLocation:@"my house" withStartDate:[NSDate date] withEndDate:[NSDate date] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Trip posted successfully!");
        }
    }];
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
