//
//  TripViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TripViewController.h"
#import "SuggestViewController.h"
#import "ImageViewController.h"
#import "photoAlbumCell.h"
#import "AlertUtility.h"
#import "ImageUtility.h"
#import "DateUtility.h"
#import "Trip.h"
@import Parse;

@interface TripViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *hostField;
@property (weak, nonatomic) IBOutlet PFImageView *tripImageView;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *guestsField;
@property (weak, nonatomic) IBOutlet UILabel *guestList;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *suggestTimesButton;
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *startDateField;
@property (weak, nonatomic) IBOutlet UITextField *endDateField;
@property (strong, nonatomic) NSMutableArray *guests;
@property (strong, nonatomic) NSMutableArray *guestUsernames;
@property (nonatomic) CGFloat aspectRatio;


@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.guests = [[NSMutableArray alloc] init];
    self.guestUsernames = [[NSMutableArray alloc] init];
    self.descriptionTextView.layer.borderWidth = 2;
    self.albumCollectionView.delegate = self;
    self.albumCollectionView.dataSource = self;
    
    // set date pickers
    [self setDatePickers];
    
    
    // if self.trip is set, show trip detail
    if(self.trip) {
        [self setElements];
    }
    else {
        self.hostField.text = [NSString stringWithFormat:@"Host: %@",PFUser.currentUser.username];
    }
    
    // if self.place is set, autofill location, title, and image
    if(self.place) {
        [self setLocation];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateStartField];
    [self updateEndField];
}

- (void)setDatePickers {
    // set start date picker
    self.startDatePicker = [DateUtility createDatePicker];
    [self.startDatePicker addTarget:self action:@selector(updateStartField) forControlEvents:UIControlEventValueChanged];
    [self.startDateField setInputView:self.startDatePicker];
    
    // set end date picker
    self.endDatePicker = [DateUtility createDatePicker];
    [self.endDatePicker addTarget:self action:@selector(updateEndField) forControlEvents:UIControlEventValueChanged];
    [self.endDateField setInputView:self.endDatePicker];
}

- (void)updateStartField {
    self.startDateField.text = [DateUtility dateToString:self.startDatePicker.date];
}

- (void)updateEndField {
    self.endDateField.text = [DateUtility dateToString:self.endDatePicker.date];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat minimumInteritemSpacing = 5;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.albumCollectionView.frame.size.width - minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    return CGSizeMake(itemWidth, itemHeight);
}

// switches to previous controller
- (void)backToFeed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLocation {
    // add back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToFeed)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.titleField.text = [NSString stringWithFormat:@"%@ Trip", self.place.name];
    self.locationField.text = self.place.address;
    if(self.place.photosArray) {
        NSNumber *width = self.place.photosArray[0][@"width"];
        NSNumber *height = self.place.photosArray[0][@"height"];
        self.aspectRatio = height.doubleValue / width.doubleValue;
        self.tripImageView.image = [UIImage imageWithData:self.place.photoData];
    }
    else {
        self.tripImageView.image = [UIImage imageNamed:@"image_placeholder"];
    }
    [self.tripImageView loadInBackground];
}

- (void)setElements {
    // add back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToFeed)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // add upload photo button
    UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload Photo" style:UIBarButtonItemStylePlain target:self action:@selector(onViewTap:)];
    self.navigationItem.rightBarButtonItem = uploadButton;
    
    // remove other buttons
    self.addButton.alpha = 0;
    self.guestsField.alpha = 0;
    self.suggestTimesButton.alpha = 0;
    
    // set trip details
    self.titleField.text = self.trip[@"title"];
    self.hostField.text = [NSString stringWithFormat:@"Host: %@",self.trip[@"author"]];
    self.locationField.text = self.trip[@"location"];
    self.guestList.text = @"Guests: ";
    for(NSString *guestUsername in self.trip[@"guests"]) {
        self.guestList.text = [NSString stringWithFormat:@"%@%@, ", self.guestList.text, guestUsername];
    }
    self.startDatePicker.date = self.trip[@"startDate"];
    self.endDatePicker.date = self.trip[@"endDate"];
    self.descriptionTextView.text = self.trip[@"description"];
    NSArray *images = self.trip[@"images"];
    if(images.count > 0) {
        self.tripImageView.file = self.trip[@"images"][0];
        [self.tripImageView loadInBackground];
    }
    
    // prevent editing
    self.titleField.userInteractionEnabled = NO;
    self.hostField.userInteractionEnabled = NO;
    self.locationField.userInteractionEnabled = NO;
    self.descriptionTextView.userInteractionEnabled = NO;
    self.startDatePicker.userInteractionEnabled = NO;
    self.endDatePicker.userInteractionEnabled = NO;
    self.tripImageView.userInteractionEnabled = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.trip.images.count - 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    photoAlbumCell *cell = [self.albumCollectionView dequeueReusableCellWithReuseIdentifier:@"photoAlbumCell" forIndexPath:indexPath];
    cell = [cell setCell:self.trip.images[indexPath.row + 1]];
    return cell;
}

