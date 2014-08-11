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
    [self importRecipesToGroceryList];
    self.eventRecipesCollectionView.backgroundColor = [UIColor clearColor];

    
    
    self.title = self.event.eventName;
    self.eventLocationLabel.text = self.event.eventAddress;
    self.eventTimeDateLabel.text = self.event.eventTimeDate;
    self.eventMealsLabel.text = [@"Meals: " stringByAppendingString:self.event.eventMeals];
    if (self.event.creator != [PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.event.membersOfEvent == NULL) {
        NSLog(@"%@", self.event.membersOfEvent);
        self.eventJoinButton.hidden = NO;
        self.eventJoinButton.enabled = YES;
    } else if ([self.event checkIfUserIsInEventArray:self.event.membersOfEvent]) {
        NSLog(@"%@", self.event.membersOfEvent);
        self.eventJoinButton.hidden = YES;
        self.eventJoinButton.enabled = NO;
    }
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


- (IBAction)userDidJoinEvent:(id)sender
{
    [self showAlertWithTitle:self.title
                     message:[NSString stringWithFormat:@"You are going to %@ !", self.title]];
    
    [self.event addObject:[PFUser currentUser] forKey:@"membersOfEvent"];
    [self.event saveInBackground];
    
    //Disable join button once user has joined.
    self.eventJoinButton.hidden = YES;
    self.eventJoinButton.enabled = NO;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PeopleGoing"]){
        
        FBUMembersViewController *controller = (FBUMembersViewController *)segue.destinationViewController;
        controller.membersArray = self.event.membersOfEvent;
    } else if ([segue.identifier isEqualToString:@"eventRecipes"]){
        
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
    }
}

# pragma mark - Collection View

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FBURecipeCollectionViewCell *cell = [self.eventRecipesCollectionView dequeueReusableCellWithReuseIdentifier:@"recipe" forIndexPath:indexPath];
    
    FBURecipe *recipe = self.event.recipesInEvent[indexPath.row];
    
    UIImage *recipeImage = [UIImage imageWithData:[recipe.image getData]];
    cell.recipeImage.image = recipeImage;

    return cell;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.event.recipesInEvent count];
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

@end
