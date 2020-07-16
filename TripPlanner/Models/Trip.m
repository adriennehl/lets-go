//
//  Trip.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "Trip.h"
#import "AlertUtility.h"

@implementation Trip

@dynamic tripID;
@dynamic author;
@dynamic guests;
@dynamic images;
@dynamic description;
@dynamic title;
@dynamic location;
@dynamic startDate;
@dynamic endDate;

+ (nonnull NSString *)parseClassName {
    return @"Trip";
}

+ (void) postUserTrip:(NSMutableArray *)guestUsernames withImages: (NSArray *)images withDescription: (NSString * _Nullable)description withTitle: (NSString *)title withLocation: (NSString *)location withStartDate: (NSDate *)startDate withEndDate: (NSDate *)endDate withGuests: (NSMutableArray *) guests withController:(TripViewController *) controller {
    Trip *newTrip = [Trip new];
    newTrip.author = PFUser.currentUser.username;
    newTrip.guests = guestUsernames;
    newTrip.images = images;
    newTrip.description = description;
    newTrip.title = title;
    newTrip.location = location;
    newTrip.startDate = startDate;
    newTrip.endDate = endDate;
    
    [newTrip saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Adding Trip" action:@"Cancel" message:error.localizedDescription];
            [controller presentViewController: alert animated:YES completion:^{
            }];
        }
        else {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Successful" action:@"Ok" message:@"Trip was successfully added"];
            [controller presentViewController: alert animated:YES completion:^{
            }];
            [controller onCancel:self];

            PFRelation *relation;
            // add trip to author's list of trips
            relation = [PFUser.currentUser relationForKey:@"trips"];
            [relation addObject:newTrip];
            [PFUser.currentUser saveInBackground];
        }
    }];
}

@end
