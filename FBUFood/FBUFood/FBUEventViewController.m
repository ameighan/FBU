//
//  FBUEventViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUEventViewController.h"
#import "FBUMembersViewController.h"
#import "FBUEventDetailViewController.h"
#import "FBUGroupsRecipesViewController.h"
#import "FBUGroceryListViewController.h"
#import "FBURecipeCollectionViewCell.h"
#import "FBUUserCollectionViewCell.h"
#import "FBURecipeViewController.h"
#import "FBURecipe.h"

@interface FBUEventViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation FBUEventViewController

- (void)viewWillAppear:(BOOL)animated
{

    [self locateEventOnMap];
    [self zoomToLocation];
//    [self importRecipesToGroceryList];
    self.eventRecipesCollectionView.backgroundColor = [UIColor clearColor];
    self.eventMembersCollectionView.backgroundColor = [UIColor clearColor];
    NSLog(@"Members of Event: %@", self.event.membersOfEvent);
    
    [self createButtonUI:self.goingButton];
    [self createButtonUI:self.notGoingButton];
    
    
    self.title = self.event.eventName;
    self.eventLocationLabel.text = self.event.eventAddress;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *date = [dateFormatter stringFromDate:self.event.eventTimeDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *time = [timeFormatter stringFromDate:self.event.eventTimeDate];
    NSString *conjunction = @" \@ ";
    NSString *append = [conjunction stringByAppendingString:time];
    
    self.eventTimeDateLabel.text = [date stringByAppendingString:append];
    
    if (self.event.eventMeals) {
        self.eventMealsLabel.text = [@"Meals: " stringByAppendingString:self.event.eventMeals];
    }
    
    if (![self.event checkIfUserIsInEventArray:self.event.membersOfEvent]) {
        [self toggleNotGoingView];
    } else {
        [self toggleGoingView];
    }
}

- (void)toggleNotGoingView
{
    self.notGoingButton.hidden = NO;
    self.notGoingButton.enabled = YES;
    self.goingButton.hidden = YES;
    self.goingButton.enabled = NO;
}

- (void)toggleGoingView
{
    self.goingButton.hidden = NO;
    self.goingButton.enabled = YES;
    self.notGoingButton.hidden = YES;
    self.notGoingButton.enabled = NO;
}

- (void)importRecipesToGroceryList
{
    if (!self.event.eventGroceryList) {
        self.event.eventGroceryList = [[FBUGroceryList alloc] init];
    }
    self.event.eventGroceryList.recipesToFollow = self.event.recipesInEvent;
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saving grocery list: %@", self.event.eventGroceryList.recipesToFollow);
    }];
}

- (void)createButtonUI:(UIButton *)button
{
    [[button titleLabel] setFont:[UIFont fontWithName:@"Avenir" size:17.0]];
    [button setTintColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00]];
    [button setBackgroundColor:[UIColor whiteColor]];
    [[button layer] setBorderWidth:1.5f];
    [[button layer] setBorderColor:[UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00].CGColor];
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    
}


- (IBAction)userDidJoinEvent:(id)sender
{
    [self showAlertWithTitle:self.title
                     message:[NSString stringWithFormat:@"You are going to %@ !", self.title]];
    
    [self.event addObject:[PFUser currentUser] forKey:@"membersOfEvent"];
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Adding user to the members array");
    }];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:[self.event.eventName stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"channels"];
    [currentInstallation saveInBackground];

    [self toggleGoingView];
}

- (IBAction)userDidUnjoinEvent:(id)sender {
    
    [self showAlertWithTitle:self.title
                     message:[NSString stringWithFormat:@"You are no longer going to %@ !", self.title]];
    [self.event removeObject:[PFUser currentUser]  forKey:@"membersOfEvent"];
    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Removing user from the members array");
    }];
    
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation removeObject:[self.event.eventName stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"channels"];
    [currentInstallation saveInBackground];

    [self toggleNotGoingView];
    
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

# pragma mark - Collection View

