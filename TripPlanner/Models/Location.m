//
//  Location.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "Location.h"
#import "Key.h"

@implementation Location
- (instancetype)initWithPlace:(NSDictionary *)place location:(CLLocationCoordinate2D)location {
    self = [super init];
    self.place = place;
    self.name = self.place[@"name"];
    self.rating = [NSString stringWithFormat:@"%@", self.place[@"rating"]];
    self.address = self.place[@"formatted_address"];
    self.photosArray = self.place[@"photos"];
    self.placeId = self.place[@"place_id"];
    self.priceLevel = [self.place[@"price_level"] integerValue];
    self.location = location;
    return self;
}

@end
