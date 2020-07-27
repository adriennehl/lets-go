//
//  ReviewCell.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/27/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "ReviewCell.h"

@implementation ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (ReviewCell *)setCell:(NSDictionary *)review {
    self.authorLabel.text = review[@"author_name"];
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", [review[@"rating"] doubleValue]];
    self.timeLabel.text = review[@"relative_time_description"];
    self.reviewLabel.text = review[@"text"];
    return self;
}

@end
