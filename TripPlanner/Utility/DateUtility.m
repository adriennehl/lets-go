//
//  DateUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

// convert date to string
+ (NSString *)dateToString: (NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // set formatter style
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    // Convert Date to String
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (UIDatePicker *)createDatePicker {
    UIDatePicker *startDatePicker = [[UIDatePicker alloc] init];
    startDatePicker.minuteInterval = 5;
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval roundedInterval = ceil((interval / 300)) * 300;
    NSDate *roundedDate = [NSDate dateWithTimeIntervalSince1970:roundedInterval];
    [startDatePicker setDate:roundedDate animated:YES];
    return startDatePicker;
}
@end
