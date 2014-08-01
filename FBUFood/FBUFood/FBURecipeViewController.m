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




@property (strong, nonatomic) FBURecipeContainerViewController *container;
@end

@implementation FBURecipeViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.recipe.title;
    
    
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailToEditView"]){
        
        FBUEditRecipeViewController *controller = (FBUEditRecipeViewController *)segue.destinationViewController;
        
        controller.title = @"Edit Recipe";
        
        controller.recipe.image= self.recipe.image;
        
        controller.recipe.ingredientsList = self.recipe.ingredientsList;
        
        controller.recipe.directions = self.recipe.directions;
        
        controller.recipe.title = self.recipe.title;
        
        controller.recipe = self.recipe;

    } else if ([segue.identifier isEqualToString:@"embedContainer"]) {
    
        NSLog(@"%s", __PRETTY_FUNCTION__);
        self.container = segue.destinationViewController;
        self.container.recipe = self.recipe;
    }
}

@end
