//
//  FBUExploreViewController.h
//  FBUFood
//
//  Created by Uma Girkar on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUExploreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cravingLabel;
@property (weak, nonatomic) IBOutlet UITextField *cravingTextField;
@property (weak, nonatomic) IBOutlet UILabel *groupInterestLabel;
@property (weak, nonatomic) IBOutlet UITableView *groupsTable;
@property (weak, nonatomic) IBOutlet UIButton *enterCravingsButton;

@property (strong, nonatomic) NSArray *exploratoryGroups;
@property (strong, nonatomic) NSArray *displayedGroups;
@property (strong, nonatomic) NSMutableArray *specificGroups;

@end
