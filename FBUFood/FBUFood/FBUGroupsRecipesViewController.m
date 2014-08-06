//
//  FBUGroupsRecipesViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroupsRecipesViewController.h"
#import "FBURecipeViewController.h"
#import "FBUAddRecipesViewController.h"
#import "FBURecipe.h"
#import <Parse/Parse.h>

@implementation FBUGroupsRecipesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // populated array from wherever the source was -> rename to unfetchedRecipesArray
    // fetchAll
      // in the callback -- set self.recipesArray =
      // reloadData
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.recipesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    
//    if (![self.group checkIfUserIsInGroupArray:self.group.cooksInGroup]) {
//        [self.navigationItem setRightBarButtonItem:nil animated:YES];
//    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.recipesTableView dequeueReusableCellWithIdentifier:@"recipeCell" forIndexPath:indexPath];
    
    FBURecipe *recipe = [self.recipesArray objectAtIndex:indexPath.row];
    
    [recipe fetchIfNeeded];
    
    cell.textLabel.text = recipe[@"title"];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipesArray count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"recipeCell" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recipeCell"]){
        
        FBURecipeViewController *controller = (FBURecipeViewController *)segue.destinationViewController;
        NSIndexPath *ip = [self.recipesTableView indexPathForSelectedRow];
        
        FBURecipe *selectedRecipe = self.recipesArray[ip.row];
        
        controller.recipe = selectedRecipe;
        
        if ([self.sourceVC isEqualToString:@"event"]) {
            controller.eventRecipe = @"event";
            controller.event = self.event;
        }
        NSLog(@"Seguing to the recipe view controller.");
        
    } else if ([segue.identifier isEqualToString:@"addRecipes"]){
        FBUAddRecipesViewController *addRecipesVC = [[FBUAddRecipesViewController alloc] init];
        addRecipesVC = segue.destinationViewController;
        NSLog(@"reached this point");
        
        if ([self.sourceVC isEqualToString:@"group"]) {
            addRecipesVC.group = self.group;
            addRecipesVC.sourceVC = @"group";
            
        } else if ([self.sourceVC isEqualToString:@"event"]) {
            addRecipesVC.event = self.event;
            addRecipesVC.sourceVC = @"event";
        }
    }
}


- (IBAction)unwindToGroupsRecipesListViewController:(UIStoryboardSegue *)segue
{
    if([segue.identifier isEqualToString:@"toRecipesList"]) {
        
        FBUAddRecipesViewController *controller = segue.sourceViewController;
        
        if ([controller.sourceVC isEqualToString:@"group"]) {
            
            [controller addRecipesToGroup];
            self.recipesArray = controller.group.recipesInGroup;

            
        } else if ([controller.sourceVC isEqualToString:@"event"]) {
            
            [controller addRecipesToEvent];
            self.recipesArray = controller.event.recipesInEvent;
            
        }

        [self.recipesTableView reloadData];
    }
}



@end
