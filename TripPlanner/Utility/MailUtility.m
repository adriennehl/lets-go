//
//  MailUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 8/3/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "MailUtility.h"
#import "DateUtility.h"

@implementation MailUtility

+ (NSString *)composeMessage:(Trip *)trip {
    NSString *intro = [NSString stringWithFormat:@"Hello guest! %@ is inviting you to their trip: %@ at %@.\n", trip.author, trip.title, trip.location];
    NSString *startDate = [DateUtility dateToString:trip.startDate];
    NSString *endDate = [DateUtility dateToString:trip.endDate];
    NSString *dateInfo = [NSString stringWithFormat:@"\nDate: %@ to %@\n\n", startDate, endDate];
    NSString *close = @"\n\nHope you can make it!\n";
    NSString *promote = [NSString stringWithFormat:@"\n%@ is using TripPlanner. Download TripPlanner on the app store today to view more trip details and create your own trips!\n", trip.author];
    NSString *message = [NSString stringWithFormat:@"%@%@Description: %@%@%@", intro, dateInfo, trip.descriptionText, close, promote];
    return message;
}

@end
