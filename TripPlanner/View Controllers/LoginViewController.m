//
//  LoginViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "Trip.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// enable log in on button click
- (IBAction)onSignIn:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        
        if (error != nil) {
            UIAlertController *loginAlert = [self createAlert:error.localizedDescription title:@"Error Logging In"];
            
            // show the alert controller
            [self presentViewController: loginAlert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        } else {
            NSLog(@"User logged in successfully");
            
            // update user's list of trips
            [self updateTrips];
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

// update user's list of trips
- (void)updateTrips {
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    NSLog(@"%@", PFUser.currentUser);
    NSLog(@"%@", PFUser.currentUser[@"updatedAt"]);
    [query whereKey:@"createdAt" greaterThan:PFUser.currentUser.updatedAt];
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
        if (!error) {
            PFRelation *relation;
            // add each trip to user's list of trips
            relation = [PFUser.currentUser relationForKey:@"trips"];
            for(Trip *trip in trips) {
                [relation addObject:trip];
            }
            [PFUser.currentUser saveInBackground];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

// enable sign up on button click
- (IBAction)onSignUp:(id)sender {
    // show error if fields are empty
    if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        UIAlertController *alert = [self createAlert:@"Please enter a username and password" title:@"Username and Password Required"];
        
        // show the alert controller
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
        
    }
    
    // otherwise, try to initialize the user object
    else {
        [self registerUser];
    }
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser[@"profileImage"] = [self getPFFileFromImage:[UIImage imageNamed:@"image_placeholder"]];
    newUser[@"name"] = @"";
    newUser[@"numTrips"] = [[NSNumber alloc] initWithInt:0];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            UIAlertController *signupAlert = [self createAlert:error.localizedDescription title:@"Error Signing Up"];
            NSLog(@"%@", error);
            
            // show the alert controller
            [self presentViewController: signupAlert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

// given an error description and title, return an alert with cancel and ok buttons
- (UIAlertController *) createAlert: (NSString *) errorDescription title: (NSString *) title {
    
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // handle cancel response here. Doing nothing will dismiss the view.
    }];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                                                   message:errorDescription
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
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
