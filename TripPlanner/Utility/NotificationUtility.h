//
//  NotificationUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/28/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationUtility : NSObject <UNUserNotificationCenterDelegate>

+ (void)setNotification:(NSString *)title withDescription:(NSString *)description withDate:(NSDateComponents *)date withID:(NSString *)tripId;

@end

NS_ASSUME_NONNULL_END
