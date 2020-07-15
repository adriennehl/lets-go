//
//  AlertUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "AlertUtility.h"
#import "ImagePickerUtility.h"

@implementation AlertUtility

+ (UIAlertController *)createCancelActionAlert: (NSString *)title action:(NSString *)action message:(NSString *)message {
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:action
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                                                   message: message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // add the action to the alertController
    [alert addAction:alertAction];
    return alert;
    
}

+ (UIAlertController *) createSourceTypeAlert: (TripViewController *)controller {
    // create a camera choice action
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [ImagePickerUtility createImagePicker:@"Camera" controller:controller];
    }];
    
    // create a photo album choice action
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Album"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [ImagePickerUtility createImagePicker:@"Album" controller:controller];
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Photo Upload"
                                                                   message: @"Choose upload source"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // add the camera action to the alertController
    [alert addAction:cameraAction];
    
    // add the album action to the alert controller
    [alert addAction:albumAction];
    
    return alert;
    
}

@end
