//
//  TripViewController.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "ImagePickerViewController.h"
@import Parse;
@class Trip;

NS_ASSUME_NONNULL_BEGIN

@interface TripViewController : ImagePickerViewController
@property (strong, nonatomic) Trip *trip;
@property (strong, nonatomic) Location *place;
@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *savingIndicator;
- (IBAction)onCancel:(id)sender;
@end

NS_ASSUME_NONNULL_END
