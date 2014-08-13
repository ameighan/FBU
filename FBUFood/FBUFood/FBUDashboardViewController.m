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
#import "FBUMapViewController.h"

#define kCollectionCellBorderTop 10.0
#define kCollectionCellBorderBottom 17.0
#define kCollectionCellBorderLeft 17.0
#define kCollectionCellBorderRight 17.0

@interface FBUDashboardViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
@property (weak, nonatomic) IBOutlet UIView *blankView;
@property (weak, nonatomic) IBOutlet UICollectionView *dashboardCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *blankSlateImageView;

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

- (IBAction)exploreButtonPressed:(id)sender
{
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
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
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //Establishing a location manager that will start updating the location of the user
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    
    if (![PFUser currentUser]) { // No user logged in
        [self makeLoginAppear];
    }
    
    self.blankSlateImageView.image = [UIImage imageNamed:@"fork&knife.png"];
    
    self.blankView.hidden = YES;
}

#pragma mark - UICollectionViewDelegateJSPintLayout
- (CGFloat)columnWidthForCollectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
{
    return 155.0;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    FBUEvent *event = self.eventsArray[indexPath.row];
    if (!event.featureImageHeight) {
        return 200;
    }
    return event.featureImageHeight;
}

# pragma mark - Collection View Data Source
- (void)queryForEvents
{
    __weak FBUDashboardViewController *blockSelf = self;
    PFQuery *eventQuery = [FBUEvent query];
    [eventQuery whereKey:@"membersOfEvent" equalTo:[PFUser currentUser]];
    [eventQuery includeKey:@"eventGroceryList"];
    [eventQuery includeKey:@"recipesInEvent"];
    [eventQuery orderByAscending:@"eventTimeDate"];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        blockSelf.eventsArray = objects;
        if (blockSelf.eventsArray.count == 0){
            blockSelf.dashboardCollectionView.hidden = YES;
            blockSelf.blankView.hidden = NO;
        } else {
            blockSelf.blankView.hidden = YES;
            [blockSelf.activityIndicator stopAnimating];
            [blockSelf.dashboardCollectionView reloadData];
        }
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
    FBUEvent *event = self.eventsArray[indexPath.row];
    
    UICollectionViewCell *cell = [self.dashboardCollectionView dequeueReusableCellWithReuseIdentifier:@"eventCell" forIndexPath:indexPath];
    
    CGRect rectReference = cell.bounds;
    FBUCollectionCellBackgroundView* backgroundView = [[FBUCollectionCellBackgroundView alloc] initWithFrame:rectReference];
    cell.backgroundView = backgroundView;
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:rectReference];
    selectedBackgroundView.backgroundColor = [UIColor clearColor];   // no indication of selection
    cell.selectedBackgroundView = selectedBackgroundView;
    
    // remove subviews from previous usage of this cell
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!event.featureImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fork&knife.png"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGSize rctSizeOriginal = imageView.bounds.size;
        double scale = (cell.bounds.size.width  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
        CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
        imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop + 20,rctSizeFinal.width,rctSizeFinal.height);
        
        [cell.contentView addSubview:imageView];
        
        CGRect descriptionLabel = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop + rctSizeFinal.height + 10,rctSizeFinal.width,65);
        CGRect nameLabel = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop, rctSizeFinal.width,15);
        
        UILabel* name = [[UILabel alloc] initWithFrame:nameLabel];
        name.numberOfLines = 0;
        name.font = [UIFont systemFontOfSize:12];
        
        UILabel* description = [[UILabel alloc] initWithFrame:descriptionLabel];
        description.numberOfLines = 2;
        description.font = [UIFont systemFontOfSize:12];
        
        name.text = [event eventName];
        description.text = [event eventDescription];
        
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:description];
        
        return cell;
    } else {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.color = [UIColor darkGrayColor];
        [indicator startAnimating];
        [indicator hidesWhenStopped];
        
        [imageView addSubview:indicator];
        
        [event.featureImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            [imageView removeFromSuperview];
            imageView.image = [UIImage imageWithData:data];
            [indicator stopAnimating];
            
            CGSize rctSizeOriginal = imageView.bounds.size;
            double scale = (cell.bounds.size.width  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
            CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
            imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop + 20,rctSizeFinal.width,rctSizeFinal.height);
            
            [cell.contentView addSubview:imageView];
            
        }];
        
        CGSize rctSizeOriginal = CGSizeMake(80,event.featureImageHeight-100);
        double scale = (cell.bounds.size.width  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
        CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
        imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop + 20,rctSizeFinal.width,rctSizeFinal.height);
        
        [cell.contentView addSubview:imageView];
        
        CGRect descriptionLabel = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop + rctSizeFinal.height + 10,rctSizeFinal.width,65);
        CGRect nameLabel = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop, rctSizeFinal.width,15);
        
        UILabel* name = [[UILabel alloc] initWithFrame:nameLabel];
        name.numberOfLines = 0;
        name.font = [UIFont systemFontOfSize:12];
        
        UILabel* description = [[UILabel alloc] initWithFrame:descriptionLabel];
        description.numberOfLines = 2;
        description.font = [UIFont systemFontOfSize:12];
        
        name.text = [event eventName];
        description.text = [event eventDescription];
        
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:description];
        
        return cell;

    }
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
                NSLog(@" my email %@", email);
                
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

