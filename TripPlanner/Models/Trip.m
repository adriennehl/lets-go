//
//  Trip.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "Trip.h"

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

+ (NSString *)dateToString: (NSDate *)createdAt {
    // format and set createdAtString
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    //Convert Date to String
    NSString *createdAtString = [formatter stringFromDate:createdAt];
    
    return createdAtString;
}

+ (void) postUserTrip:(NSMutableArray *)guestUsernames withImages: (NSMutableArray *)images withDescription: (NSString * _Nullable)description withTitle: (NSString *)title withLocation: (NSString *)location withStartDate: (NSDate *)startDate withEndDate: (NSDate *)endDate withGuests: (NSMutableArray *) guests withController:(TripViewController *) controller {
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
            UIAlertController *alert = [self createUserAlert:@"Error Adding Trip" action:@"Cancel" message:error.localizedDescription];
            [controller presentViewController: alert animated:YES completion:^{
            }];
        }
        else {
            UIAlertController *alert = [self createUserAlert:@"Successful" action:@"Ok" message:@"Trip was successfully added"];
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

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (UIAlertController *)createUserAlert: (NSString *)title action:(NSString *)action message:(NSString *)message{
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:action
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                                                   message: message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // add the camera action to the alertController
    [alert addAction:alertAction];
    return alert;
    
}

@end
