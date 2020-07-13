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

+ (void) postUserTrip: (UIImage * _Nullable)image withGuests: (NSMutableArray *)guests withImages: (NSMutableArray *)images withDescription: (NSString * _Nullable)description withTitle: (NSString *)title withLocation: (NSString *)location withStartDate: (NSDate *)startDate withEndDate: (NSDate *)endDate withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Trip *newTrip = [Trip new];
    newTrip.author = PFUser.currentUser.username;
    newTrip.guests = guests;
    newTrip.images = images;
    newTrip.description = description;
    newTrip.title = title;
    newTrip.location = location;
    newTrip.startDate = startDate;
    newTrip.endDate = endDate;
    
    [newTrip saveInBackgroundWithBlock:completion];
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

@end
