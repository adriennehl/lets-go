//
//  albumCollectionViewUtility.h
//  TripPlanner
//
//  Created by Adrienne Li on 7/27/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface albumCollectionViewUtility : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *album;
- (instancetype)initWithAlbum:(NSArray *)album;
- (void)updateAlbum:(NSArray *)album;

@end

NS_ASSUME_NONNULL_END
