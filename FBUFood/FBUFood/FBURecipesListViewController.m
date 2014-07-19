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

@interface FBURecipesListViewController ()

@property (strong, nonatomic) FBURecipe *recipe;

@end

@implementation FBURecipesListViewController

@synthesize recipeArray, tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryForRecipes) name:@"savedToParse" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self queryForRecipes];
}


-(void)queryForRecipes
{
    __weak FBURecipesListViewController *blockSelf = self;
    PFQuery *getRecipes = [FBURecipe query];
//    PFQuery *getRecipes = [PFQuery queryWithClassName:@"Recipe"];
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
        
    }
}



@end
