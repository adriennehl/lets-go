//
//  SuggestViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/16/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "SuggestViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "EventsUtility.h"
#import "AppDelegate.h"
#import "TimeSlotCell.h"

@interface SuggestViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIDatePicker *durationPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *startRangePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endRangePicker;
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
    // Request access to calendar
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    EventsUtility *eventManager = appDelegate.eventManager;
    self.eventStore = eventManager.eventStore;
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if(granted) {
            NSLog(@"Access granted");
            eventManager.eventsAccessGranted = YES;
        }
        else {
            NSLog(@"Access not granted");
            eventManager.eventsAccessGranted = NO;
        }
    }];
    self.freeTimes = [[NSMutableArray alloc] init];
}

// get all events between start range and end range
- (NSArray *)retrieveEvents {
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:self.startRangePicker.date
                                                                      endDate:self.endRangePicker.date
                                                          calendars:nil];
     
    // Fetch all events that match the predicate
    NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    for(EKEvent *event in events) {
        NSLog(@"%@", event);
    }
    return events;
}

// given a list of events, find free times in range between events.
- (void)findFreeTimes:(NSArray *)events withCompletion:(void(^)(BOOL finished))completion {
    NSDate *startBound;
    NSDate *endBound;
    EKEvent *startEvent;
    EKEvent *endEvent;
    for(int i = 0; i <= events.count; i++) {
        if(i != 0) {
            startEvent = events[i-1];
            startBound = startEvent.endDate;
        }
        else {
            startBound = self.startRangePicker.date;
        }
        if(i != events.count) {
            endEvent = events[i];
            endBound = endEvent.startDate;
        }
        else {
            endBound = self.endRangePicker.date;
        }
        if([endBound timeIntervalSinceDate:startBound] >= self.durationPicker.countDownDuration) {
            NSDictionary *timeslot = [[NSDictionary alloc] initWithObjectsAndKeys:startBound, @"startDate", endBound, @"endDate", nil];
            [self.freeTimes addObject:timeslot];
        }
    }
    completion(YES);
}

- (IBAction)showTimes:(id)sender {
    NSArray *events = [self retrieveEvents];
   [self findFreeTimes:events withCompletion:^(BOOL finished) {
       [self.timesTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.freeTimes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeSlotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeSlotCell" forIndexPath:indexPath];
    cell = [cell setCell:self.freeTimes[indexPath.row]];
    return cell;
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
