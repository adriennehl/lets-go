//
//  AlertUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertUtility : NSObject
+ (UIAlertController *) createSourceTypeAlert: (TripViewController *)controller;
+ (UIAlertController *)createCancelActionAlert: (NSString *)title action:(NSString *)action message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
