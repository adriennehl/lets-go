//
//  DateUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+ (NSString *)dateToString: (NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // set formatter style
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    // Convert Date to String
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
