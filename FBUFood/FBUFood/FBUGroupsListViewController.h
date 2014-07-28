//
//  FBUGroupsListViewController.h
//  FBUFood
//
//  Created by Uma Girkar on 7/11/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBUGroup.h"

@interface FBUGroupsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *createGroupButton;
@property (weak, nonatomic) IBOutlet UITableView *myGroupsTableView;

@property (strong, nonatomic) NSArray *myGroupsArray;


@end