// checks if user with username is in the guest list
- (BOOL)hasGuest: (NSString *)username guests: (NSMutableArray *)guests {
    for(NSString *guestUsername in guests) {
        if ([username isEqualToString:guestUsername]) {
            return YES;
        }
    }
    return NO;
}

// save trip to Parse database
- (IBAction)onSave:(id)sender {
    [self.savingIndicator startAnimating];
    
    // check to make sure end date is after start date
    if([self.endDatePicker.date compare:self.startDatePicker.date] != NSOrderedAscending) {
        NSArray *images = [[NSArray alloc] initWithObjects:[ImageUtility getPFFileFromImage:self.tripImageView.image], nil];
        [Trip postUserTrip:self.guestUsernames withImages:images withDescription:self.descriptionTextView.text withTitle:self.titleField.text withLocation:self.locationField.text withStartDate:self.startDatePicker.date withEndDate:self.endDatePicker.date withGuests:self.guests withController:self withAspectRatio:self.aspectRatio];
    }
    else {
        UIAlertController *invalidDateAlert = [AlertUtility createCancelActionAlert:@"Invalid Date" action:@"Cancel" message:@"End date must be after start date"];
        [self presentViewController:invalidDateAlert animated:YES completion:nil];
    }
}

// clear fields on cancel
- (IBAction)onCancel:(id)sender {
    // reset fields
    self.titleField.text = nil;
    self.locationField.text = nil;
    self.guestsField.text = nil;
    self.guestList.text = @"Guests: ";
    self.guestUsernames = [[NSMutableArray alloc] init];
    self.guests = [[NSMutableArray alloc] init];
    self.startDatePicker.date = [NSDate date];
    self.endDatePicker.date = [NSDate date];
    self.descriptionTextView.text = nil;
    self.tripImageView.image = [UIImage imageNamed:@"image_placeholder"];
    if(self.place) {
        [self backToFeed];
    }
}

// verify if username is valid and add guest to the list
- (IBAction)onAdd:(id)sender {
    // check if user is in database
    NSString *username = self.guestsField.text;
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        // user does not exist
        if(users.count == 0) {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Adding Guest" action:@"Cancel" message:@"Username does not exist"];
            [self presentViewController: alert animated:YES completion:^{
            }];
        }
        // user is already added
        else if([self hasGuest:username guests:self.guestUsernames]) {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Adding Guest" action:@"Cancel" message:@"User already added"];
            [self presentViewController: alert animated:YES completion:^{
            }];
        }
        // user is current user
        else if([username isEqualToString:PFUser.currentUser.username]) {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Adding Guest" action:@"Cancel" message:@"Can't add yourself"];
            [self presentViewController: alert animated:YES completion:^{
            }];
        }
        // user can be added to list
        else {
            UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Successful" action:@"Ok" message:@"Guest was successfully added"];
            [self presentViewController: alert animated:YES completion:^{
            }];
            self.guestList.text = [NSString stringWithFormat:@"%@%@, ", self.guestList.text, username];
            [self.guestUsernames addObject:username];
            [self.guests addObject:users[0]];
        }
        self.guestsField.text = @"";
    }];
}

// hide keyboard anytime user taps outside of fields
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

// allow user to pick an image source type on tap
- (IBAction)onViewTap:(id)sender {
    UIAlertController *sourceTypeAlert = [AlertUtility createSourceTypeAlert:self];
    
    // show the alert controller
    [self presentViewController: sourceTypeAlert animated:YES completion:^{
    }];
}

// after user picks image, set image view to resized image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // resize image
    CGFloat aspectRatio = originalImage.size.height / originalImage.size.width;
    CGFloat width = 700;
    CGSize size = CGSizeMake(width, width * aspectRatio);
    UIImage *resizedImage = [ImageUtility resizeImage:originalImage withSize:size];
    
    // if in detail view, upload photo to photo album
    if(self.trip) {
        NSArray *images = [self.trip.images arrayByAddingObject:[ImageUtility getPFFileFromImage:resizedImage]];
        self.trip.images = images;
        [self.trip saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                [self.albumCollectionView reloadData];
            }
            else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
    }
    // otherwise, in creation view, upload photo to image view
    else {
        // set image
        self.aspectRatio = originalImage.size.height/originalImage.size.width;
        [self.tripImageView setImage:resizedImage];
    }
    
    // Dismiss UIImagePickerController to go back to original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"suggestSegue"]) {
         SuggestViewController *destinationViewController = [segue destinationViewController];
         destinationViewController.guests = self.guests;
         if(self.place) {
             destinationViewController.place = self.place;
         }
     }
     else if ([segue.identifier isEqualToString:@"photoSegue"]) {
         ImageViewController *destinationViewController = [segue destinationViewController];
         photoAlbumCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.albumCollectionView indexPathForCell:tappedCell];
         destinationViewController.image = self.trip.images[indexPath.row + 1];
     }
     
 }

@end