- (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.eventRecipesCollectionView) {
        
        NSLog(@"Displaying recipes in event");
        
        FBURecipeCollectionViewCell *cell = [self.eventRecipesCollectionView dequeueReusableCellWithReuseIdentifier:@"recipe" forIndexPath:indexPath];
        
        FBURecipe *recipe = self.event.recipesInEvent[indexPath.row];
        [recipe fetchIfNeeded];
        
        UIImage *recipeImage = [UIImage imageWithData:[recipe.image getData]];
        cell.recipeImage.image = recipeImage;
        
        return cell;
        
    }
    if (collectionView == self.eventMembersCollectionView) {
        
        NSLog(@"Displaying members of event...");
        
        FBUUserCollectionViewCell *cell = [self.eventMembersCollectionView dequeueReusableCellWithReuseIdentifier:@"user" forIndexPath:indexPath];
        
        PFUser *member = self.event.membersOfEvent[indexPath.row];
        [member fetchIfNeeded];
        
        [member[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [UIImage imageWithData:data scale:0.8];
            cell.userProfileImage.image = [self getRoundedRectImageFromImage:image onReferenceView:cell.userProfileImage withCornerRadius: cell.userProfileImage.frame.size.width/2];
        }];
        
        return cell;
    }
    return false;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.eventRecipesCollectionView) {
        return [self.event.recipesInEvent count];
    }
    if (collectionView == self.eventMembersCollectionView) {
        return [self.event.membersOfEvent count];
    }
    return false;
}

# pragma mark - Event Map

- (void)locateEventOnMap
{
    self.eventMapView.centerCoordinate = CLLocationCoordinate2DMake(self.event.eventGeoPoint.latitude, self.event.eventGeoPoint.longitude);
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = self.eventMapView.centerCoordinate;
    point.title = self.event.eventName;
    
    [self.eventMapView addAnnotation:point];
}

-(void)zoomToLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (CLLocationCoordinate2DMake(self.event.eventGeoPoint.latitude, self.event.eventGeoPoint.longitude), 1000, 1000);
    [self.eventMapView setRegion:region animated:NO];
}


# pragma mark - Action Sheet
- (IBAction)moreOptions:(id)sender
{
    
    UIActionSheet *popupMenu = [[UIActionSheet alloc] initWithTitle:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Edit Event",
                                                                    @"Event Dishes",
                                                                    @"Grocery List",
                                                                    nil];
    popupMenu.tag = 1;
    [popupMenu showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popupMenu didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (popupMenu.tag) {
            case 1: {
                switch (buttonIndex) {
                    case 0:
                        [self editEvent];
                        break;
                    case 1:
                        [self eventRecipes];
                        break;
                    case 2:
                        [self groceryList];
                        break;
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:196.0/255.0 green:49.0/255.0 blue:56.0/255.0 alpha:1.00];
        }
    }];
}

# pragma mark - Actions and Segues

- (void)editEvent
{
    [self performSegueWithIdentifier:@"editEvent" sender:self];
}

- (void)eventRecipes
{
    [self performSegueWithIdentifier:@"recipes" sender:self];
}

- (void)groceryList
{
    [self performSegueWithIdentifier:@"groceryList" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PeopleGoing"]){
        FBUMembersViewController *controller = (FBUMembersViewController *)segue.destinationViewController;
        controller.membersArray = self.event.membersOfEvent;
    } else if ([segue.identifier isEqualToString:@"recipes"]){
        
        FBUGroupsRecipesViewController *recipesViewController = [[FBUGroupsRecipesViewController alloc] init];
        recipesViewController = segue.destinationViewController;
        recipesViewController.sourceVC = @"event";
        recipesViewController.event = self.event;
        recipesViewController.recipesArray = self.event.recipesInEvent;
        recipesViewController.title = @"Event Recipes";
        
    } else if ([segue.identifier isEqualToString:@"groceryList"]) {
        FBUGroceryListViewController *groceryListViewController = segue.destinationViewController;
        
        groceryListViewController.groceryList = self.event.eventGroceryList;
        groceryListViewController.title = @"Grocery List";
    } else if ([segue.identifier isEqualToString:@"recipeCell"]) {
        
        FBURecipeViewController *recipeViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.eventRecipesCollectionView indexPathForCell:sender];
        
        FBURecipe *selectedRecipe= self.event.recipesInEvent[indexPath.row];
        
        recipeViewController.recipe = selectedRecipe;
        recipeViewController.event = self.event;
        recipeViewController.eventRecipe = @"event";
    } else if ([segue.identifier isEqualToString:@"editEvent"]) {
        FBUEventDetailViewController *editEventController = segue.destinationViewController;
        
        editEventController.event = self.event;
    }
}

@end
