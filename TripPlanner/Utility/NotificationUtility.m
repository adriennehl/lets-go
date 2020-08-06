//
//  NotificationUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/28/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "NotificationUtility.h"
#import "TripDetailViewController.h"
#import "DateUtility.h"
#import "CalendarUtility.h"
#import "AlertUtility.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@implementation NotificationUtility
- (instancetype)initWithRoot:(UIViewController *)rootViewController {
    self = [super init];
    self.rootViewController = rootViewController;
    
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
    content.userInfo = @{@"tripId": trip.objectId};
    
    // specify delivery conditions
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
    
    // create request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:trip.objectId content:content trigger:trigger];
    
    // schedule request with the notification center
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

+ (void)deleteNotification:(NSString *)tripId {
    NSArray *trips = [NSArray arrayWithObject:tripId];
    [UNUserNotificationCenter.currentNotificationCenter removePendingNotificationRequestsWithIdentifiers:trips];
}

// called when a user selects an action in a delivered notification
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // get trip info
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSString *tripId = userInfo[@"tripId"];
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"objectId" equalTo:tripId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        // if trip has been found, show detail VC
        if (objects.count > 0) {
            // open trip detail view controller
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TripDetailViewController *tripDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"TripDetailViewController"];
            tripDetailVC.trip = objects[0];
            [self.rootViewController presentViewController:tripDetailVC animated:YES completion:nil];
        }
        // otherwise, show error alert
        else {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Retrieiving Trip" action:@"Close" message:@"The specified trip was not found."];
            [self.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }];
    completionHandler();
}

// called when a notification is delivered to a foreground app
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionAlert);
}
@end
