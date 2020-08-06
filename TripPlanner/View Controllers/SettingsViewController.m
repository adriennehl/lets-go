//
//  SettingsViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 8/6/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "SettingsViewController.h"
#import "AlertUtility.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *notificationDatePicker;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.notificationDatePicker.countDownDuration = [PFUser.currentUser[@"notificationDate"] doubleValue] * 60;
}

- (IBAction)onSave:(id)sender {
    NSNumber *notificationDate = [[NSNumber alloc] initWithDouble: self.notificationDatePicker.countDownDuration / 60];
    PFUser.currentUser[@"notificationDate"] = notificationDate;
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        UIAlertController *alert;
        if (succeeded) {
            alert = [AlertUtility createAlertWithLottie:@"Success!" message:@"Changes saved successfully" action:@"save" withCompletion:^(BOOL finished) {
            }];
        }
        else {
            alert = [AlertUtility createCancelActionAlert:@"Error Saving Changes" action:@"Cancel" message:error.localizedDescription];
        }
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
