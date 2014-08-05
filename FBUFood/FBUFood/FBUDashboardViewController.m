//
//  FBUDashboardViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUDashboardViewController.h"
#import "FBUEvent.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FBULoginViewController.h"
#import "FBUProfileViewController.h"
#import "FBULogInViewController.h"
#import "FBUSignUpViewController.h"
#import "FBUEventViewController.h"
#import "FBUCollectionViewCell.h"

@interface FBUDashboardViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end

@implementation FBUDashboardViewController


-(void)makeLoginAppear
{
    // Create the log in view controller
    FBULogInViewController *logInViewController = [[FBULogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    [logInViewController setFacebookPermissions:@[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"user_friends"]];
    [logInViewController setFields: PFLogInFieldsFacebook | PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton];
    
    // Create the sign up view controller
    FBUSignUpViewController *signUpViewController = [[FBUSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    [signUpViewController setFields:PFSignUpFieldsAdditional | PFSignUpFieldsDismissButton | PFSignUpFieldsSignUpButton | PFSignUpFieldsEmail | PFSignUpFieldsAdditional];
    
    // Formats the additional field
    signUpViewController.signUpView.additionalField.placeholder = @"Phone Number";
    signUpViewController.signUpView.additionalField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
 
}


- (IBAction)logoutButtonPressed:(id)sender
{
    [PFUser logOut];
    
    NSLog(@"Logging out...");
    [self makeLoginAppear];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) { // No user logged in
        [self makeLoginAppear];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryForEvents];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Establishing a location manager that will start updating the location of the user
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    NSLog(@"Location manager is beginning to update location.");
    
    if (![PFUser currentUser]) { // No user logged in
        [self makeLoginAppear];
    }
    
}


# pragma mark - Collection View

- (void)queryForEvents
{
    __weak FBUDashboardViewController *blockSelf = self;
    PFQuery *eventQuery = [FBUEvent query];
    [eventQuery whereKey:@"membersOfEvent" equalTo:[PFUser currentUser]];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        blockSelf.eventsArray = objects;
        [blockSelf.dashboardCollectionView reloadData];
    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"eventCell"]) {
        FBUEventViewController *controller = (FBUEventViewController *)segue.destinationViewController;
        NSIndexPath *ip = [self.dashboardCollectionView indexPathForCell:sender];
        controller.event = self.eventsArray[ip.row];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FBUCollectionViewCell *cell = [self.dashboardCollectionView dequeueReusableCellWithReuseIdentifier:@"eventCell" forIndexPath:indexPath];
    
    FBUEvent *event = self.eventsArray[indexPath.row];
    
    cell.nameLabel.text = [event eventName];
    cell.descriptionLabel.text = [event eventDescription];

    
    return cell;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.eventsArray count];
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        //Begin login process
        return YES;
    }
    // Interrupt login process
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"Logging in!");
    
    if ([PFFacebookUtils session]) {
        
        //Create request for user's Facebook data
        FBRequest *request = [FBRequest requestForMe];
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                
                NSString *facebookID = userData[@"id"];
                NSString *name = userData[@"name"];
                //NSString *location = userData[@"location"][@"name"];
                NSString *email = userData[@"email"];
                
                NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
                
                NSArray* friends = userData[@"data"];
                NSLog(@"Found: %lu friends", friends.count);
                for (NSDictionary<FBGraphUser>* friend in friends) {
                    NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
                }
                //Now add the data to the UI elements ...
                
                PFUser *user = [PFUser currentUser];
                user[@"FBid"] = facebookID;
                user[@"name"]= name;
                user[@"email"] = email;
                user[@"fbImage"] = pictureURL;
                [user saveInBackground];
            }
        }];
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    [self showAlertWithTitle:@"Login failed"
                     message:@"Username and/or password was not entered correctly. Try again."];
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}




@end

