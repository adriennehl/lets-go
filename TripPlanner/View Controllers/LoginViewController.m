//
//  LoginViewController.m
//  TripPlanner
//
//  Created by Adrienne Li on 7/13/20.
//  Copyright © 2020 ahli. All rights reserved.
//

#import "AlertUtility.h"
#import "ImageUtility.h"
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
            UIAlertController *loginAlert = [AlertUtility createDoubleActionAlert:error.localizedDescription title:@"Error Logging In"];
            
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
    [query whereKey:@"createdAt" greaterThan:PFUser.currentUser.updatedAt];
    [query findObjectsInBackgroundWithBlock:^(NSArray *trips, NSError *error) {
        if (!error) {
            PFRelation *relation;
            // add each trip where user is a guest to user's list of trips
            relation = [PFUser.currentUser relationForKey:@"trips"];
            for(Trip *trip in trips) {
                for(NSString *guestUsername in trip[@"guests"]) {
                    if ([PFUser.currentUser.username isEqualToString:guestUsername]) {
                        [relation addObject:trip];
                        break;
                    }
                }
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
        UIAlertController *alert = [AlertUtility createDoubleActionAlert:@"Please enter a username and password" title:@"Username and Password Required"];
        
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
    newUser[@"profileImage"] = [ImageUtility getPFFileFromImage:[UIImage imageNamed:@"image_placeholder"]];
    newUser[@"name"] = @"";
    newUser[@"numTrips"] = [[NSNumber alloc] initWithInt:0];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            UIAlertController *signupAlert = [AlertUtility createDoubleActionAlert:error.localizedDescription title:@"Error Signing Up"];
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

@end
