//
//  LocationCell.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "LocationCell.h"
#import "APIUtility.h"

@implementation LocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (LocationCell *)setCell:(Location *) place {
    self.place = place;
    self.nameLabel.text = place.name;
    self.addressLabel.text = place.address;
    self.ratingLabel.text = place.rating;
    self.priceLabel.text = [@"" stringByPaddingToLength:place.priceLevel withString:@"$" startingAtIndex:0];
    [self setPhoto:place.photosArray];
    return self;
}

- (void)setPhoto: (NSArray *)photos {
    if (photos.count == 0) {
        self.locationView.image = [UIImage imageNamed:@"image_placeholder"];
    }
    else {
        // get photo reference
        NSString *photoReference = photos[0][@"photo_reference"];
        // call get photo method
        [APIUtility getPhoto:photoReference withCompletion: ^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                self.locationView.image = [UIImage imageNamed:@"image_placeholder"];
            }
            else {
                self.locationView.image = [UIImage imageWithData:data];
                self.place.photoData = data;
            }
        }];
    }
}

@end
