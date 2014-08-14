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
#import "FBUBucketListDetailViewController.h"

@implementation FBUBucketListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.itemNameLabel.text = self.item.itemName;
    UIImage *image = [UIImage imageWithData:[self.item.picture getData]];
    self.imageOfBucketListItem.image = image;
    UIImage *backImage = [UIImage imageNamed:@"Imagination.jpg"];
    [self.backgroundImageView setImage:backImage];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailToEditViewController"]){
        
        FBUBucketListDetailViewController *controller = (FBUBucketListDetailViewController *)segue.destinationViewController;
        controller.title = @"Edit Bucket List Item";
        controller.item = self.item;
        
    }
}

@end
