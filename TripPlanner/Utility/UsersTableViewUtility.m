//
//  UsersTableViewUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 8/3/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "UsersTableViewUtility.h"
#import "UserCell.h"

@implementation UsersTableViewUtility
- (instancetype)init {
    self = [super init];
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    cell = [cell setCell:self.users[indexPath.row] withContacts:self.contacts];
    return cell;
}

// retrieve results for search term
- (void)updateSearch:(NSString *)searchTerm withCompletion:(void(^)(BOOL finished))completion {
    // get all users whose username contains the search term, excluding the current user
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" notEqualTo:PFUser.currentUser.username];
    [query whereKey:@"username" containsString:searchTerm];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if (!error) {
            self.users = users;
            completion(YES);
        }
    }];
}

// check if contacts contains the given user
+ (BOOL)containsUser:(PFUser *)user inContacts:(NSArray *)contacts {
    for (PFUser* contact in contacts) {
        if ([contact.username isEqualToString:user.username]) {
            return YES;
        }
    }
    return NO;
}

@end
