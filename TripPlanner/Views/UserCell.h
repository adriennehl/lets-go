//
//  UserCell.h
//  TripPlanner
//
//  Created by Adrienne Li on 8/3/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

- (UserCell *)setCell:(NSString *) username;

@end

NS_ASSUME_NONNULL_END
