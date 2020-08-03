//
//  SuggestViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/16/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "SuggestViewController.h"
#import "TripViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "EventsUtility.h"
#import "APIUtility.h"
#import "DateUtility.h"
#import "AlertUtility.h"
#import "CalendarUtility.h"
#import "AppDelegate.h"
#import "TimeSlotCell.h"

@interface SuggestViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *openHoursLabel;
@property (weak, nonatomic) IBOutlet UITextView *openHoursText;
@property (weak, nonatomic) IBOutlet UITextField *startRangeField;
@property (weak, nonatomic) IBOutlet UITextField *endRangeField;
@property (weak, nonatomic) IBOutlet UIDatePicker *durationPicker;
@property (weak, nonatomic) IBOutlet UIButton *suggestTimesButton;
@property (strong, nonatomic) UIDatePicker *startRangePicker;
@property (strong, nonatomic) UIDatePicker *endRangePicker;
@property (weak, nonatomic) IBOutlet UITableView *timesTableView;
@property (strong, nonatomic) NSMutableArray *freeTimes;
@property (strong, nonatomic) EKEventStore *eventStore;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.timesTableView.delegate = self;
    self.timesTableView.dataSource = self;
    
    [self setDatePickers];
    
    // Request access to calendar
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    EventsUtility *eventManager = appDelegate.eventManager;
    self.eventStore = eventManager.eventStore;
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if(granted) {
            eventManager.eventsAccessGranted = YES;
        }
        else {
            eventManager.eventsAccessGranted = NO;
        }
    }];
    
    // if location is chosen, display open hours
    if(self.place)
        [self displayOpenHours];
}

- (void)setDatePickers {
    // set start range picker
    self.startRangePicker = [DateUtility createDatePicker];
    [self.startRangePicker addTarget:self action:@selector(updateStartField) forControlEvents:UIControlEventValueChanged];
    [self.startRangeField setInputView:self.startRangePicker];
    [self updateStartField];
    
    // set end range picker
    self.endRangePicker = [DateUtility createDatePicker];
    [self.endRangePicker addTarget:self action:@selector(updateEndField) forControlEvents:UIControlEventValueChanged];
    [self.endRangeField setInputView:self.endRangePicker];
    [self updateEndField];
}

- (void)updateStartField {
    self.startRangeField.text = [DateUtility dateToString:self.startRangePicker.date];
}

- (void)updateEndField {
    self.endRangeField.text = [DateUtility dateToString:self.endRangePicker.date];
}

- (void)displayOpenHours {
    self.openHoursLabel.text = [NSString stringWithFormat:@"%@ Opening Hours: ", self.place.name];
    [APIUtility getPlaceDetails:self.place.placeId fields:@"opening_hours" withCompletion:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        if (error != nil) {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Retrieving Hours" action:@"Cancel" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *details = [dataDictionary valueForKeyPath:@"result"];
            NSArray *openHours = details[@"opening_hours"][@"weekday_text"];
            if(openHours) {
                for(NSString *day in openHours) {
                    self.openHoursText.text = [self.openHoursText.text stringByAppendingFormat:@"%@\n", day];
                }
            }
        }
    }];
}

- (IBAction)showTimes:(id)sender {
    // animate button
    [UIView animateWithDuration:0.25 animations:^{
        self.suggestTimesButton.transform = CGAffineTransformMakeScale(2.5, 2.5);
        self.suggestTimesButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    // check to make sure end date is after start date
    if([self.endRangePicker.date compare:self.startRangePicker.date] != NSOrderedAscending) {
        // find free times around events
        NSArray *events = [CalendarUtility retrieveEvents:self.eventStore withStartDate:self.startRangePicker.date withEndDate:self.endRangePicker.date];
        [CalendarUtility findFreeTimes:events withStartRange:self.startRangePicker.date withEndRange:self.endRangePicker.date withDuration:self.durationPicker.countDownDuration withCompletion:^(BOOL finished, NSMutableArray * _Nonnull freeTimes) {
            self.freeTimes = freeTimes;
            [self.timesTableView reloadData];
            // show alert if no free times are found
            if(self.freeTimes.count == 0) {
                UIAlertController *alert = [AlertUtility createCancelActionAlert:@"No Times Available" action:@"Cancel" message:@"No available time was found for specified range and duration"];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    else {
        UIAlertController *invalidDateAlert = [AlertUtility createCancelActionAlert:@"Invalid Date" action:@"Cancel" message:@"End date must be after start date"];
        [self presentViewController:invalidDateAlert animated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.freeTimes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeSlotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeSlotCell" forIndexPath:indexPath];
    cell = [cell setCell:self.freeTimes[indexPath.row]];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCellTap:)];
    [cell addGestureRecognizer:tapRecognizer];
    return cell;
}

- (void)onCellTap:(UITapGestureRecognizer *)sender {
    TimeSlotCell *tappedCell = (TimeSlotCell *) sender.view;
    NSIndexPath *indexPath = [self.timesTableView indexPathForCell:tappedCell];
    NSDictionary *timeslot = self.freeTimes[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    TripViewController *destinationViewController = (TripViewController *) self.navigationController.topViewController;
    destinationViewController.startDatePicker.date = timeslot[@"startDate"];
    destinationViewController.endDatePicker.date = timeslot[@"endDate"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

@end
