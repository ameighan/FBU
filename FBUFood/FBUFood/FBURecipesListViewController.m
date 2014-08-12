//
//  FBURecipesListViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBURecipesListViewController.h"
#import <Parse/Parse.h>
#import "FBURecipe.h"
#import "FBURecipeViewController.h"
#import "FBUEditRecipeViewController.h"



@implementation FBURecipesListViewController

@synthesize recipeArray, tableView;

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.tableView.isEditing) {
        [sender setTitle:@"Edit"];
        [self.tableView setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done"];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *myItems = [[NSMutableArray alloc]initWithArray:self.recipeArray];
        [myItems removeObject:self.recipeArray[indexPath.row]];
        [self.recipeArray[indexPath.row] deleteInBackground];
        self.recipeArray = myItems;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *myImage = [UIImage imageNamed:@"RecipeList.jpg"];
    [self.imageView setImage:myImage];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryForRecipes) name:@"savedToParse" object:nil];
    if (self.recipeArray == nil) {
        [self queryForRecipes];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(void)queryForRecipes
{
    __weak FBURecipesListViewController *blockSelf = self;
    PFQuery *getRecipes = [FBURecipe query];
    [getRecipes whereKey:@"publisher" equalTo:[PFUser currentUser]];
    [getRecipes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        blockSelf.recipeArray = objects;
        [blockSelf.tableView reloadData];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    FBURecipe *recipe = [self.recipeArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = recipe[@"title"];
    cell.imageView.image = [UIImage imageWithData:[recipe.image getData]];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipeArray count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"cellToDetailView"]){
        
        FBURecipeViewController *controller = (FBURecipeViewController *)segue.destinationViewController;
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        controller.recipe = self.recipeArray[ip.row];

    } else if ([segue.identifier isEqualToString:@"listViewToEditView"]){
        
        FBUEditRecipeViewController *controller = (FBUEditRecipeViewController *)segue.destinationViewController;
        controller.title = @"New Recipe";

        
    }
}

- (IBAction)unwindToRecipeListViewController:(UIStoryboardSegue *)segue
{
    if([segue.identifier isEqualToString:@"save"]) {
        FBUEditRecipeViewController *controller = segue.sourceViewController;
        [controller saveRecipe];
    }
}


@end
