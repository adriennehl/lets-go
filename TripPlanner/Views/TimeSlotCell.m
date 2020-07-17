//
//  TimeSlotCell.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/17/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TimeSlotCell.h"
#import "DateUtility.h"

@implementation TimeSlotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (TimeSlotCell *)setCell:(NSDictionary *)timeslot {
    self.startLabel.text = [DateUtility dateToString:timeslot[@"startDate"]];
    self.endLabel.text = [DateUtility dateToString:timeslot[@"endDate"]];
    return self;
}

@end
