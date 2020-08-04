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
    cell = [cell setCell:self.users[indexPath.row]];
    return cell;
}

- (void)updateSearch:(NSString *)searchTerm withCompletion:(void(^)(BOOL finished))completion {
    self.users = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
       [query whereKey:@"username" containsString:searchTerm];
       [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
           if (!error) {
               for(PFUser *user in users) {
                   [self.users addObject:user.username];
               }
               completion(YES);
           }
       }];
}

@end
