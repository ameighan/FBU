//
//  FBUBucketListViewController.h
//  FBUFood
//
//  Created by Uma Girkar on 7/21/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBUBucketListItem.h"

@interface FBUBucketListViewController: UIViewController

@property (strong, nonatomic) FBUBucketListItem *item;

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfBucketListItem;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
