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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.recipesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"recipeCell"];
    
    if (![self.group checkIfUserIsInGroupArray:self.group.cooksInGroup]) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.recipesTableView dequeueReusableCellWithIdentifier:@"recipeCell" forIndexPath:indexPath];
    
    FBURecipe *recipe = [self.group.recipesInGroup objectAtIndex:indexPath.row];
    
    cell.textLabel.text = recipe[@"title"];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.group.recipesInGroup count];
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
        
        FBURecipe *selectedRecipe = self.group.recipesInGroup[ip.row];
        
        controller.recipe = selectedRecipe;
        NSLog(@"Seguing to the recipe view controller.");
        
    } else if ([segue.identifier isEqualToString:@"addRecipes"]){
        
        FBUAddRecipesViewController *addRecipesViewController = segue.destinationViewController;
        addRecipesViewController.group = self.group;
    }
}



@end
