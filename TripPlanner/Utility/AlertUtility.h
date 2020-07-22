//
//  AlertUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagePickerViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertUtility : NSObject
+ (UIAlertController *) createDoubleActionAlert: (NSString *) errorDescription title: (NSString *) title;
+ (UIAlertController *)createCancelActionAlert: (NSString *)title action:(NSString *)action message:(NSString *)message;
+ (UIAlertController *)createSingleActionAlert: (NSString *)title action:(NSString *)action message:(NSString *)message withCompletion:(void(^)(BOOL finished))completion;
+ (UIAlertController *) createSourceTypeAlert: (ImagePickerViewController *)controller;
@end

NS_ASSUME_NONNULL_END
