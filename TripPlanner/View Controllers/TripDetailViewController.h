//
//  TripDetailViewController.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/30/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "albumCollectionViewUtility.h"
#import "Trip.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailViewController : ImagePickerViewController

@property (strong, nonatomic) Trip *trip;

@end

NS_ASSUME_NONNULL_END
