//
//  TripDetailViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/30/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TripDetailViewController.h"
#import "DateUtility.h"
#import "AlertUtility.h"
#import "ImageUtility.h"
#import "MailUtility.h"
#import "photoAlbumCell.h"
#import "ImageViewController.h"

@interface TripDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *declinedLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (weak, nonatomic) IBOutlet PFImageView *tripImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) albumCollectionViewUtility *albumUtility;

@end

@implementation TripDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set up album collection view
    self.albumUtility = [[albumCollectionViewUtility alloc] initWithAlbum:self.trip.album];
    self.albumCollectionView.delegate = self.albumUtility;
    self.albumCollectionView.dataSource = self.albumUtility;
    
    // set trip details
    [self setElements];
}

- (void)setElements {
    // add upload photo button
    UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload Photo" style:UIBarButtonItemStylePlain target:self action:@selector(onViewTap:)];
    self.navigationItem.rightBarButtonItem = uploadButton;
    
    // if current user is a guest, show decline button
    if(self.trip.author != PFUser.currentUser.username) {
        [self.declineButton setHidden:NO];
    }
    // otherwise, show delete and share button
    else {
        [self.deleteButton setHidden:NO];
        [self.shareButton setHidden:NO];
    }
    
    // set trip details
    self.titleLabel.text = self.trip[@"title"];
    self.hostLabel.text = [NSString stringWithFormat:@"Host: %@",self.trip[@"author"]];
    self.locationLabel.text = self.trip[@"location"];
    self.guestLabel.text = @"Guests: ";
    for(NSString *guestUsername in self.trip[@"guests"]) {
        self.guestLabel.text = [NSString stringWithFormat:@"%@%@, ", self.guestLabel.text, guestUsername];
    }
    self.startLabel.text = [DateUtility dateToString:self.trip[@"startDate"]];
    self.endLabel.text = [DateUtility dateToString:self.trip[@"endDate"]];
    self.descriptionLabel.text = self.trip[@"descriptionText"];
    NSArray *images = self.trip[@"album"];
    if(images.count > 0) {
        self.tripImageView.file = self.trip[@"album"][0];
        [self.tripImageView loadInBackground];
    }
    if(self.trip.declined.count > 0) {
        [self.declinedLabel setHidden:NO];
        self.declinedLabel.text = @"Declined: ";
        for(NSString *guestUsername in self.trip[@"declined"]) {
            self.declinedLabel.text = [NSString stringWithFormat:@"%@%@, ", self.declinedLabel.text, guestUsername];
        }
    }
}

- (IBAction)onDecline:(id)sender {
    // remove user from trip guests
    [self.trip removeObject:PFUser.currentUser.username forKey:@"guests"];
    
    // add user to trip declined list
    [self.trip addObject:PFUser.currentUser.username forKey:@"declined"];
    [self.trip saveInBackground];
    
    // remove trip from user's list of trips
    PFRelation *relation = [PFUser.currentUser relationForKey:@"trips"];
    [relation removeObject:self.trip];
    [PFUser.currentUser saveInBackground];
    
    // delete notification
    [NotificationUtility deleteNotification:self.trip.objectId];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDelete:(id)sender {
    UIAlertController *deleteAlert = [AlertUtility createDoubleActionAlert:@"Deleted trips cannot be retrieved." title:@"Confirm Delete" withHandler:^(UIAlertAction * _Nonnull action) {
        [self.trip deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error == nil) {
                // delete notification
                [NotificationUtility deleteNotification:self.trip.objectId];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
               UIAlertController *alert =  [AlertUtility createCancelActionAlert:@"Error Deleting Trip" action:@"Cancel" message:error.localizedDescription];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }];
    [self presentViewController:deleteAlert animated:YES completion:nil];
}

// allow user to send an email on tap
- (IBAction)onShare:(id)sender {
    // check to make sure device can send mail
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:self.trip.title];
        NSString *message = [MailUtility composeMessage:self.trip];
        [mailVC setMessageBody:message isHTML:NO];
        if(self.trip.album.count > 0) {
            PFFileObject *image = self.trip.album[0];
            NSData *imageData = [image getData];
            [mailVC addAttachmentData:imageData mimeType:@"image/png" fileName:@"trip image"];
        }
        [self presentViewController:mailVC animated:YES completion:nil];
    } else {
        UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Cannot access mail" action:@"Cancel" message:@"Cannot send mail from this device"];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// allow user to pick an image source type on tap
- (void)onViewTap:(id)sender {
    UIAlertController *sourceTypeAlert = [AlertUtility createSourceTypeAlert:self];
    
    // show the alert controller
    [self presentViewController: sourceTypeAlert animated:YES completion:^{
    }];
}

// after user picks image, add image to photo album
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // resize image
    CGFloat aspectRatio = originalImage.size.height / originalImage.size.width;
    CGFloat width = 700;
    CGSize size = CGSizeMake(width, width * aspectRatio);
    UIImage *resizedImage = [ImageUtility resizeImage:originalImage withSize:size];
    
    NSArray *album = [self.trip.album arrayByAddingObject:[ImageUtility getPFFileFromImage:resizedImage]];
    self.trip.album = album;
    [self.albumUtility updateAlbum:album];
    [self.trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            [self.albumCollectionView reloadData];
        }
        else {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Loading Album" action:@"Cancel" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    // Dismiss UIImagePickerController to go back to original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"photoSegue"]) {
        ImageViewController *destinationViewController = [segue destinationViewController];
        photoAlbumCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.albumCollectionView indexPathForCell:tappedCell];
        destinationViewController.image = self.trip.album[indexPath.row + 1];
    }
}

@end
