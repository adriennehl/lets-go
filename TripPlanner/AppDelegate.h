//
//  AppDelegate.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsUtility.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) EventsUtility *eventManager;
@end

