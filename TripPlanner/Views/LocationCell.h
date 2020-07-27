//
//  LocationCell.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) Location *place;

- (LocationCell *)setCell:(Location *) place;
@end

NS_ASSUME_NONNULL_END
