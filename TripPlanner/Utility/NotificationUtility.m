//
//  NotificationUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/28/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "NotificationUtility.h"
#import "DateUtility.h"
#import "CalendarUtility.h"
#import "AlertUtility.h"
#import <UIKit/UIKit.h>

@implementation NotificationUtility
- (instancetype)init {
    self = [super init];
    
    // create category with dismiss and view actions
    UNNotificationAction *dismissAction = [UNNotificationAction actionWithIdentifier:@"Dismiss" title:@"Dismiss" options: UNNotificationActionOptionNone];
    UNNotificationAction *viewAction = [UNNotificationAction actionWithIdentifier:@"View" title:@"View Trip" options:UNNotificationActionOptionForeground];
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"TripReminderCategory"
      actions:@[dismissAction, viewAction] intentIdentifiers:@[]
      options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:category];
    [UNUserNotificationCenter.currentNotificationCenter setNotificationCategories:categories];
    
    return self;
}

+ (void)setNotification:(Trip *)trip {
    // get date components for one day before trip startDate
    NSDateComponents *dateComponents = [CalendarUtility getDateComponents:trip.startDate];
    // schedule the notification
    
    // set content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = trip.title;
    content.subtitle = [NSString stringWithFormat:@"Starts: %@", [DateUtility dateToString:trip.startDate]];
    content.body = trip.descriptionText;
    content.categoryIdentifier = @"TripReminderCategory";
    
    // specify delivery conditions
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
    
    // create request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:trip.objectId content:content trigger:trigger];
    
    // schedule request with the notification center
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+ (void)deleteNotification:(NSString *)tripId {
    NSArray *trips = [NSArray arrayWithObject:tripId];
    [UNUserNotificationCenter.currentNotificationCenter removePendingNotificationRequestsWithIdentifiers:trips];
}

// called when a user selects an action in a delivered notification
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
}

// called when a notification is delivered to a foreground app
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionAlert);
}
@end
