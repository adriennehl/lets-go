//
//  Trip.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Parse/Parse.h>
#import "TripViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Trip : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *tripID;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSMutableArray *guests;
@property (nonatomic, strong) NSMutableArray *declined;
@property (nonatomic, strong) NSArray *album;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic) CGFloat aspectRatio;

+ (void) postUserTrip:(NSMutableArray *)guestUsernames withImages: (NSArray *)images withDescription: (NSString * _Nullable)description withTitle: (NSString *)title withLocation: (NSString *)location withStartDate: (NSDate *)startDate withEndDate: (NSDate *)endDate withGuests: (NSMutableArray *) guests withController:(TripViewController *) controller withAspectRatio:(CGFloat)aspectRatio;

@end

NS_ASSUME_NONNULL_END
