//
//  FBUAddRecipesViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/28/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUAddRecipesViewController.h"
#import "FBURecipesListViewController.h"
#import "FBURecipe.h"

@implementation FBUAddRecipesViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryForRecipes];
}

-(void)queryForRecipes
{
    __weak FBUAddRecipesViewController *blockSelf = self;
    PFQuery *getRecipes = [FBURecipe query];
    [getRecipes whereKey:@"publisher" equalTo:[PFUser currentUser]];
    [getRecipes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        blockSelf.recipesArray = objects;
        [blockSelf.recipesTableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.recipesTableView dequeueReusableCellWithIdentifier:@"recipeCell" forIndexPath:indexPath];
    
    FBURecipe *recipe = [self.recipesArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = recipe[@"title"];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipesArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    } else{
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)addRecipesToGroup
{
    NSArray *selectedCells = [self.recipesTableView indexPathsForSelectedRows];
    
    for (NSIndexPath *selectedCell in selectedCells){
        NSIndexPath *indexPath = selectedCell;
        
        FBURecipe *selectedRecipe = self.recipesArray[indexPath.row];
        
        //Add each selected recipe to array of recipes to be presented by the instance of RecipesListViewController
        [self.group addObject:selectedRecipe forKey:@"recipesInGroup"];
        [self.group saveInBackground];
        
        NSLog(@"%@ was added.", selectedRecipe.title);
        NSLog(@"Group's recipes: %@", self.group.recipesInGroup);
    }
}

- (void)addRecipesToEvent
{
    NSArray *selectedCells = [self.recipesTableView indexPathsForSelectedRows];
    
    for (NSIndexPath *selectedCell in selectedCells){
        NSIndexPath *indexPath = selectedCell;
        
        FBURecipe *selectedRecipe = self.recipesArray[indexPath.row];
        
        //Add each selected recipe to array of recipes to be presented by the instance of RecipesListViewController
        [self.event addObject:selectedRecipe forKey:@"recipesInEvent"];
        [self.event saveInBackground];
        
        NSLog(@"%@ was added.", selectedRecipe.title);
        NSLog(@"Event's recipes: %@", self.event.recipesInEvent);
    }
}

@end
