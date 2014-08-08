//
//  FBUBucketListItemsViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUBucketListItemsViewController.h"
#import "FBUBucketListDetailViewController.h"
#import "FBUBucketListItem.h"
#import "FBUBucketListViewController.h"
#import <Parse/Parse.h>

@implementation FBUBucketListItemsViewController

- (NSArray *)queryingForBucketListItems
{
    PFQuery *query = [FBUBucketListItem query];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    return [query findObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BucketListCell"
                                                            forIndexPath:indexPath];
    FBUBucketListItem *bucketItem = self.items[indexPath.row];
    cell.textLabel.text = [bucketItem itemName];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"BucketListCell" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BucketListCell"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        FBUBucketListItem *myItem = self.items[indexPath.row];
        
        FBUBucketListViewController *itemsViewController = segue.destinationViewController;
        
        itemsViewController.item = myItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BucketListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIImage *myImage = [UIImage imageNamed:@"BucketList.png"];
    [self.imageView setImage:myImage];
    UIImage *newButtonImage = [UIImage imageNamed:@"New.png"];
    [self.myImageView setImage:newButtonImage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.items = [self queryingForBucketListItems];
    [self.tableView reloadData];
}

@end
