//
//  ImageViewController.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/22/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewController : UIViewController
@property (nonatomic, strong) PFFileObject *image;
@end

NS_ASSUME_NONNULL_END
