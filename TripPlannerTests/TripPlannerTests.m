//
//  TripPlannerTests.m
//  TripPlannerTests
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CalendarUtility.h"
#import <EventKit/EventKit.h>
#import "DateUtility.h"

@interface TripPlannerTests : XCTestCase
@property (nonatomic) CalendarUtility *calenderUtility;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) NSMutableArray *freeTimes;
@end

@implementation TripPlannerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    self.calenderUtility = [[CalendarUtility alloc] init];
    self.eventStore = [[EKEventStore alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testFindFreeTimes {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // set start and end date
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970: 1595267700.000000];
    NSDateComponents *dateComponent= [[NSDateComponents alloc] init];
    dateComponent.hour = 10;
    NSCalendar *testCalendar = [NSCalendar currentCalendar];
    NSDate *endDate = [testCalendar dateByAddingComponents:dateComponent toDate:startDate options:0];
    // get events
    NSArray *events = [CalendarUtility retrieveEvents:self.eventStore withStartDate:startDate withEndDate:endDate];
    NSTimeInterval duration = 60 * 30;
    [CalendarUtility findFreeTimes:events withStartRange:startDate withEndRange:endDate withDuration:duration withCompletion:^(BOOL finished, NSMutableArray * _Nonnull freeTimes) {
        self.freeTimes = freeTimes;
    }];
    
    NSDictionary *slot1 = [[NSDictionary alloc]
                           initWithObjectsAndKeys:@"7/20/20, 5:30 PM",@"endDate",@"7/20/20, 5:00 PM", @"startDate", nil];
    NSDictionary *slot2 = [[NSDictionary alloc]
    initWithObjectsAndKeys:@"7/20/20, 6:00 PM",@"endDate",@"7/20/20, 5:30 PM", @"startDate", nil];
    NSDictionary *slot3 = [[NSDictionary alloc]
    initWithObjectsAndKeys:@"7/20/20, 10:30 PM",@"endDate",@"7/20/20, 10:00 PM", @"startDate", nil];
    NSArray *expectedTimes = [[NSArray alloc] initWithObjects:slot1,slot2,slot3, nil];
    for(int i = 0;i < expectedTimes.count;i++) {
        XCTAssertEqualObjects([DateUtility dateToString:self.freeTimes[i][@"startDate"]], expectedTimes[i][@"startDate"], @"The returned objects did not match the expected objects");
        XCTAssertEqualObjects([DateUtility dateToString:self.freeTimes[i][@"endDate"]], expectedTimes[i][@"endDate"], @"The returned objects did not match the expected objects");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
