//
//  DateUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateUtility : NSObject
+ (NSString *)dateToString: (NSDate *)date;
+ (UIDatePicker *)createDatePicker;
@end

NS_ASSUME_NONNULL_END
