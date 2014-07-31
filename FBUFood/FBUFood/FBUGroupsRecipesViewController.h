//
//  FBUGroupsRecipesViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/30/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FBUGroup.h"

@interface FBUGroupsRecipesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *recipesTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addRecipesButton;

@property (strong, nonatomic) FBUGroup *group;
@end
