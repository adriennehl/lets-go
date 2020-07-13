//
//  TripViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TripViewController.h"
#import "Trip.h"

@interface TripViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tripImageView;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
@property (weak, nonatomic) IBOutlet UITextField *guestsField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;


@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// get guests array
- (NSMutableArray *)getGuestsArray:(NSString *)guestsString {
    // separate guests in guestsString
    NSArray *guestItems = [guestsString componentsSeparatedByString:@","];
    // strip spaces and add to a new mutable array
    NSMutableArray *guests = [[NSMutableArray alloc] init];
    for (NSString* guestItem in guestItems) {
        NSString *trimmed = [guestItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [guests addObject:trimmed];
        return guests;
    }
    
    return guests;
}

// get

- (IBAction)onSave:(id)sender {
    NSMutableArray *guests = [self getGuestsArray:self.guestsField.text];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [Trip postUserTrip:[UIImage imageNamed:@"placeholder_image"] withGuests:guests withImages:images withDescription:@"a small quarantine trip" withTitle:@"my first trip" withLocation:@"my house" withStartDate:[NSDate date] withEndDate:[NSDate date] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Trip posted successfully!");
        }
    }];
}

- (IBAction)onCancel:(id)sender {
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
