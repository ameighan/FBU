//
//  FBUGroceryListViewController.m
//  FBUFood
//
//  Created by Jennifer Zhang on 8/8/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroceryListViewController.h"

@interface FBUGroceryListViewController ()

@end

@implementation FBUGroceryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.groceryList fillInGroceryList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groceryCell"
                                                            forIndexPath:indexPath];
    
    NSString *ingredient = self.groceryList.ingredientsToBuy[indexPath.row];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir" size:17.0]];
    [cell.textLabel setTintColor:[UIColor blackColor]];
    cell.textLabel.text = ingredient;
    NSLog(@"%@", ingredient);
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groceryList.ingredientsToBuy count];
}


@end
