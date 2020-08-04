//
//  UserCell.m
//  TripPlanner
//
//  Created by Adrienne Li on 8/3/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "UserCell.h"
#import "UsersTableViewUtility.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UserCell *)setCell:(PFUser *) user withContacts:(NSArray *) contacts{
    self.user = user;
    self.usernameLabel.text = self.user.username;
    self.nameLabel.text = self.user[@"name"];
    PFFileObject *profileImage = self.user[@"profileImage"];
    self.profileImage.file = profileImage;
    [self.profileImage loadInBackground];
    BOOL isFavorited = [UsersTableViewUtility containsUser:self.user inContacts:contacts];
    if(isFavorited) {
        self.favoriteButton.tintColor = UIColor.yellowColor;
    }
    else {
        self.favoriteButton.tintColor = UIColor.grayColor;
    }
    return self;
}

// if favorited, unfavorite and remove from contacts
// if unfavorited, favorite and add to contacts
- (IBAction)onFavorite:(id)sender {
    PFRelation *relation = [PFUser.currentUser relationForKey:@"contactBook"];
    if(self.favoriteButton.tintColor == UIColor.yellowColor) {
        self.favoriteButton.tintColor = UIColor.grayColor;
        [relation removeObject:self.user];
    }
    else {
        self.favoriteButton.tintColor = UIColor.yellowColor;
        [relation addObject:self.user];
    }
    [PFUser.currentUser saveInBackground];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
