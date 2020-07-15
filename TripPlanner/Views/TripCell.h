//
//  TripCell.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/14/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface TripCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *tripView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) Trip *trip;

- (TripCell *)setCell:(Trip *)trip;

@end

NS_ASSUME_NONNULL_END
