//
//  UsersTableViewUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 8/3/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UsersTableViewUtility : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *users;
- (void)updateSearch:(NSString *)searchTerm withCompletion:(void(^)(BOOL finished))completion;
@end

NS_ASSUME_NONNULL_END
