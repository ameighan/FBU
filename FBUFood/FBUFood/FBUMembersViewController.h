//
//  FBUMembersViewController.h
//  FBUFood
//
//  Created by Uma Girkar on 7/25/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FBUGroup;

@interface FBUMembersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *membersTableView;
@property (strong, nonatomic) NSArray *membersArray;
@property (weak, nonatomic) FBUGroup *group;

@end
