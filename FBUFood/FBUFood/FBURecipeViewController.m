//
//  FBURecipeViewController.m
//  FBUFood
//
//  Created by Amber Meighan on 7/18/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipeViewController.h"
#import "FBURecipe.h"
#import "FBUEditRecipeViewController.h"
#import "FBURecipeDishViewController.h"
#import "FBURecipeContainerViewController.h"

@interface FBURecipeViewController ()

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) FBURecipeContainerViewController *container;

@end

@implementation FBURecipeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setBarTintColor:[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:235.0/255.0 alpha:1.0]];
    [self.tabBar setTintColor:[UIColor colorWithRed:252.0/255.0 green:140.0/255.0 blue:106.0/255.0 alpha:0.75]];
    [self createButtonUI:self.importButton];
    
    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:0];
    
    if ([[self.editButton title] isEqualToString:@"Edit"]) {
        NSLog(@"I was here");
        self.importButton.enabled = NO;
        self.importButton.hidden = YES;
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.recipe.title;
    if ([self.eventRecipe isEqualToString:@"event"]) {
        self.container.eventRecipe = @"event";
        self.container.event = self.event;
        NSLog(@"%@", self.container.eventRecipe);
    }
    
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

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item == [tabBar.items objectAtIndex:0]) {
        self.container.toViewSegueIdentifier = @"dish";
        [self.container performSegueWithIdentifier:@"dish" sender:nil];

        NSLog(@"Dish selected");
    } else if (item == [tabBar.items objectAtIndex:1]) {
        self.container.toViewSegueIdentifier = @"ingredients";
        [self.container performSegueWithIdentifier:@"ingredients" sender:nil];

        NSLog(@"Ingredients selected");
    } else if (item == [tabBar.items objectAtIndex:2]) {
        self.container.toViewSegueIdentifier = @"directions";
        [self.container performSegueWithIdentifier:@"directions" sender:nil];
        
        NSLog(@"Directions selected");
    }
    
}
- (IBAction)importRecipe:(id)sender {
    [self showAlertWithTitle:@"Success!" message:@"You imported a recipe!"];
    self.recipe.publisher = [PFUser currentUser];
    self.recipe.fromYummly = YES;
    [self.recipe saveInBackground];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailToEditView"]){
        
        if ([self.editButton.title isEqualToString:@"Edit"]) {
            FBUEditRecipeViewController *controller = (FBUEditRecipeViewController *)segue.destinationViewController;
            
            controller.title = @"Edit Recipe";
            
            controller.recipe.image= self.recipe.image;
            
            controller.recipe.ingredientsList = self.recipe.ingredientsList;
            
            controller.recipe.directions = self.recipe.directions;
            
            controller.recipe.title = self.recipe.title;
            
            controller.recipe = self.recipe;
        }
    } else if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.container = segue.destinationViewController;
        self.container.recipe = self.recipe;
    }
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
