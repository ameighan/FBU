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

@interface FBUBucketListItemsViewController()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) NSArray *items;

@end

@implementation FBUBucketListItemsViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    FBUBucketListItem *item = [[FBUBucketListItem alloc] init];
    cell.textLabel.text = [item description];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 5;
    return num;
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
