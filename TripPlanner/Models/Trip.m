//
//  Trip.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "Trip.h"
#import "AlertUtility.h"
#import "CalendarUtility.h"

@implementation Trip

@dynamic tripID;
@dynamic author;
@dynamic guests;
@dynamic declined;
@dynamic album;
@dynamic descriptionText;
@dynamic title;
@dynamic location;
@dynamic startDate;
@dynamic endDate;
@dynamic aspectRatio;

+ (nonnull NSString *)parseClassName {
    return @"Trip";
}

+ (void) postUserTrip:(NSMutableArray *)guestUsernames withImages: (NSArray *)images withDescription: (NSString * _Nullable)description withTitle: (NSString *)title withLocation: (NSString *)location withStartDate: (NSDate *)startDate withEndDate: (NSDate *)endDate withGuests: (NSMutableArray *) guests withController:(TripViewController *) controller withAspectRatio:(CGFloat)aspectRatio {
    Trip *newTrip = [Trip new];
    newTrip.author = PFUser.currentUser.username;
    newTrip.guests = guestUsernames;
    newTrip.declined = [[NSMutableArray alloc] init];
    newTrip.album = images;
    newTrip.descriptionText = description;
    newTrip.title = title;
    newTrip.location = location;
    newTrip.startDate = startDate;
    newTrip.endDate = endDate;
    newTrip.aspectRatio = aspectRatio;
    
    [newTrip saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [controller.savingIndicator stopAnimating];
        if (error != nil) {
            // create error alert
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Adding Trip" action:@"Cancel" message:error.localizedDescription];
            [controller presentViewController: alert animated:YES completion:^{
            }];
        }
        else {
            // create success alert
            UIAlertController *alert = [AlertUtility createSingleActionAlert:@"Successful" action:@"Ok" message:@"Trip was successfully added" withCompletion:^(BOOL finished) {
                [controller onCancel:self];
            }];
            [controller presentViewController: alert animated:YES completion:^{
            }];
            
            // create notification for the trip
            // get date components for one day before trip startDate
            NSDateComponents *dateComponents = [CalendarUtility getDateComponents:newTrip.startDate];
            // schedule the notification
            [NotificationUtility setNotification:newTrip.title withDescription:newTrip.descriptionText withDate:dateComponents withID:newTrip.objectId];
            
            // add trip to author's list of trips
            PFRelation *relation;
            relation = [PFUser.currentUser relationForKey:@"trips"];
            [relation addObject:newTrip];
            [PFUser.currentUser saveInBackground];
        }
    }];
}

@end
