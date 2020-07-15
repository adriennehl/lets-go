//
//  LocationCell.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "LocationCell.h"
#import "Key.h"

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
    [self setPhoto:place.photosArray];
    return self;
}

- (void)setPhoto: (NSArray *)photos {
    Key *key = [[Key alloc] init];
    
    if (photos.count == 0) {
        self.locationView.image = [UIImage imageNamed:@"image_placeholder"];
    }
    NSString *photoReference = photos[0][@"photo_reference"];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxheight=185&photoreference=%@&key=%@", photoReference, key.key];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            self.locationView.image = [UIImage imageNamed:@"image_placeholder"];
        }
        else {
            self.locationView.image = [UIImage imageWithData:data];
            self.place.photoData = data;
        }
    }];
    [task resume];
}

@end
