//
//  TripViewController.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
@import Parse;
@class Trip;

NS_ASSUME_NONNULL_BEGIN

@interface TripViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) Trip *trip;
@property (strong, nonatomic) Location *place;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
- (IBAction)onCancel:(id)sender;
@end

NS_ASSUME_NONNULL_END
