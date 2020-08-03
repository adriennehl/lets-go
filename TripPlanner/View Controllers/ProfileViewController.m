//
//  ProfileViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "TripDetailViewController.h"
#import "ImageUtility.h"
#import "AlertUtility.h"
#import "SceneDelegate.h"
#import "TripCell.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *pastTripsTableView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) NSArray *trips;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pastTripsTableView.delegate = self;
    self.pastTripsTableView.dataSource = self;
    
    self.usernameLabel.text = PFUser.currentUser.username;
    self.nameLabel.text = PFUser.currentUser[@"name"];
    self.profileImageView.file = PFUser.currentUser[@"profileImage"];
    [self.profileImageView loadInBackground];
    self.profileImageView.layer.borderWidth = 2;
    [self.profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchPastTrips];
}

// enable user log out
- (IBAction)onLogOut:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    // create storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // create new instance of view controller in storyboard
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    // set root view controller
    sceneDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

// allow user to edit name and profile photo
- (IBAction)onEdit:(id)sender {
    [self.saveButton setHidden:NO];
    [self.cancelButton setHidden:NO];
    [self.editButton setHidden:YES];
    self.nameLabel.userInteractionEnabled = YES;
    self.profileImageView.userInteractionEnabled = YES;
    self.nameLabel.borderStyle = UITextBorderStyleRoundedRect;
    self.nameLabel.backgroundColor = UIColor.whiteColor;
    
    
}

- (void)endEditing {
    [self.saveButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    [self.editButton setHidden:NO];
    self.nameLabel.userInteractionEnabled = NO;
    self.profileImageView.userInteractionEnabled = NO;
    self.nameLabel.borderStyle = UITextBorderStyleNone;
    self.nameLabel.backgroundColor = UIColor.clearColor;
}

- (IBAction)onCancel:(id)sender {
    [self endEditing];
    self.nameLabel.text = PFUser.currentUser[@"name"];
    self.profileImageView.file = PFUser.currentUser[@"profileImage"];
    [self.profileImageView loadInBackground];
}

// save changes to Parse
- (IBAction)onSave:(id)sender {
    [self endEditing];
    PFUser.currentUser[@"name"] = self.nameLabel.text;
    PFFileObject *profileImage = [ImageUtility getPFFileFromImage:self.profileImageView.image];
    PFUser.currentUser[@"profileImage"] = profileImage;
    [PFUser.currentUser saveInBackground];
}

- (IBAction)onImageTap:(id)sender {
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
    CGSize size = CGSizeMake(100, 100);
    UIImage *resizedImage = [ImageUtility resizeImage:originalImage withSize:size];
    self.profileImageView.image = resizedImage;
    
    // Dismiss UIImagePickerController to go back to original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

// get past trips from user's trips relation
- (void)fetchPastTrips {
    PFRelation *relation = [PFUser.currentUser relationForKey:@"trips"];
    PFQuery *query = [relation query];
    [query orderByDescending:@"startDate"];
    [query whereKey:@"endDate" lessThan:[NSDate date]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
      if (!error) {
          self.trips = trips;
          [self.pastTripsTableView reloadData];
      } else {
          UIAlertController *alert = [AlertUtility createCancelActionAlert:@"Error Updating Trips" action:@"Cancel" message:error.localizedDescription];
          [self presentViewController:alert animated:YES completion:nil];
      }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripCell" forIndexPath:indexPath];
    cell = [cell setCell:self.trips[indexPath.row]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"detailSegue"]){
           // get destination view controller
           TripDetailViewController *destinationViewController = [segue destinationViewController];
           TripCell *tappedCell = sender;
           // get indexPath of tapped cell
           NSIndexPath *indexPath = [self.pastTripsTableView indexPathForCell:tappedCell];
           // get trip of tapped cell
           destinationViewController.trip = self.trips[indexPath.row];
       }
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

@end
