//
//  FBUEventViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/22/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBUEvent.h"

@interface FBUEventViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FBUEvent *event;

@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventRecipesLabel;
@property (weak, nonatomic) IBOutlet UITableView *eventRecipesTableView;
@property (weak, nonatomic) IBOutlet UILabel *eventUsersLabel;
@property (weak, nonatomic) IBOutlet UITableView *eventUsersTableView;
@property (weak, nonatomic) IBOutlet UIButton *eventJoinButton;

@property (weak, nonatomic) NSArray *peopleGoing;

@end
