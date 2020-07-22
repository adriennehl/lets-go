//
//  ImagePickerUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "ImagePickerUtility.h"
#import <UIKit/UIKit.h>

@implementation ImagePickerUtility

// show an image picker that allows user to choose source type
+ (void)createImagePicker:(UIImagePickerControllerSourceType)sourceType controller: (ImagePickerViewController *)controller {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
     
     if(sourceType == UIImagePickerControllerSourceTypeCamera) {
         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
             imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
         }
         else {
             NSLog(@"Camera 🚫 available so we will use photo library instead");
             imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
         }
     }
     else {
         imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     }
    
    imagePickerVC.delegate = controller;
    imagePickerVC.allowsEditing = YES;
    
    [controller presentViewController:imagePickerVC animated:YES completion:nil];
}

@end
