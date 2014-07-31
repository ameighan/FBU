//
//  FBURecipesListViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FBURecipe.h"

@interface FBURecipesListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *recipeArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

-(void)queryForRecipes;



@end
