//
//  ParseUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "ParseUtility.h"
#import <Parse/Parse.h>
#import "Trip.h"
#import "NotificationUtility.h"

@implementation ParseUtility

// update current user's list of trips
+ (void)updateCurrentUserTrips {
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"createdAt" greaterThan:PFUser.currentUser.updatedAt];
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
        if (!error) {
            PFRelation *relation;
            // add each trip where user is a guest to user's list of trips
            relation = [PFUser.currentUser relationForKey:@"trips"];
            for(Trip *trip in trips) {
                for(NSString *guestUsername in trip[@"guests"]) {
                    if ([PFUser.currentUser.username isEqualToString:guestUsername]) {
                        [relation addObject:trip];
                        
                        // create notification for trip
                        [NotificationUtility setNotification:trip];
                        break;
                    }
                }
            }
            [PFUser.currentUser saveInBackground];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}


@end
