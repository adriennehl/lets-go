//
//  TripViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "TripViewController.h"
#import "Trip.h"

@interface TripViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *tripImageView;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *guestsField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;


@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// get guests array
- (NSMutableArray *)getGuestsArray:(NSString *)guestsString {
    // separate guests in guestsString
    NSArray *guestItems = [guestsString componentsSeparatedByString:@","];
    // strip spaces and add to a new mutable array
    NSMutableArray *guests = [[NSMutableArray alloc] init];
    for (NSString* guestItem in guestItems) {
        NSString *trimmed = [guestItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [guests addObject:trimmed];
    }
    
    return guests;
}

// resize image
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// after user picks image, set image view to resized image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // resize image
    CGSize size = CGSizeMake(180, 250);
    UIImage *resizedImage = [self resizeImage:originalImage withSize:size];
    
    // set image
    [self.tripImageView setImage:resizedImage];
    
    // Dismiss UIImagePickerController to go back to original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

// show an image picker that allows user to choose source type
- (void)createImagePicker:(NSString *)sourceType{
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    
    if([sourceType isEqualToString:@"Camera"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

// allow user to pick an image source type on tap
- (IBAction)onViewTap:(id)sender {
    UIAlertController *sourceTypeAlert = [self createAlert];
    
    // show the alert controller
    [self presentViewController: sourceTypeAlert animated:YES completion:^{
    }];
}

- (IBAction)onSave:(id)sender {
    NSMutableArray *guests = [self getGuestsArray:self.guestsField.text];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    [images addObject:[self getPFFileFromImage:self.tripImageView.image]];
    [Trip postUserTrip:guests withImages:images withDescription:self.descriptionTextView.text withTitle:self.titleField.text withLocation:self.locationField.text withStartDate:self.startDatePicker.date withEndDate:self.endDatePicker.date withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Trip posted successfully!");
        }
    }];
}

- (IBAction)onCancel:(id)sender {
}

- (UIAlertController *) createAlert {
    // create a camera choice action
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self createImagePicker:@"Camera"];
    }];
    
    // create a photo album choice action
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Album"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [self createImagePicker:@"Album"];
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Photo Upload"
                                                                   message: @"Choose upload source"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // add the cancel action to the alertController
    [alert addAction:cameraAction];
    
    // add the OK action to the alert controller
    [alert addAction:albumAction];
    
    return alert;
    
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
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
