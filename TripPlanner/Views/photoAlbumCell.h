//
//  photoAlbumCell.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/16/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface photoAlbumCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
- (photoAlbumCell *)setCell:(UIImage *)photo;

@end

NS_ASSUME_NONNULL_END
