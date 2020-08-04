//
//  UserCell.h
//  TripPlanner
//
//  Created by Adrienne Li on 8/3/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong, nonatomic) PFUser *user;

- (UserCell *)setCell:(PFUser *) user withContacts:(NSArray *) contacts;

@end

NS_ASSUME_NONNULL_END
