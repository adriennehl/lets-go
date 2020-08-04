//
//  UserCell.m
//  TripPlanner
//
//  Created by Adrienne Li on 8/3/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UserCell *)setCell:(NSString *) username {
    self.usernameLabel.text = username;
    BOOL isFavorited = [PFUser.currentUser[@"contacts"] containsObject:username];
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
    if(self.favoriteButton.tintColor == UIColor.yellowColor) {
        self.favoriteButton.tintColor = UIColor.grayColor;
        [PFUser.currentUser[@"contacts"] removeObject:self.usernameLabel.text];
    }
    else {
        self.favoriteButton.tintColor = UIColor.yellowColor;
        [PFUser.currentUser[@"contacts"] addObject:self.usernameLabel.text];
    }
    [PFUser.currentUser saveInBackground];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
