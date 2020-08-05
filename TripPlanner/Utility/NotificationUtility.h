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
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationUtility : NSObject <UNUserNotificationCenterDelegate>

@property (nonatomic, strong) UIViewController *rootViewController;

- (instancetype)initWithRoot:(UIViewController *)rootViewController;
+ (void)setNotification:(Trip *)trip;
+ (void)deleteNotification:(NSString *)tripId;

@end

NS_ASSUME_NONNULL_END
