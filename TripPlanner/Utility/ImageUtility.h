//
//  ImageUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/15/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageUtility : NSObject
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
+ (void)getImageFromPFFile: (PFFileObject *)image completion:(void(^)(BOOL finished, UIImage *image))completion;
@end

NS_ASSUME_NONNULL_END
