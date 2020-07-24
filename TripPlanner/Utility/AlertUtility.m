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

// alert with cancel and ok buttons
+ (UIAlertController *) createDoubleActionAlert: (NSString *) errorDescription title: (NSString *) title withHandler:(void(^)(UIAlertAction * _Nonnull action))handler {
    
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // handle cancel response here. Doing nothing will dismiss the view.
    }];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:handler];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                                                   message:errorDescription
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    return alert;
    
}

// alert with single cancel action
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

// alert with single action
+ (UIAlertController *)createSingleActionAlert: (NSString *)title action:(NSString *)action message:(NSString *)message withCompletion:(void(^)(BOOL finished))completion {
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:action
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
        completion(YES);
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                                                   message: message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // add the action to the alertController
    [alert addAction:alertAction];
    return alert;
    
}


// alert that allows user to choose between camera or album photo source
+ (UIAlertController *) createSourceTypeAlert: (ImagePickerViewController *)controller {
    // create a camera choice action
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [ImagePickerUtility createImagePicker:UIImagePickerControllerSourceTypeCamera controller:controller];
    }];
    
    // create a photo album choice action
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Album"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [ImagePickerUtility createImagePicker:UIImagePickerControllerSourceTypePhotoLibrary controller:controller];
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
