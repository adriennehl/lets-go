//
//  ImageViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/22/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "ImageViewController.h"
#import "ImageUtility.h"
#import "AlertUtility.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *savingIndicator;
@property (nonatomic) CGFloat aspectRatio;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // load in image and fit imageview to aspect ratio
    [self.savingIndicator startAnimating];
    [ImageUtility getImageFromPFFile:self.image completion:^(BOOL finished, UIImage * _Nonnull image) {
        self.aspectRatio = image.size.height / image.size.width;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = width * self.aspectRatio;
        self.albumImageView.frame = CGRectMake(11, 30, width, height);
        [self.savingIndicator stopAnimating];
        self.albumImageView.image = image;
    }];
}

- (IBAction)onSave:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.albumImageView.image, self, @selector(showSavedAlert:didFinishSavingWithError:contextInfo:), nil);
}

- (void)showSavedAlert:(UIImage *)image
didFinishSavingWithError:(NSError *)error
             contextInfo:(void *)contextInfo {
    if(error == nil){
        UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Saved Successfully!" action:@"OK" message:@"The photo has been saved to your library."];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Saving Photo" action:@"Cancel" message:error.localizedDescription];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
