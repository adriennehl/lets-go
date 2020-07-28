//
//  NotificationUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/28/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "NotificationUtility.h"
#import "AlertUtility.h"
#import <UIKit/UIKit.h>

@implementation NotificationUtility
+ (void)setNotification:(NSString *)title withDescription:(NSString *)description withDate:(NSDateComponents *)date withID:(NSString *)tripId {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = @"from TripPlanner App";
    content.body = description;
    // specify delivery conditions
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:date repeats:NO];
    // create request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:tripId content:content trigger:trigger];
    // schedule request with the notification center
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [UNUserNotificationCenter.currentNotificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            NSLog(@"%@", request);
        }
    }];
}

+ (void)deleteNotification:(NSString *)tripId {
    NSArray *trips = [NSArray arrayWithObject:tripId];
    [UNUserNotificationCenter.currentNotificationCenter removePendingNotificationRequestsWithIdentifiers:trips];
    [UNUserNotificationCenter.currentNotificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            NSLog(@"%@", request);
        }
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
}
@end
