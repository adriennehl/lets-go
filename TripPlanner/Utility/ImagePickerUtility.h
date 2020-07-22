//
//  ImagePickerUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagePickerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImagePickerUtility : NSObject
+ (void)createImagePicker:(UIImagePickerControllerSourceType)sourceType controller: (ImagePickerViewController *)controller;
@end

NS_ASSUME_NONNULL_END
