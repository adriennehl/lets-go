//
//  TimeSlotCell.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/17/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeSlotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
- (TimeSlotCell *)setCell:(NSDictionary *)timeslot;

@end

NS_ASSUME_NONNULL_END
