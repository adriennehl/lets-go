//
//  albumCollectionViewUtility.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/27/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "albumCollectionViewUtility.h"
#import "photoAlbumCell.h"

@implementation albumCollectionViewUtility

- (instancetype)initWithAlbum:(NSArray *)album {
    self = [super init];
    self.album = album;
    return self;
}
- (void)updateAlbum:(NSArray *)album {
    self.album = album;
}

// these three methods layout the collection view
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat minimumInteritemSpacing = 5;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (collectionView.frame.size.width - minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    return CGSizeMake(itemWidth, itemHeight);
}

// these two methods set the content of the collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.count - 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    photoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoAlbumCell" forIndexPath:indexPath];
    cell = [cell setCell:self.album[indexPath.row + 1]];
    return cell;
}


@end
