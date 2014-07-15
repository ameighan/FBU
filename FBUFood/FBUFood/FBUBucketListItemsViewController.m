//
//  FBUBucketListItemsViewController.m
//  FBUFood
//
//  Created by Uma Girkar on 7/14/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUBucketListItemsViewController.h"
#import "FBUBucketListDetailViewController.h"
#import "FBUBucketListItemStore.h"
#import "FBUBucketListItem.h"

@interface FBUBucketListItemsViewController()

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) NSArray *items;

@end

@implementation FBUBucketListItemsViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    FBUBucketListItem *item = self.items[indexPath.row];
    cell.textLabel.text = [item description];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.items = [[FBUBucketListItemStore sharedStore] allItems];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.items count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBUBucketListDetailViewController *detailViewController = [[FBUBucketListDetailViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)addNewItem:(id)sender
{
    
}

- (IBAction)toggleEditingMode:(id)sender
{
    
}

@end
