//
//  CalendarUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/23/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "CalendarUtility.h"
#import <EventKit/EventKit.h>
#import <Parse/Parse.h>

@implementation CalendarUtility

// get all events between start range and end range
+ (NSArray *)retrieveEvents:(EKEventStore *)eventStore withStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate {
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate
                            endDate:endDate calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
    return events;
}

// given a list of events, find free times in range between events.
+ (void)findFreeTimes:(NSArray *)events withStartRange:(NSDate *)startRange withEndRange:(NSDate *)endRange withDuration:(NSTimeInterval)duration withCompletion:(void(^)(BOOL finished, NSMutableArray *freeTimes))completion {
    NSMutableArray *freeTimes = [[NSMutableArray alloc] init];
    EKEvent *startEvent;
    EKEvent *endEvent;
    NSDate *startBound;
    NSDate *endBound;
    // iterate through events to find gaps between start and end dates
    for(int i = 0; i <= events.count; i++) {
        // set start bound
        if(i == 0) {
            startBound = startRange;
        }
        else {
            startEvent = events[i-1];
            if([startBound compare:startEvent.endDate] == NSOrderedAscending) {
                startBound = startEvent.endDate;
            }
        }
        // set end bound
        if(i == events.count) {
            endBound = endRange;
        }
        else {
            endEvent = events[i];
            endBound = endEvent.startDate;
        }
        
        // break blocks into time slots equal to specified duration
        while([endBound timeIntervalSinceDate:startBound] >= duration) {
            NSDate *timeslotEnd = [startBound dateByAddingTimeInterval:duration];
            NSDictionary *timeslot = [[NSDictionary alloc] initWithObjectsAndKeys:startBound, @"startDate", timeslotEnd, @"endDate", nil];
            [freeTimes addObject:timeslot];
            startBound = timeslotEnd;
        }
    }
    completion(YES, freeTimes);
}

+ (NSDateComponents *)getDateComponents:(NSDate *)date {
    // subtract user's notification date values from date
    int minutes = [PFUser.currentUser[@"notificationDate"] intValue];
    NSDateComponents *minutesDateComponents = [[NSDateComponents alloc] init];
    [minutesDateComponents setMinute: -1 * minutes];
    NSDate *notificationDate = [[NSCalendar currentCalendar] dateByAddingComponents:minutesDateComponents toDate:date options:0];
    
    // return date components
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:notificationDate];
    return dateComponents;
}
@end
