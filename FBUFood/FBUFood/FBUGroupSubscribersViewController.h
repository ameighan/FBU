//
//  FBUGroupSubscribersViewController.h
//  FBUFood
//
//  Created by Jennifer Zhang on 7/23/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBUGroup.h"

@interface FBUGroupSubscribersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *subscribersTableView;

@property (strong, nonatomic) FBUGroup *group;

@end
