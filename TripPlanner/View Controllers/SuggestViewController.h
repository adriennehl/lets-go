//
//  SuggestViewController.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/16/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuggestViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *guests;
@property (nonatomic, strong) Location *place;
@end

NS_ASSUME_NONNULL_END
