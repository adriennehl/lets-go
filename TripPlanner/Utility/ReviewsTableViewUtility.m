//
//  ReviewsTableViewUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/27/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "ReviewsTableViewUtility.h"
#import "ReviewCell.h"

@implementation ReviewsTableViewUtility
- (instancetype)initWithReviews:(NSArray *)reviews {
    self = [super init];
    self.reviews = reviews;
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReviewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    [reviewCell setCell:self.reviews[indexPath.row]];
    return reviewCell;
}
@end
