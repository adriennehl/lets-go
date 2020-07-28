//
//  NotificationUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/28/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationUtility : NSObject <UNUserNotificationCenterDelegate>
- (instancetype)init;
+ (void)setNotification:(Trip *)trip;
+ (void)deleteNotification:(NSString *)tripId;

@end

NS_ASSUME_NONNULL_END
