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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groceryCell"
                                                            forIndexPath:indexPath];
    
    
    NSString *ingredient = self.groceryList.ingredientsToBuy[indexPath.row];
    
    cell.textLabel.text = ingredient;
    NSLog(@"%@", ingredient);
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groceryList.ingredientsToBuy count];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
