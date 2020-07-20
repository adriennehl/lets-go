//
//  EventsUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/16/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "EventsUtility.h"

@implementation EventsUtility

- (instancetype)init {
    self = [super init];
    // initialize event store object
    self.eventStore = [[EKEventStore alloc] init];
    return self;
}

@end
