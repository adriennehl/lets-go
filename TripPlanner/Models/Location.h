//
//  Location.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSData *photoData;
@property (strong, nonatomic) NSArray *photosArray;
@property (strong, nonatomic) NSDictionary *place;

- (instancetype)initWithPlace:(NSDictionary *)place;
@end

NS_ASSUME_NONNULL_END
