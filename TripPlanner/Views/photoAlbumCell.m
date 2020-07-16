//
//  photoAlbumCell.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/16/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "photoAlbumCell.h"

@implementation photoAlbumCell

- (photoAlbumCell *)setCell:(PFFileObject *)photo {
    self.photoView.file = photo;
    [self.photoView loadInBackground];
    return self;
}

@end
