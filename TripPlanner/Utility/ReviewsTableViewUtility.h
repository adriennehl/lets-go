//
//  ReviewsTableViewUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/27/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ReviewsTableViewUtility : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *reviews;
- (instancetype)initWithReviews:(NSArray *)reviews;

@end

NS_ASSUME_NONNULL_END
