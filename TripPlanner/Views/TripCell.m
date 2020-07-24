//
//  TripCell.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/14/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TripCell.h"
#import "DateUtility.h"

@implementation TripCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// fill in cell values
- (TripCell *)setCell:(Trip *)trip {
    self.trip = trip;
    self.titleLabel.text = self.trip[@"title"];
    self.hostLabel.text = [NSString stringWithFormat:@"Host: %@", self.trip[@"author"]];
    self.locationLabel.text = self.trip[@"location"];
    self.guestsLabel.text = @"Guests: ";
    for(NSString *guestUsername in trip[@"guests"]) {
        self.guestsLabel.text = [NSString stringWithFormat:@"%@%@, ", self.guestsLabel.text, guestUsername];
    }
    self.startDateLabel.text = [DateUtility dateToString:self.trip[@"startDate"]];
    self.endDateLabel.text = [DateUtility dateToString:self.trip[@"endDate"]];
    self.descriptionLabel.text = self.trip[@"descriptionText"];
    NSArray *images = self.trip[@"album"];
    if(images.count > 0) {
        PFFileObject *tripImage = self.trip[@"album"][0];
        self.tripView.file = tripImage;
        [self.tripView loadInBackground];
    }
    return self;
}

@end
