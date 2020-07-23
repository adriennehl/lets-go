//
//  CalendarUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/23/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarUtility : NSObject
+ (NSArray *)retrieveEvents:(EKEventStore *)eventStore withStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate;
+ (void)findFreeTimes:(NSArray *)events withStartRange:(NSDate *)startRange withEndRange:(NSDate *)endRange withDuration:(NSTimeInterval)duration withCompletion:(void(^)(BOOL finished, NSMutableArray *freeTimes))completion;
@end

NS_ASSUME_NONNULL_END
