//
//  FBUBucketListItemsViewController.h
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUBucketListItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (strong, nonatomic) NSArray *items;

@end
