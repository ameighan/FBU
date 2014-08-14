//
//  FBUGroceryListViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 8/8/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBUGroceryList.h"

@interface FBUGroceryListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FBUGroceryList *groceryList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
