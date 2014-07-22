//
//  FBUBucketListViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 7/21/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUBucketListViewController.h"
#import "FBUBucketListItemsViewController.h"
#import "FBUBucketListItem.h"

@implementation FBUBucketListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemNameLabel.text = self.item.itemName;
}

@end
